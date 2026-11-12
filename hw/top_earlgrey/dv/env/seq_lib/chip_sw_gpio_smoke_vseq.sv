// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This test vseq is paired with SW test `sw/device/tests/gpio_smoketest.c`.
class chip_sw_gpio_smoke_vseq extends chip_sw_base_vseq;
  `uvm_object_utils(chip_sw_gpio_smoke_vseq)

  // We override the SW symbol `kGpioVals` with our own set of random values.
  localparam string SW_SYM_GPIO_VALS = "kGpioVals";
  localparam uint TIMEOUT_NS = 2_000_000;

  // Declared as int to match the SW test.
  rand int gpio_vals[];
  uint num_gpio_vals;
  constraint gpio_vals_c {
    gpio_vals.size() == num_gpio_vals;
  }

  `uvm_object_new

  function void pre_randomize();
    int addr;
    // Find how many bytes the SW allocate for SW_SYM_GPIO_VALS, then convert to word size.
    void'(dv_utils_pkg::sw_symbol_get_addr_size(
              .elf_file({p_sequencer.cfg.sw_images[SwTypeTestSlotA], ".elf"}),
              .symbol(SW_SYM_GPIO_VALS),
              .does_not_exist_ok(0),
              .addr(addr),
              .size(num_gpio_vals)));
    num_gpio_vals /= 4;
  endfunction

  virtual task cpu_init();
    bit [7:0] byte_gpio_vals[];
    super.cpu_init();
    // Need to convert integer array to byte array.
    byte_gpio_vals = new[4 * num_gpio_vals];
    byte_gpio_vals = {<<byte{{<<int{gpio_vals}}}};
    sw_symbol_backdoor_overwrite(SW_SYM_GPIO_VALS, byte_gpio_vals);
  endtask

  virtual task body();
    super.body();

    // Wait until we reach the SW test state.
    `DV_WAIT(cfg.sw_test_status_vif.sw_test_status == SwTestStatusInTest)

    // The SW test drives the same patterns from each GPIO instance in turn, each on its own pads.
    for (int inst = 0; inst < NUM_GPIO_INSTS; inst++) begin
      `uvm_info(`gfn, $sformatf("Starting GPIO output test on instance %0d", inst), UVM_LOW)
      for (int i = 0; i < num_gpio_vals; i++) begin
        wait_gpios(inst, gpio_vals[i][NUM_GPIOS-1:0]);
      end

      // Test walking 1s and 0s.
      for (int i = 0; i < NUM_GPIOS; i++) begin
        logic [NUM_GPIOS-1:0] exp_gpios = (1 << i);
        wait_gpios(inst, exp_gpios);
        wait_gpios(inst, ~exp_gpios);
      end
    end
  endtask

  // Waits until the gpios_if pads reached by GPIO instance `inst` show the pin value `val`.
  virtual task wait_gpios(int inst, logic [NUM_GPIOS-1:0] val);
    bit [NUM_GPIOS-1:0] mask = get_gpios_if_mask(inst);
    logic [NUM_GPIOS-1:0] exp = gpio_to_gpios_if(inst, val);
    `DV_SPINWAIT(while ((cfg.chip_vif.gpios_if.pins & mask) !== exp) begin
                   @(cfg.chip_vif.gpios_if.pins);
                 end,
                 $sformatf("Timed out waiting for GPIO%0d == %0h", inst, val),
                 TIMEOUT_NS,
                 `gfn)
  endtask

endclass
