# Theory of Operation

## Block Diagram

![](../doc/kmac-block-diagram.svg)

The above figure shows the KMAC/SHA3 HWIP block diagram.
The KMAC has register interfaces for SW to configure the module, initiate the hashing process, and acquire the result digest from the STATE memory region.
It also has a sidleoad interface to the KeyMgr to get a secret key for KMAC operation.
The key is always Boolean masked with two shares.
The IP has N x [application interfaces](#application-interface), which allows other HWIPs to request hashing operations.
An application interface can either be static where the hashing operation is predefined at compile-time or it can be dynamic where the application can select the hashing mode at runtime.

Similar to HMAC, the KMAC HWIP also has a message FIFO (MSG_FIFO) whose depth was determined based on a few criteria such as the register interface width, and its latency, the latency of hashing algorithm (Keccak).
Based on the given criteria, the MSG_FIFO depth was determined to store the incoming message while the SHA3 core is in computation.

To support partial writes from SW and an app interface, the MSG_FIFO has a packer in front which packs writes to the size of the internal datapath (64bit).
It frees the software from having to align the messages and it also simplifies the app interface when the message length must be appended (for KMAC operation).
Note that this FIFO is bypassed if the application interface is configured to send the message in shares.

The fed messages go into the KMAC core regardless of KMAC enabled or not.
The KMAC core forwards the messages to SHA3 core in case KMAC hash functionality is disabled.
When performing a KMAC operation, the KMAC core prepends the encoded secret key as described in the SHA3 Derived Functions specification.
It is expected that the software writes the encoded output length at the end of the message.
For hashing operations triggered by an IP through the application interface, the encoded output length is appended inside the AppIntf module in the KMAC HWIP.

The KMAC/SHA3 HWIP takes the key for KMAC operations either from the [`KEY_SHARE0`](registers.md#key_share0) and [`KEY_SHARE1`](registers.md#key_share1) registers or from the sideload interface connected to the key manager.
The software can set [`CFG_SHADOWED.sideload`](registers.md#cfg_shadowed) to use the sideloaded key for the SW and app-initiated KMAC operations.
The key manager provides the sideloaded key always in two-share masked form regardless of the compile-time parameter `EnMasking`.
If `EnMasking` is not defined, the KMAC converts the shared key to the unmasked form before the key is used.

The SHA3 core is the main Keccak processing module.
It supports SHA3 hashing functions, SHAKE128, SHAKE256 extended output functions, and also cSHAKE128, cSHAKE256 functions in order to support KMAC operation.
To support multiple hashing functions, it has the padding logic inside.
The padding logic mainly pads the predefined bits at the end of the message and also performs `pad10*1()` function.
If cSHAKE mode is set, the padding logic also prepends the encoded function name `N` and the customization string `S` prior to the incoming messages according to the spec requirements.

Both the internal state width and the masking of the Keccak core are configurable via compile-time Verilog parameters.
By default, 1600 bits of internal state are used and stored in two shares (1st order masking).
The masked Keccak core takes 4 clock cycles per round if sufficient entropy is available.
If desired, the masking can be disabled and the internal state width can be reduced to 25, 50, or 100 bits at compile time.

## Design Details

### Keccak Round

A Keccak round implements the Keccak_f function described in the SHA3 specification.
Keccak round logic in KMAC/SHA3 HWIP not only supports 1600 bit internal states but also all possible values {50, 100, 200, 400, 800, 1600} based on a parameter `Width`.
If masking is disabled via compile-time Verilog parameter `EnMasking`, also 25 can be selected as state width.
Keccak permutations in the specification allow arbitrary number of rounds.
This module, however, supports Keccak_f which always runs `12 + 2*L` rounds, where $$ L = log_2 {( {Width \over 25} )} $$ .
For instance, 200 bits of internal state run 18 rounds.
KMAC/SHA3 instantiates the Keccak round module with 1600 bit.

![](../doc/keccak-round.svg)

Keccak round logic has two phases inside.
Theta, Rho, Pi functions are executed at the 1st phase.
Chi and Iota functions run at the 2nd phase.
If the compile-time Verilog parameter `EnMasking` is not set, i.e., if masking is not enabled, the first phase and the second phase run at the same cycle.

If masking is enabled, the Keccak round logic stores the intermediate state after processing the 1st phase.
The stored values are then fed into the 2nd phase computing the Chi and Iota functions.
The Chi function leverages first-order [Domain-Oriented Masking (DOM)](https://eprint.iacr.org/2017/395.pdf) to deter SCA attacks.

To balance circuit area and SCA hardening, the Chi function uses 800 instead 1600 DOM multipliers but the multipliers are fully pipelined.
The Chi and Iota functions are thus separately applied to the two halves of the state and the 2nd phase takes in total three clock cycles to complete.
In the first clock cycle of the 2nd phase, the first stage of Chi is computed for the first lane halves of the state.
In the second clock cycle, the new first lane halves are output and written to state register.
At the same time, the first stage of Chi is computed for the second lane halves.
In the third clock cycle, the new second lane halves are output and written to the state register.

The 800 DOM multipliers need 800 bits of fresh entropy for remasking.
If fresh entropy is not available, the DOM multipliers do not move forward and the 2nd phase will take more than three clock cycles.
Processing a Keccak_f (1600 bit state) takes a total of 96 cycles (24 rounds X 4 cycles/round) including the 1st and 2nd phases.

If the masking compile time option is enabled, Keccak round logic requires an additional 3200 flip flops to store the intermediate half state inside the 800 DOM multipliers.
In addition to that Keccak round logic needs two sets of the same Theta, Rho, and Pi functions.
As a result, the masked Keccak round logic takes more than twice as much as area than the unmasked version of it.

### Padding for Keccak

Padding logic supports SHA3/SHAKE/cSHAKE algorithms.
cSHAKE needs the extra inputs for the Function-name `N` and the Customization string `S`.
Other than that, SHA3, SHAKE, and cSHAKE share similar datapath inside the padding module except the last part added next to the end of the message.
SHA3 adds `2'b 10`, SHAKE adds `4'b 1111`, cSHAKE adds `2'b00` then `pad10*1()` follows.
All are little-endian values.

Interface between this padding logic and the MSG_FIFO follows the conventional FIFO interface.
So `prim_fifo_*` can talk to the padding logic directly.
This module talks to Keccak round logic with a more memory-like interface.
The interface has an additional address signal on top of the valid, ready, and data signals.

![](../doc/sha3-padding.svg)

The hashing process begins when the software issues the start command to [`CMD`](registers.md#cmd) .
If cSHAKE is enabled, the padding logic expands the prefix value (`N || S` above) into a block size.
The block size is determined by the [`CFG_SHADOWED.kstrength`](registers.md#cfg_shadowed) .
If the value is 128, the block size will be 168 bytes.
If it is 256, the block size will be 136 bytes.
The expanded prefix value is transmitted to the Keccak round logic.
After sending the block size, the padding logic triggers the Keccak round logic to run a full 24 rounds.

If the mode is not cSHAKE, or cSHAKE mode and the prefix block has been processed, the padding logic accepts the incoming message bitstream and forward the data to the Keccak round logic in a block granularity.
The padding logic controls the data flow and makes the Keccak logic to run after sending a block size.

After the software writes the message bitstream, it should issue the Process command into [`CMD`](registers.md#cmd) register.
The padding logic, after receiving the Process command, appends proper ending bits with respect to the [`CFG_SHADOWED.mode`](registers.md#cfg_shadowed) value.
The logic writes 0 up to the block size to the Keccak round logic then ends with 1 at the end of the block.

![](../doc/sha3-padding-fsm.svg)

After the Keccak round completes the last block, the padding logic asserts an `absorbed` signal to notify the software.
The signal generates the `kmac_done` interrupt.
At this point, the software is able to read the digest in [`STATE`](registers.md#state) memory region.
If the output length is greater than the Keccak block rate in SHAKE and cSHAKE mode, the software may run the Keccak round manually by issuing Run command to [`CMD`](registers.md#cmd) register.

The software completes the operation by issuing Done command after reading the digest.
The padding logic clears internal variables and goes back to Idle state.

### Padding for KMAC

![](../doc/kmac-padding.svg)

KMAC core prepends and appends additional bitstream on top of Keccak padding logic in SHA3 core.
The [NIST SP 800-185](https://csrc.nist.gov/publications/detail/sp/800-185/final) defines `KMAC[128,256](K, X, L, S)` as a cSHAKE function.
See the section 4.3 in NIST SP 800-185 for details.
If KMAC is enabled, the software should configure [`CMD.mode`](registers.md#cmd) to cSHAKE and the first six bytes of [`PREFIX`](registers.md#prefix) to `0x01204B4D4143` (bigendian).
The first six bytes of [`PREFIX`](registers.md#prefix) represents the value of `encode_string("KMAC")`.

The KMAC padding logic prepends a block containing the encoded secret key to the output message.
The KMAC first sends the block of secret key then accepts the incoming message bitstream.
At the end of the message, the software writes `right_encode(output_length)` to MSG_FIFO prior to issue Process command.

### Message FIFO

The KMAC HWIP has a compile-time configurable depth message FIFO inside.
The message FIFO receives incoming message bitstream regardless of its byte position in a word.
Then it packs the partial message bytes into the internal 64 bit data width.
After packing the data, the logic stores the data into the FIFO until the internal KMAC/SHA3 engine consumes the data.

> This FIFO only supports plain data.
> Therefore, it is bypassed for app interfaces which operate on shared data.

#### FIFO Depth calculation

The depth of the message FIFO is chosen to cover the throughput of the software or other producers such as DMA engine.
The size of the message FIFO is enough to hold the incoming data while the SHA3 engine is processing the previous block.
Details are in `kmac_pkg::MsgFifoDepth` parameter.
Default design parameters assume the system characteristics as below:

- `kmac_pkg::RegLatency`: The register write takes 5 cycles.
- `kmac_pkg::Sha3Latency`: Keccak round latency takes 96 cycles, which is the masked version of the Keccak round.

#### Empty and Full status

Under normal operating conditions, the SHA3 engine will process data a lot faster than software can push it to the Message FIFO.
The Message FIFO depth observable from [`STATUS.fifo_depth`](registers.md#status--fifo_depth) will remain **0** while the [`STATUS.fifo_empty`](registers.md#status--fifo_empty) status bit is lowered for one clock cycle whenever software provides new data.

However, if the SHA3 engine is currently busy or if the KMAC block is waiting for fresh entropy from EDN, the Message FIFO may actually run full (indicated by the `fifo_full` status bit).
Resolving these conditions may take hundreds of cycles or more.
After the SHA3 engine starts popping the data again, the Message FIFO will eventually run empty again and the `fifo_empty` status interrupt will fire.
Note that the `fifo_empty` status interrupt will not fire if i) one of the hardware application interfaces is using the KMAC block, ii) the SHA3 core is not in the `Absorb` state, or iii) after software has written the `Process` command.

If software pushes data to the Message FIFO while it is full, the write operation is blocked until there is again space in the FIFO.
This means the processor is effectively stalled.
If the SHA3 engine is currently running and software fills up the Message FIFO, the resulting stall won't take more than 100 clock cycles.
The stall mechanism prevents data loss and the upper bound on the wait time avoids software needing to poll the [`STATUS.fifo_depth`](registers.md#status--fifo_depth) field before writing data.

However, the FIFO can also become full because the KMAC block is waiting for fresh entropy from EDN.
Resolving this condition can take much longer, and it can even result in deadlocking the system if the following conditions are met:
1. Software attempts to push data to the Message FIFO while it is full.
1. The fresh entropy is not delivered and the value of the [`ENTROPY_PERIOD`](registers.md#entropy_period) register is 0, meaning the wait timer never expires.

The entropy not getting delivered in time can in particular happen if the entropy complex or parts of it are disabled, e.g., [to save power](../../csrng/doc/programmers_guide.md#running-csrng-with-entropy_src-disabled).
Refer to [Preventing potential deadlocks in EDN mode](programmers_guide.md#preventing-potential-deadlocks-in-edn-mode) for guidance on how to safely avoid this scenario.


#### Masking

The hashing engine supports a fully masked operation if the `EnMasking` parameter is set.
The software however can only push unmasked messages into the hashing engine.
The app interfaces operate depending on their compile-time parameter either on plain or masked data.

For all cases, if the `EnMasking` parameter is set and [`CFG_SHADOWED.msg_mask`](registers.md#cfg_shadowed) is enabled, the message is masked (or re-masked) upon loading into the Keccak core using the internal entropy generator.
The secret key is always stored/used in the masked form.

If the `EnMasking` parameter is not set, the masking is disabled and the software has to provide the key in unmasked form by default.
Any write operations to [`KEY_SHARE1_0`](registers.md#key_share1) - [`KEY_SHARE1_15`](registers.md#key_share1) are ignored.

If the `EnMasking` parameter is not set and the `SwKeyMasked` parameter is set, software has to provide the key in masked form.
Internally, the design then unmasks the key by XORing the two key shares together when loading the key into the engine.
This is useful when software interface compatibility between the masked and unmasked configuration is desirable.

If the `EnMasking` parameter is set, the `SwKeyMasked` parameter has no effect: Software always must provide the key in two shares.

### Keccak State Access

After the Keccak round completes the KMAC/SHA3 operation, the contents of the Keccak state contain the digest value.
The software can access the 1600 bit of the Keccak state directly through the window of the KMAC/SHA3 register.

If the compile-time parameter masking feature is enabled, the upper 256B of the window is the second share of the Keccak state.
The software can read both of the Keccak state shares and can recover the plain, unmasked digest value by XORing the two shares.
If `EnMasking` is not set, the upper address space reads as zero.

The Keccak state is valid after the sponge absorbing process is completed.
While in an idle state or in the sponge absorbing stage, the value is zero.
This ensures that the logic does not expose the secret key XORed with the keccak_f results of the prefix to the software.
In addition to that, the KMAC/SHA3 blocks the software access to the Keccak state when it processes the request from KeyMgr for Key Derivation Function (KDF).

### Application Interfaces

The IP has N instances of an application interface.
Each of these interface can be either static or dynamic.
A static interface has the hashing operation defined as a compile-time parameter in its `kmac_pkg::AppCfg` struct and only a fixed digest length is returned.
A dynamic interface can specify the hashing operation at runtime and supports XOF operation (eXtendable Output Function) where an unlimited digest size can be retrieved.

In the current version of IP, there are the following application interfaces implemented:

| Index | App      | Type    | Algorithm | Prefix     |
|-------|----------|---------|-----------|------------|
| 0     | KeyMgr   | Static  | KMAC      | "KMAC"     |
| 1     | LC_CTRL  | Static  | cSHAKE128 | "LC_CTRL"  |
| 2     | ROM_CTRL | Static  | cSHAKE256 | "ROM_CTRL" |
| 3     | OTBN     | Dynamic | Dynamic   | "KMAC" for KMAC, otherwise taken from CSRs. |

#### Interface channels
The interface operates with two fully valid/ready handshaked channels.
The request channel is used by the apps to initiate, control the operation and send the message.
Once the digest is computed, the KMAC sends it back over the response channel.
The signals of the channels are described below.

| Channel  | Signal      | Description |
|----------|-------------|-------------|
| Request  | `req_valid` | The valid signal of the request channel. |
| Request  | `data_s0`   | The first share of the message data. |
| Request  | `data_s1`   | The second share of the message data. |
| Request  | `strb`      | The byte-level strobe for the message. Either all-ones, all-zeros (empty message) or a LSB aligned contiguous mask. |
| Request  | `last`      | A flag to signal the end of the message or session. |
| Request  | `req_ready` | The ready signal of the request channel. |
| Response | `rsp_valid` | The valid signal of the response channel. |
| Response | `digest_s0` | First share of the digest data. |
| Response | `digest_s1` | Second share of the digest data. |
| Response | `error`     | A flag which is set if there occurred an error and the app should discard the digest. |
| Response | `finished`  | A flag which is set to acknowledge a session end request. |
| Response | `rsp_ready` | The ready signal of the response channel. |

#### Configuration
The type of an interface as well as its functionality is configured/defined with a struct of type `app_config_t`.
The configuration options are listed in the following table.
Any parameter marked as 'Dynamic' can be configured by a dynamic interface at runtime.
For static interfaces, these parameters are also fixed at compile-time.
Note that output length for KMAC operation is the same as the `digest_sx` signal width (`AppDigestW`).

| Parameter                 | Validity | Description |
|---------------------------|----------|-------------|
| Type                      | Static   | Selects the type of the interface. Either `static` or `dynamic`. |
| Masked                    | Static   | Defines whether the message comes in shares or not. If reset, `data_s1` is tied to `'0`. For static interfaces, if set, the message FIFO is bypassed. For dynamic interfaces the message FIFO is always bypassed. Only relevant if `EnMasking` is set. Note, SW must set `CFG_SHADOWED.msg_mask` that KMAC actually performs the masking. |
| Prefix                    | Static   | A compile-time defined prefix used for cSHAKE or KMAC operations. See PrefixMode when this value is used. |
| EnUnsupportedModeStrength | Static   | If set, non-standard combinations of mode and strength are supported for this dynamic interface. Otherwise a non-standard combination will result in a service rejected error. Has no effect on static interfaces. |
| PrefixMode                | Static   | The PrefixMode determines whether to take the prefix from the CSR or use the hardcoded prefix. For static interfaces, if PrefixMode is set, the Prefix will be used for both cSHAKE and KMAC operations. If reset, the CSR value is used. For dynamic interfaces, PrefixMode has no direct effect. Independently of the value, if the mode is cSHAKE, the CSR prefix is used. If the mode is KMAC, the compile-time value is used. |
| Mode                      | Dynamic  | The hashing mode which is performed. |
| KeccakStrength            | Dynamic  | The strength of the selected mode. Not to be confused with the output length of a hashing operation. |
| EnXof                     | Dynamic  | If set, the app interface will automatically trigger a RUN command once it has pushed the full rate on the response channel. If reset, no squeeze can be performed at all. Usually enabled for SHAKE and cSHAKE and disabled for SHA3 and KMAC. Has no effect on static interfaces. |

The dynamic configuration is sent as first message request and the configuration values are expected to be placed at the following bits in the `data_s0` signal.
| Parameter      | Bits |
|----------------|------|
| KeccakStrength | `[2:0]` |
| Mode           | `[11:10]` |
| EnXof          | `[20]` |

In addition to the static and dynamic configuration, SW must configure the KMAC HW IP prior an app uses its interface.
These configurations are listed in the table below.
See also the KMAC [register description](./registers.md) for a detailed description.
Note that these configuration values are left to the SW as setting these requires system state knowledge, i.e., whether entropy is available.

| CSR / Field                       | Note |
|-----------------------------------|------|
| Prefix                            | See `PrefixMode` configuration when this CSR is relevant. |
| CFG_SHADOWED.entropy_ready        | See register description. |
| CFG_SHADOWED.entropy_mode         | See register description. |
| CFG_SHADOWED.entropy_fast_process | See register description. |
| CFG_SHADOWED.sideload             | If set, use sideloaded key. |
| CFG_SHADOWED.msg_mask             | Whether masking is performed or not. Must be set if `Masked` is set in the configuration. |

#### Message and digest datapath
The image below depicts the message data path and its related control signals.
![](../doc/kmac-data-path.svg)

For both types of interfaces, messages are send using the full width of the `data_sx` width, except for the last message.
The last message is allowed to be a partial or empty message by setting the corresponding byte strobe (`strb`).
A strobe indicating a partial message must always be contiguous and LSBit aligned (lowest bit set and therefore the lowest message byte must always be valid).

Depending on the `Masked` parameter, incoming messages bypass the message FIFO if the parameter is set.
If `Masked` is not set, the incoming message requests are forwarded to the message FIFO.
This parameter has no effect if the KMAC parameter `EnMasking` is not set and the message FIFO is used for both interfaces.

Whereas the message requests make full use of the `data_sx` signal width (`MsgWidth`), the returned digest size depends on the interface's `Type`.
A static interface response uses the full width of the `digest_sx` signal (`AppDigestW`) which allows to transfer the full digest in one response.
For dynamic interfaces, the response carries smaller digest parts (`DynAppDigestW`) and the upper bits of the `digest_sx` are invalid.
The reason for this is that in XOF operation the rate width is not a multiple of `AppDigestW` for all supported mode and strength combinations (see the dynamic interface section for more details).
By limiting the response size, no strobe signal is required which simplifies the response handling on the app side as well as reduces the area impact if the interface should be pipelined.

The number of digest responses can be computed based of the selected mode and strength.
For SHA3, the number of responses is `Strength / DynAppDigestW = Strength / 64`.
> Note, for SHA-224 this does not divide properly.
> Therefore, the interface sends back 4 responses where the last one contains some bits which must be ignored.

For SHAKE, cSHAKE and KMAC the number of responses is `(StateWidth - 2 * Strength ) / DynAppDigestW` where `StateWidth = 1600` as defined in the standard.

Any digest is always returned in two shares.
The `Masked` parameter effects only the message path.
If `EnMasking` is not active, the second share is set to `'0`.

#### Operation principle
The app interface follows the same command order (START, PROCESS, RUN, DONE) as software but commands are implicitly send with message requests.
Inside the app interface a FSM controls the hashing operation.
Its state diagram is shown below and the following explains how an app can use the interface.

To start a session, static apps place a request with the first data (`MsgWidth`) and the corresponding strobe signal.
Dynamic apps place a request with the desired configuration.
The state machine inside the KMAC interface will then select a winner of all outstanding requests based upon a fixed priority.
Then the interface checks the dynamic configuration as well as the readiness of the entropy source if the mode is KMAC (this ensures a key is always properly masked).

If the configuration is valid, the message requests are forwarded to the hashing engine.
This engine then starts absorbing, depending on the hashing mode, the key and prefix data.
Afterwards it starts absorbing the messages from the app interface.
The app can indicate the end of the message by asserting the `last` signal during the last message request.

This `last` request triggers the state machine to append the encoded output length if the hashing mode is KMAC.
The encoded output length is hard coded to `AppDigestW` which is also the size of the `digest_sx` signals.

After the encoded output length is pushed to the KMAC core, the interface logic issues a PROCESS command to run the hashing logic.

Once the hashing operation has completed, the app interface starts to push digests parts.
Note that the KMAC HW IP does not raise a `kmac_done` interrupt if an app is active.
For a static app one full digest is sent (handshaked) and the app interface returns back to its idle state.
For a dynamic app, the interface starts to push the full rate of the hashing operation in `DynAppDigestW` sized responses.
The app itself can exert back pressure on the response channel to control how fast it consumes the digest data.
Once the full rate has been pushed, the app automatically sends a RUN command to the hashing engine if `EnXof` is enabled.
The interface then again waits until the new digest is available and begins again to push responses.
Eventually it will again send a RUN command.

When the app has received the desired amount of responses, it can send another "message" request with the `last` signal asserted.
The interface then will stop sending digest responses and will issue a DONE command.
Then one finish response (`finish` signal set) is sent back to the app to acknowledge the end of the session.
Once the app has send the finish request it must make sure to drain the (pipelined) response channel until the finish response is received.
For this any in-flight digest response can be discarded.
Once the interface has sent the finish response, it will return to its idle state, ready to serve the next app request.

In case `EnXof` is disabled, once the first digest is sent, the interface will just wait for a finish request and not trigger any RUN commands.

```mermaid
stateDiagram-v2
StIdle
StAppCfg
StAppMsg
StAppOutLen
StAppProcess
StAppWait
StAppPushDigest
StAppFinish
StError
StErrorServiceRejected
StErrorWaitAbsorbed
StErrorAwaitSW
StErrorAwaitApp
StSw
StKeyMgrErrKeyNotValid

[*] --> StIdle

StIdle --> StAppCfg: app selected
StIdle --> StSw: Start command

StSw --> StIdle: Done command
StSw --> StKeyMgrErrKeyNotValid: Key used but invalid

StAppCfg --> StError: invalid config
StAppCfg --> StAppMsg: valid config

StAppMsg --> StAppProcess: Last message handshaked && !KMAC
StAppMsg --> StAppOutLen: Last message handshaked && KMAC
StAppMsg --> StKeyMgrErrKeyNotValid: Key used but invalid

StAppOutLen --> StAppProcess: KMAC output length appended

StAppProcess --> StAppWait

StAppWait --> StAppPushDigest: Digest available

StAppPushDigest --> StAppWait: if dynamic interface && digest pushed && EnXof
StAppPushDigest --> StAppFinish: if static interface && first digest part pushed
StAppPushDigest --> StAppFinish: if dynamic interface && finish request

StAppFinish --> StIdle: Finish response sent (or immediately for static)

StKeyMgrErrKeyNotValid --> StError

StError --> StErrorAwaitSW: SW error
StError --> StErrorServiceRejected: Last app message received && ServiceRejected
StError --> StErrorAwaitApp: Last app message received && !ServiceRejected

StErrorServiceRejected --> StIdle: Error response sent

StErrorAwaitApp --> StErrorAwaitSW: Error response sent
StErrorAwaitSW --> StErrorWaitAbsorbed: SW error processed

StErrorWaitAbsorbed --> StIdle: absorbed_i
```

#### Example operation

For a SHAKE operation via a dynamic interface instance the interactions look like shown in the wave below.
First, the app sends a request with the configuration.
Once the interface accepted the app, the app starts sending message parts until in cycle 4 the last message part is sent.
The KMAC then starts processing the data and once finished it starts to send back digest data (states AppProcess and AppWait).
This happens below in cycle 7 (In reality it takes around 100 cycles).
Once the app has received 2 digest parts, it deasserts its rsp_ready (cycle 9) and sends the session end request (cycle 10).
The app then must drain the response channel (cycle 10) and must wait for the finish response to arrive which is sent in cycle 11.

```wavejson
{
  signal: [
    {name: 'App state', wave: '2.22.222...22', data: ["Idle","AppCfg","AppMsg","AppProcess","AppWait","AppPushDigest","AppFinish","Idle"]},
    {},
    ['Request',
    {name: 'req_valid', wave: '01...0....10.'},
    {name: 'data_s0',   wave: 'x2.22x.......', data: ["config"]},
    {name: 'data_s1',   wave: 'x..22x.......'},
    {name: 'strb',      wave: 'x..22x.......', data: ["","0xFF","0x03"]},
    {name: 'last',      wave: 'x0..1x....1x.'},
    {name: 'req_ready', wave: '0.1..0....10.'},
    ],
    {},
    ['Response',
    {name: 'rsp_valid', wave: '0......1....0'},
    {name: 'digest_s0', wave: 'x......222.x.'},
    {name: 'digest_s1', wave: 'x......222.x.'},
    {name: 'error',     wave: 'x......0....x'},
    {name: 'finished',  wave: 'x......0...1x'},
    {name: 'rsp_ready', wave: '1........01.0'},
    ],
  ],
  edge: [],
  foot:{
   tock:0
 },
 config:{hscale:2},
}
```

If the app requires more that all possible digest parts (in this example 3), a RUN command is automatically triggered by the interface.
Note, this example starts when the last message is received and the app stalls the response in cycle 4 for one cycle.

```wavejson
{
  signal: [
    {name: 'App state', wave: '2222...2.2..2', data: ["AppMsg","AppProcess","AppWait","AppPushDigest","AppWait","AppPushDigest","AppWait"]},
    {},
    ['Request',
    {name: 'req_valid', wave: '10...........'},
    {name: 'data_s0',   wave: '2x...........', data: [""]},
    {name: 'data_s1',   wave: '2x...........'},
    {name: 'strb',      wave: '2x...........', data: ["0x03"]},
    {name: 'last',      wave: '1x...........'},
    {name: 'req_ready', wave: '10...........'},
    ],
    {},
    ['Response',
    {name: 'rsp_valid', wave: '0..1...0.1..0'},
    {name: 'digest_s0', wave: 'x..22.2x.222x'},
    {name: 'digest_s1', wave: 'x..22.2x.222x'},
    {name: 'error',     wave: 'x..0...x.0..x'},
    {name: 'finished',  wave: 'x..0...x.0..x'},
    {name: 'rsp_ready', wave: '1...01.......'},
    ],
  ],
  edge: [],
  foot:{
   tock:0
 },
 config:{hscale:2},
}
```

#### Error handling

When an app is active the following errors can occur:

- Terminal state error
- Service rejected error
- Key invalid error

The handling of these errors is described below.

##### Terminal state error
This error occurs if the app FSM entered its terminal error state because:
- The escalate_i signal is asserted.
- The FSM itself entered an invalid state.

The terminal error state leads to a fatal alert in OT domain which will result in a chip reset.
As of this, this error case does not need to end the app session gracefully.
If this error occurs, the app interface will not send a response or handle any message requests.

##### Service rejected error
This error occurs when the configuration is invalid (both dynamic and static) or a KMAC operation is requested when the entropy is not ready.
If the app interface rejects an application request, the messages from the application are still accepted but directly discarded.
As of this no data is ever pushed into the hashing engine.
After the last message request, the app interface then immediately sends a response with garbage data and the error flag set.
It then directly returns into the Idle state without waiting for SW to set the `error_processed` bit.

```wavejson
{
  signal: [
    {name: 'App state', wave: '2.22..2..2', data: ["Idle","AppCfg","StError","ErrorServiceRejected","Idle"]},
    {},
    ['Request',
    {name: 'req_valid', wave: '01....0...'},
    {name: 'data_s0',   wave: 'x2..22x...'},
    {name: 'data_s1',   wave: 'x2..22x...'},
    {name: 'strb',      wave: 'x2...2x...', data: ["0xFF","0x03"]},
    {name: 'last',      wave: 'x0...1x...'},
    {name: 'req_ready', wave: '0..1..0...'},
    ],
    {},
    ['Response',
    {name: 'rsp_valid', wave: '0.....1..0'},
    {name: 'digest_s0', wave: 'x.....2..x'},
    {name: 'digest_s1', wave: 'x.....2..x'},
    {name: 'error',     wave: 'x.1......x'},
    {name: 'finished',  wave: 'x........x'},
    {name: 'rsp_ready', wave: '0.......10'},
    ],
  ],
  edge: [],
  foot:{
   tock:0
 },
 config:{hscale:2},
}
```

#### Key invalid error
This error occurs if the sideloaded key is used but the key is invalid.
The sideloaded key is considered as used when either SW has full control over the KMAC or during the message absorption phase (`StAppMsg`) for an interface.
If during this time the key gets invalidated, the app interface no longer forwards message requests to the hashing engine.
Any incoming requests are discarded.
Once the last message has arrived, the app interface sends an error response (garbage digest with the `error` signal set).
It then waits until SW acknowledged the error by writing to the `error_processed` bit.
The interface then triggers a PROCESS command to bring the hashing engine back into the idle state.
Once the hashing completes the interface returns back to its idle state.
There is no finish response sent.

Note, the acknowledge of the software can also happen before the app accepted the response.
In case the KMAC is controlled by SW the `StErrorAwaitApp` is skipped.

The following wave shows an example where the key invalid error occurs in cycle 4.

```wavejson
{
  signal: [
    {name: 'App state', wave: '2.222.2.2.2.2', data: ["Idle","AppCfg","AppMsg","StError","ErrAwaitApp","ErrAwaitSw","ErrWaitAbsorbed","Idle"]},
    {},
    ['Request',
    {name: 'req_valid', wave: '01....0......'},
    {name: 'data_s0',   wave: 'x2..22x......'},
    {name: 'data_s1',   wave: 'x2..22x......'},
    {name: 'strb',      wave: 'x2...2x......', data: ["0xFF","0x03"]},
    {name: 'last',      wave: 'x0...1x......'},
    {name: 'req_ready', wave: '0..1..0......'},
    ],
    {},
    ['Response',
    {name: 'rsp_valid', wave: '0.....1.0....'},
    {name: 'digest_s0', wave: 'x.....2.x....'},
    {name: 'digest_s1', wave: 'x.....2.x....'},
    {name: 'error',     wave: 'x...1...x....'},
    {name: 'finished',  wave: 'x.......x....'},
    {name: 'rsp_ready', wave: '0......10....'},
    ],
    {},
    {name: 'error_processed_i', wave: '0........10..'}
  ],
  edge: [],
  foot:{
   tock:0
 },
 config:{hscale:2},
}
```

### Entropy Generator

This section explains the entropy generator inside the KMAC HWIP.

KMAC has an entropy generator to provide the design with pseudo-random numbers while processing the secret key block.
The entropy is used for both remasking the DOM multipliers inside the Chi function of the Keccak core as well as for masking the message if [`CFG_SHADOWED.msg_mask`](registers.md#cfg_shadowed) is enabled.

The entropy generator is constructed using a [heavily unrolled Bivium stream cipher primitive](https://eprint.iacr.org/2023/1134).
This allows the module to generate 800 bits of fresh, pseudo-random numbers required by the 800 DOM multipliers for remasking in every clock cycle.

Depending on [`CFG_SHADOWED.entropy_mode`](registers.md#cfg_shadowed), the entropy generator fetches initial entropy from the [Entropy Distribution Network (EDN)][edn] module or software has to provide a seed by writing the [`ENTROPY_SEED`](registers.md#entropy_seed) register 9 times.
The module periodically refreshes the PRNG seed with fresh entropy from EDN.
Software can explicitly request a complete reseed of the PRNG state from EDN through [`CMD.entropy_req`](registers.md#cmd).

[edn]: ../../edn/README.md

### Error Report

This section explains the errors KMAC HWIP raises during the hashing operations, their meanings, and the error handling process.

KMAC HWIP has the error checkers in its internal datapath.
If the checkers detect errors, whether they are triggered by the SW mis-configure, or HW malfunctions, they report the error to [`ERR_CODE`](registers.md#err_code) and raise an `kmac_error` interrupt.
Each error code gives debugging information at the lower 24 bits of [`ERR_CODE`](registers.md#err_code).

Value | Error Code | Description
------|------------|-------------
0x01  | KeyNotValid | In KMAC mode with the sideloaded key, the IP raises an error if the sideloaded secret key is not ready.
0x02  | SwPushedMsgFifo | MsgFifo is updated while not being in the Message Feed state.
0x03  | SwIssuedCmdInAppActive | SW issued a command while the application interface is being used
0x04  | WaitTimerExpired | EDN has not responded within the wait timer limit.
0x05  | IncorrectEntropyMode | When SW sets `entropy_ready`, the `entropy_mode` is neither SW nor EDN.
0x06  | UnexpectedModeStrength | SHA3 mode and Keccak Strength combination is not expected.
0x07  | IncorrectFunctionName | In KMAC mode, the PREFIX has the value other than `encoded_string("KMAC")`
0x08  | SwCmdSequence | SW does not follow the guided sequence, `start` -> `process` -> {`run` ->} `done`
0x09  | SwHashingWithoutEntropyReady | SW requests KMAC op without proper config of Entropy in KMAC. This error occurs if KMAC IP masking feature is enabled.
0x80  | Sha3Control | SW may receive Sha3Control error along with `SwCmdSequence` error. Can be ignored.

#### KeyNotValid (0x01)

The `KeyNotValid` error is raised in the application interface module.
When a KMAC application requests a hashing operation, the module checks if the sideloaded key is ready.
If the key is not ready, the module reports `KeyNotValid` error and moves to dead-end state and waits the IP reset.

This error does not provide any additional information.

#### SwPushedMsgFifo (0x02)

The `SwPushedMsgFifo` error happens when the Message FIFO receives TL-UL transactions while the application interface is busy.
The Message FIFO drops the request.

The IP reports the error with an info field.

Bits    | Name        | Description
--------|-------------|-------------
[23:16] | reserved    | all zero
[15:8]  | kmac_app_st | KMAC_APP FSM state.
[7:0]   | mux_sel     | Current APP Mux selection. 0: None, 1: SW, 2: App

#### SwIssuedCmdInAppActive (0x03)

If the SW issues any commands while the application interface is being used, the module reports `SwIssuedCmdInAppActive` error.
The received command does not affect the Application process.
The request is dropped by the KMAC_APP module.

The lower 3 bits of [`ERR_CODE`](registers.md#err_code) contains the received command from the SW.
#### WaitTimerExpired (0x04)

The timer values set by SW is internally used only when pending EDN request is completed.
Therefore, dynamically changing wait timer cannot be used as a way to poke the timer out of a stalling EDN request.
If a non-zero timer expires, the module cancels the transaction and reports the `WaitTimerExpired` error.

When this error happens, the state machine in KMAC_ENTROPY module moves to Wait state.
In that state, it keeps using the pre-generated entropy and asserting the entropy valid signal.
It asserts the entropy valid signal to complete the current hashing operation.
If the module does not complete, or flush the pending operation, it creates the back pressure to the message FIFO.
Then, the SW may not be able to access the KMAC IP at all, as the crossbar is stuck.

The SW may move the state machine to the reset state by issuing [`CMD.err_processed`](registers.md#cmd).

#### IncorrectEntropyMode (0x05)

If SW misconfigures the entropy mode and let the entropy module prepare the random data, the module reports `IncorrectEntropyMode` error.
The state machine moves to Wait state after reporting the error.

The SW may move the state machine to the reset state by issuing [`CMD.err_processed`](registers.md#cmd).

#### UnexpectedModeStrength (0x06)

When the SW issues `Start` command, the KMAC_ERRCHK module checks the [`CFG_SHADOWED.mode`](registers.md#cfg_shadowed) and [`CFG_SHADOWED.kstrength`](registers.md#cfg_shadowed).
The KMAC HWIP assumes the combinations of two to be **SHA3-224**, **SHA3-256**, **SHA3-384**, **SHA3-512**, **SHAKE-128**, **SHAKE-256**, **cSHAKE-128**, and **cSHAKE-256**.
If the combination of the `mode` and `kstrength` does not fall into above, the module reports the `UnexpectedModeStrength` error.

However, the KMAC HWIP proceeds the hashing operation as other combinations does not cause any malfunctions inside the IP.
The SW may get the incorrect digest value.

#### IncorrectFunctionName (0x07)

If [`CFG_SHADOWED.kmac_en`](registers.md#cfg_shadowed) is set and the SW issues the `Start` command, the KMAC_ERRCHK checks if the [`PREFIX`](registers.md#prefix) has correct function name, `encode_string("KMAC")`.
If the value does not match to the byte form of `encode_string("KMAC")` (`0x4341_4D4B_2001`), it reports the `IncorrectFunctionName` error.

As same as `UnexpectedModeStrength` error, this error does not block the hashing operation.
The SW may get the incorrect signature value.

#### SwCmdSequence (0x08)

The KMAC_ERRCHK module checks the SW issued commands if it follows the guideline.
If the SW issues the command that is not relevant to the current context, the module reports the `SwCmdSequence` error.
The lower 3bits of the [`ERR_CODE`](registers.md#err_code) contains the received command.

This error, however, does not stop the KMAC HWIP.
The incorrect command is dropped at the following datapath, SHA3 core.
