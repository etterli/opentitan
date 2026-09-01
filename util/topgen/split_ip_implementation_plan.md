# Implementation plan: splitting IPs across two power domains

Companion to [split_ip_concept.md](split_ip_concept.md). That document defines *what* a split IP is; this one describes *how* to realize it in `reggen` and `topgen`, with concrete insertion points. All file/line references are to the current `split-ip-concept` branch and will drift — treat them as anchors, not gospel.

## Guiding decisions (from the concept discussion)

- **`partition` is intrinsic to the IP** → it is parsed and owned by `reggen` (identical for every instantiation) and forwarded to `topgen` as a read-only per-entry attribute. Precedent to mirror: `enabled_after_reset` on `Signal` (parsed in `reggen`, consumed in `merge.py`).
- **`domain` / `domain_secondary` are instance-level** → owned by `topgen` (a given IP type can land in different PDs at different tops), read from the module dict in `top_<top>.hjson`.
- **`domain` and `domain_secondary` may be equal** → a split IP can be instantiated with both partitions in a single PD; the intra-IP connections then stay inside that PD's wrapper (handled by the existing same-domain inter-module path — no special-casing).
- **Tooling stays PD-agnostic**: reason only about `domain` / `domain_secondary`; never hard-code Aon/Main or a gating direction.
- The `<ip>_part_primary` / `<ip>_part_secondary` RTL modules and the `<ip>_p2s_t` / `<ip>_s2p_t` structs in `<ip>_pkg` are **designer-provided**, not generated.

## Where each step plugs into the existing flow

`topgen.py::_process_top` order: `extract_clocks` (1279) → block creation → `elaborate_instance` (1290) → `connect_clocks` (1295) → `validate_top` (1303) → `merge_top` (1307) → `complete_topcfg` → `create_alert_lpgs` (1739) → `autoconnect` (1745) → `elab_intermodule` (1748). This runs inside a convergence loop (~1710-1736), so **every new step must be idempotent**.

---

## Phase 0 — `reggen` schema (IP-level static structure)

**0a. `is_split_ip` flag.** `util/reggen/ip_block.py`: add to `OPTIONAL_FIELDS` (94-150), parse with `check_bool` (default `False`), add a dataclass field, thread through the constructor call (405-409) and `_asdict` (549-588).

**0b. `partition` on list entries.** Add an optional `partition` key (values `primary`/`secondary`, default `primary`; `param_list` also accepts `both`). Add a small shared validator (membership check; there is no enum checker in `reggen/lib.py`, so validate with `check_str` + explicit set membership, raising `ValueError`).

| List | Class / file | Change |
|---|---|---|
| CIO (`available_input/output/inout_list`) | `Signal` — `util/reggen/signal.py:19` | add `"partition"` to `check_keys` optional list (21); store `self.partition`; **extend `as_nwt_dict` (55-67) to emit it** (interrupts/alerts/CIOs reach `topgen` only through this method) |
| `interrupt_list` | `Interrupt(Signal)` — `util/reggen/interrupt.py:30` | inherit / add `"partition"` to optional list (33) |
| `alert_list` | `Alert(Signal)` — `util/reggen/alert.py:19` | add `"partition"` to the (currently empty) optional list (21) |
| `inter_signal_list` | `InterSignal` — `util/reggen/inter_signal.py:31` | add to optional list (35) **and** to `_asdict` (77-90) |
| `param_list` | `BaseParam` — `util/reggen/params.py` | add `'partition'` to `OPTIONAL_FIELDS` (15-28), parse in `_parse_parameter` (128-268), add to `BaseParam.as_dict` (47-55); accept `both` |

Inter-signals and params already reach `topgen` via wholesale `_asdict()` / `as_dict()`, so only their serializers need the key. Interrupts/alerts/CIOs need the `as_nwt_dict` change because that method currently emits only `name`/`width`/`type`.

**0c. Partition-keyed `clocking`.** The `clocking` key accepts either a flat list (non-split IP, equivalent to `primary` only) or a `{primary, secondary}` group. `Clocking.from_raw` (`util/reggen/clocking.py`) branches on the shape and tags every `ClockingItem` with the `partition` it was declared in; there is no per-item `partition` key. A single `Clocking` object then holds the items of **all** partitions, with a `partition -> primary item` map, so the "exactly one primary" invariant becomes per partition. Accessors (`clock_signals`, `reset_signals`, `other_clocks`, `get_by_clock`, `items_for`, `get_primary_clock`) take a `partition` argument defaulting to `'primary'` (`None` means all partitions), which keeps every partition-unaware consumer -- `RegBlock.build_blocks`, the register `sync`/`async` validation, `dtgen`, `gen_cfg_md`/`gen_cfg_html`, `topgen/lib.is_shadowed_port` -- byte-identical and semantically correct, since `<ip>_reg_top` and the DIFs are primary-partition-only by design.

Each `ClockingItem` already carries its own `reset`, so the `secondary` sub-list fully describes both the secondary partition's clocks **and** resets -- there is no separate `reset_secondary` key. It may be empty/absent when the secondary partition needs no clock/reset, and specifying it without `is_split_ip` is a `ValueError` in `IpBlock.from_raw`.

`REQUIRED_FIELDS['clocking']` in `util/reggen/ip_block.py` declares the type as `'l|g'`. Those type letters are documentation only (consumed by `gen_selfdoc.py`, which now splits on `|` and renders "list or group"; `util/dashboard/dashboard_validate.py` checks key presence only) -- real type validation lives in the `from_raw` methods.

---

## Phase 1 — `topgen` validation + flat→nested normalization

**1a. Two shapes, one accessor.** There is deliberately **no** normalization pass. A split instance spells `clock_srcs` / `reset_connections` / `clock_group` out per partition; every other instance -- and every crossbar, which can never be split -- keeps the flat form, in the author-facing hjson *and* in the generated `top_<top>.gen.hjson`. Wrapping the flat form in a redundant `{primary: <flat value>}` would churn the generated output of every IP in every top for no benefit, and there is no `<key>_secondary` companion key either.

Both shapes are resolved in exactly one place, in `topgen/lib.py`:

| Helper | Purpose |
|---|---|
| `is_partitioned_conns(val)` | Is this value keyed by partition? Unambiguous: a flat value is either a bare `clock_group` string or a map keyed by port name (`clk_*_i` / `rst_*_ni`), never `primary`. |
| `conn_partitions(instance, key)` | Which partitions does `key` describe? `['primary']` for the flat form. |
| `instance_partitions(instance)` | `conn_partitions(instance, 'clock_srcs')` -- the instance's partitions. |
| `partition_conns(instance, key, partition='primary')` | The connections of one partition. The flat form *is* the primary partition; a scalar (`clock_group`) cannot be per-partition and so applies to all of them. `None` if the instance describes nothing for that partition. |
| `partition_domain(instance, partition, default)` | The partition's power domain; raises if a secondary partition has no `domain_secondary`, which is resolved long before `check_power_domains` runs. |

Because the flat form collapses to a single primary partition, every consumer is written once and needs no `is_split_ip` branch, and crossbars flow through the same code unchanged. That matters for crossbars specifically: `generate_xbars` hands their `clock_connections` / `reset_connections` to `tlgen.validate()`, which reads the port names straight out of those dicts (`tlgen/validate.py:297-300`) and dumps the object verbatim into `xbar_*.gen.hjson`, so their shape is not ours to change.

Generated output mirrors its input: `extract_clocks` writes `clock_connections` (and the defaulted `clock_group`) partition-keyed only when the instance's own `clock_srcs` is.

**1b. `util/topgen/validate.py`.**
- `module_optional` (267-326): add `domain_secondary`. `is_split_ip` is forwarded from the block during elaboration → add it to `module_added` (328-334) so `check_keys` accepts it.
- `check_power_domains` (1184-1203): require `domain_secondary` iff `is_split_ip`, forbid otherwise; validate membership in `top['power']['domains']`; assert `domain != domain_secondary` (v1).
- `validate_reset` (1017-1097) / `validate_clock` (1104-1147) / `check_clocks_resets` (931-975): branch on `is_split_ip` to validate each partition's connection sub-dict against **that partition's** PD (primary→`domain`, secondary→`domain_secondary`), including the per-connection `reset['domain']` check (1062-1065).

---

## Phase 2 — partition→domain resolution in `merge.py`

Helper `partition_domain(module, partition, default)` → `module['domain_secondary']` for `secondary`, else `module.get('domain', default)`.

- `elaborate_instance`: forwards `is_split_ip` onto the instance dict (only when true, to avoid perturbing non-split configs); `partition` already rides along on `param_list` (`as_dict`) and `inter_signal_list` (`_asdict`).
- `amend_interrupt`: interrupt `domain` now `partition_domain(module, signal.partition, default)` (uses the reggen `Interrupt.partition` attribute directly). The existing per-PD `count_pd` / chip-level `intr_vector_pd_*` logic keys off `irq["domain"]`, so it works unchanged once each interrupt carries its partition's PD.
- `amend_pinmux_io`: both the inter-PD CIO port creation loop and the three CIO domain-stamp sites now compute the PD per signal via `partition_domain(m, sig.partition, default)`. A non-split fast-path skip is preserved.

No-op for every non-split IP (all objects are `primary` → `partition_domain` returns the ordinary `domain`); verified with `make -k -C hw top_and_cmdgen` (zero `.gen.hjson` diff).

**Deferred to Phase 3:** alert connection domains. `commit_alert_connections` slices *all* of a module's alerts as one contiguous group in a single `m_domain`; splitting them per partition is a substantial rework tightly coupled with the LPG generalization, so it is done together in Phase 3.

---

## Phase 3 — clocking / reset / LPG + alert domains per partition

**Phase 3a (clocking + reset) -- DONE.** Every consumer of an instance's clock/reset connections resolves them per partition through the `lib` accessors of 1a, so each one is written once for split and non-split IPs alike:

- `extract_clocks`: the single endpoint loop over `module + xbar` now calls the `elaborate_clock_srcs` inner helper once per `instance_partitions(ep)`, with that partition's `clock_srcs`, clock group and `partition_domain()`. Clock-group registration order is unchanged (all modules, primary before secondary, then all crossbars), which matters because it fixes the clkmgr net naming and hint-clock indices.
- `amend_resets`: one loop over `block.clocking.partitions`, walking `block.clocking.items_for(partition)` against that partition's reset connections. Shadow-reset marking stays primary-only.
- `create_alert_lpgs`: an LPG per partition from `block.get_primary_clock(partition)` plus that partition's clock/reset connections; each alert's `partition` selects the LPG it joins.
- `connect_clocks`: the idle-clock search spans all partitions via `block.clocking.items`.
- `validate_reset` / `validate_clock`: validate each partition's connections against `inst.clocking.reset_signals(partition)` / `clock_signals(False, partition)`. `check_partitions()` additionally reports a partition the IP does not have, or a missing one that it does. Reset-net domains stay author-specified per entry, as for existing multi-PD modules.
- `topgen.py::amend_reset_connections`: stamps `partition_domain(end_point, partition, default)` onto each partition's bare-string reset connections. This fixed a latent bug: for a split instance it used to iterate the author's nested dict directly, find no strings, and stamp nothing -- leaving `validate_reset` to fall back to `top['power']['default']`, which is the wrong domain for an Aon primary partition (`top_englishbreakfast` writes its rstmgr primary resets as bare strings and would have hit this).
- `clk_reset_lpg_assigns.tpl` iterates `lib.get_module_partitions(m, domain)`, so a split IP's secondary clocks/resets are discarded from the unused-tie-off sets (previously it only ever saw the primary partition's nets).
- Remaining primary-partition-only reads, by design (`partition_conns(m, key)` with the default partition): `dtgen` -- the DT clock/reset maps come from the block's primary clocking, since registers and DIFs live in the primary partition -- and `topgen.py`'s rstmgr `rst_ni` lookup. `ast` in the `chiplevel.sv.tpl`s needs no change at all, since it is not a split IP and keeps the flat form.

**Phase 3b (alerts) -- `commit_alert_connections`:** alert domains per partition (deferred from Phase 2). It used to slice all `w = len(block.alerts)` alerts as one contiguous group in `m_domain = module['domain']`; a split IP's alerts are now grouped by their `partition`'s PD and each group is sliced/counted into the handler separately (the `count_pd` / `connect_pd` / slice logic). A secondary partition's group is keyed `module_<name>_secondary` so the template can find it.

---

## Phase 4 — `lib.py` filtering helpers

Change single-`domain` matches to "does this module have a partition in this PD?" (`m['domain'] == domain or m.get('domain_secondary') == domain`):
- `get_all_modules` — the primary emission driver; returns the one module dict in **both** PD passes.
- `find_modules`, `idx_of_last_module_with_params`.

Added `get_module_partition(m, domain)` → `'primary'`/`'secondary'` for the templates.

---

## Phase 5 — partition-aware filtering and instantiation

- `util/topgen/templates/toplevel_snippets/module_instantiations.tpl`: for each module returned by `get_all_modules(top, domain)`, emit `u_<name>_part_<partition>` of module type `<type>_part_<partition>`, indexing the partition's `clock_connections`/`reset_connections` and filtering interrupts / alerts / CIOs / inter-module signals to the emitted partition. Scan/DFT ports emit only for the primary partition.
- Same-PD support (added here): `lib.get_module_partitions(m, domain)` returns **both** partitions when they share a PD, and the template loops over them so both are emitted in one pass. The removal of the `domain != domain_secondary` check lives in `check_power_domains` (validate.py).
- `port_intermodule_signals.tpl` / `intermodule_signals.tpl`: unchanged — they already filter by signal `domain`, which is partition-correct once Phase 6 tags each signal's domain.

---

## Phase 6 — auto-connect split IPs: intra-IP structs + intermodule signalling

> **Ordering note:** an earlier draft of this plan scoped this work as "Phase 4" (before `lib.py`/templates). In practice it was implemented *after* them — the partitions must be emitted before the intra-IP crossing is meaningful to test — so it now sits as Phase 6, after `lib.py` (4) and templates (5). The corresponding commit was originally labelled "Phase7" and is renumbered to Phase6 in the rebase.

- **Partition-aware `domain` tagging** for the IP's own `inter_signal_list`: `get_signame_chip` (and the req/rsp resolution in `elab_intermodule`) now derive the domain from the signal's `partition` via `sig_partition_domain(module, sig)` (secondary → `domain_secondary`), so an inter-signal owned by the secondary partition is exposed from `domain_secondary`. Per the concept, inter-signals never route through the `p2s`/`s2p` structs.
- **Auto-connect the intra-IP `p2s`/`s2p` link** — `autoconnect_intra_ip(topcfg)` (called from `autoconnect`, before `elab_intermodule`) pairs, per split IP, a driver (act `req`) with a same-named receiver (act `rcv`) in the other partition and injects `<inst>.<sig>@<drv_part> → <inst>.<sig>@<rcv_part>`. The existing multi-PD machinery (`handle_multi_pd_intersig`) then auto-creates the chip-level signal + PD-level ports (cross-PD), or keeps the connection internal (same-PD).
- **Per-partition-unique signal names**: `filter_index` parses an optional `@partition` qualifier (returns a 4-tuple) and `find_intermodule_signal(..., partition)` filters by it, so the two same-named driver/receiver ends of an intra-IP signal resolve unambiguously. Non-qualified references are byte-identical to before.

---

## Pilot IP (rstmgr) + end-to-end verification

Pilot IP chosen: **rstmgr** — the alert/CPU crash-dump capture logic moves into a secondary partition in the Main PD (primary stays Aon).

1. `hw/ip_templates/rstmgr`: `is_split_ip` + a partition-keyed `clocking` in `rstmgr.hjson.tpl`; real `rstmgr_interpart_p2s_t`/`rstmgr_interpart_s2p_t` structs in `rstmgr_pkg.sv.tpl`; `interpart_p2s`/`interpart_s2p` inter-signals (one per partition, same name); a pseudo secondary alert `fatal_sec_test`; RTL split into `rstmgr_part_primary.sv.tpl` and `rstmgr_part_secondary.sv`; `rstmgr.core.tpl` filelist updated.
2. All three tops' `rstmgr` instances gain nested `clock_srcs`/`reset_connections`/`clock_group` + `domain_secondary`.

### Verification (performed)
- **Backwards-compat**: `make -k -C hw top_and_cmdgen` — no-op diff for non-split IPs (caught and fixed a `default=vars` leak in Phase 0 via class-level attribute defaults).
- **Generation**: inspected generated PD tops — `rstmgr_part_primary` in `earlgrey_pd_aon.sv`, `rstmgr_part_secondary` in `earlgrey_pd_main.sv`, crash-dump moved, `interpart_p2s`/`s2p` crossing the PD boundary via chip-level nets; secondary alert on a Main LPG.
- **Same-PD**: temporarily retargeting the secondary to Aon emits both partitions in one wrapper with internal interpart nets (no chip-level crossing).
- **Elaboration**: `./bazelisk.sh build --//hw/top=earlgrey //hw:verilator_real` → exit 0 (elaboration-first; CDC across the Aon↔Main crossing is a follow-up).

### Follow-up (not yet done)
- CDC synchronizers for the crash-dump register interface across the Aon↔Main boundary.
