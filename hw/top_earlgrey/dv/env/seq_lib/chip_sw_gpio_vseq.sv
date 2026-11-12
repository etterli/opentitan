// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class chip_sw_gpio_vseq extends chip_sw_base_vseq;
  `uvm_object_utils(chip_sw_gpio_vseq)

    bit [NUM_GPIOS-1:0] gpios_mask = {NUM_GPIOS{1'b1}};
    uint                timeout_ns = 2_000_000;
    // The GPIO instance to test, selected via the plusarg '+gpio_idx'.
    uint                gpio_idx = 0;

  `uvm_object_new

  // Override the base-class impl to pass the GPIO instance to test to SW via the backdoor.
  virtual task cpu_init();
    bit [7:0] gpio_idx_arr[1];

    void'($value$plusargs("gpio_idx=%0d", gpio_idx));
    `DV_CHECK(gpio_idx inside {[0 : NUM_GPIO_INSTS-1]})
    gpio_idx_arr = '{gpio_idx[7:0]};

    super.cpu_init();
    sw_symbol_backdoor_overwrite("gpio_idx_dv", gpio_idx_arr);
  endtask

  virtual task body();
    super.body();

    // Wait until we reach the SW test state.
    `DV_WAIT(cfg.sw_test_status_vif.sw_test_status == SwTestStatusInTest)

    // Only the gpios_if pads of the tested instance are used. Drop their default pulls so that the
    // input test can see when the SW stops driving them.
    gpios_mask = get_gpios_if_mask(gpio_idx);
    for (int i = 0; i < NUM_GPIOS; i++) begin
      if (gpios_mask[i]) begin
        cfg.chip_vif.mios_if.pins_pd[GpiosIfPad[i]] = 1'b0;
        cfg.chip_vif.mios_if.pins_pu[GpiosIfPad[i]] = 1'b0;
      end
    end

    // Run the GPIO output tests.
    gpio_output_test();

    // Run the GPIO input tests.
    gpio_input_test();
  endtask

  virtual task gpio_output_test();
    // Disable GPIOs from being driven as chip inputs.
    cfg.chip_vif.gpios_if.drive_en({NUM_GPIOS{1'b0}});

    `uvm_info(`gfn, "Starting GPIO output test", UVM_LOW)

    // Check for W1 pattern on the GPIO output pins.
    for (int i = 0; i < NUM_GPIOS; i++) begin
      wait_tested_pins(gpio_to_gpios_if(gpio_idx, 1 << i));
    end

    // Wait and check all 0s.
    wait_tested_pins('0);

    // Wait and check all 1s.
    wait_tested_pins(gpios_mask);

    // Check for W0 pattern on the GPIO output pins.
    for (int i = 0; i < NUM_GPIOS; i++) begin
      wait_tested_pins(gpio_to_gpios_if(gpio_idx, ~(1 << i)));
    end

    // Wait and check all 1s.
    wait_tested_pins(gpios_mask);

    // Wait and check all 0s.
    wait_tested_pins('0);
  endtask

  virtual task gpio_input_test();
    // Wait and check all zs - this indicates it is safe to drive GPIOs as inputs.
    wait_tested_pins({NUM_GPIOS{1'bz}}, 1'bz);

    // Enable GPIO in input mode.
    cfg.chip_vif.gpios_if.drive_en(gpios_mask);
    cfg.chip_vif.gpios_if.drive(~gpios_mask);

    `uvm_info(`gfn, "Starting GPIO input test", UVM_LOW)

    // Each GPIO pin flip will cause an interrupt to fire. We need to provide sufficient time to
    // allow the SW to service the interrupt and be ready for the next one. Hence, we add
    // sufficiently long delays between GPIO pin flips.

    // Drive T1 pattern. The positions of an instance are in increasing pin order.
    for (int i = 0; i < NUM_GPIOS; i++) begin
      if (!gpios_mask[i]) continue;
      cfg.chip_vif.cpu_clk_rst_if.wait_clks($urandom_range(1100, 2000));
      cfg.chip_vif.gpios_if.drive_pin(i, 1'b1);
    end

    // Drive T0 pattern.
    for (int i = 0; i < NUM_GPIOS; i++) begin
      if (!gpios_mask[i]) continue;
      cfg.chip_vif.cpu_clk_rst_if.wait_clks($urandom_range(1100, 2000));
      cfg.chip_vif.gpios_if.drive_pin(i, 1'b0);
    end

  endtask

  // Returns the gpios_if pins of the tested instance, the other positions set to `fill`.
  virtual function logic [NUM_GPIOS-1:0] tested_pins(logic fill);
    logic [NUM_GPIOS-1:0] pins = cfg.chip_vif.gpios_if.pins;
    for (int i = 0; i < NUM_GPIOS; i++) if (!gpios_mask[i]) pins[i] = fill;
    return pins;
  endfunction

  // Waits until the gpios_if pins of the tested instance show `exp`.
  virtual task wait_tested_pins(logic [NUM_GPIOS-1:0] exp, logic fill = 1'b0);
    `DV_SPINWAIT(while (tested_pins(fill) !== exp) begin
                   @(cfg.chip_vif.gpios_if.pins);
                 end,
                 $sformatf("Timed out waiting for GPIOs == %0h", exp),
                 timeout_ns,
                 `gfn)
  endtask

endclass : chip_sw_gpio_vseq
