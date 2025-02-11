////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2025 Smartfox Data Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

// This component drives a set of data and valid interface to the DUT.
// It uses a virtual interface (starter_data_if) to drive the DUT ports. The virtual interface is set at the testbench top (starter_top.sv). In the build_phase, it checks that the virtual interface gets set.
// During the run phase, it reads the next uvm_sequence_item object (starter_data_txn) from the seq_item_port, which is already part of the uvm_driver base class.
// Each sequence item represents the transaction to drive to the DUT. In our example, the transaction is just the 8-bit value to drive to the data signal along with a valid signal data pulse.
// Also while in the run phase, the reset signal is checked and the data and valid signals are driven to 0 during reset condition.

class starter_data_drv extends uvm_driver #(starter_data_txn);
  protected virtual starter_data_if vif;
  protected starter_data_cfg cfg;
  
  `uvm_component_utils(starter_data_drv)

  function new (string name="starter_data_drv", uvm_component parent);
    super.new(name, parent);
  endfunction // new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual starter_data_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ",
                           get_full_name(), ".vif"});
    if(!uvm_config_db#(starter_data_cfg)::get(this, "", "cfg", cfg)) begin
      `uvm_info("build_phase","starter_data_cfg object is not set. Using default.", UVM_LOW);
      cfg = starter_data_cfg::type_id::create("cfg", this);
    end
    `uvm_info("build_phase", cfg.convert2string(), UVM_LOW);
  endfunction

  virtual task run_phase (uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
	join
  endtask

  virtual protected task get_and_drive();
    bit [2:0] cycles = 0;
    forever begin
      @(posedge vif.clk);
      if (vif.rst == 1'b1) begin
        @(negedge vif.rst);
        @(posedge vif.clk);
      end
      if (cfg.idle_cycles_on)
        cycles = $urandom;
      repeat (cycles)
        @(posedge vif.clk);
      seq_item_port.get_next_item(req);
      `uvm_info("get_and_drive", req.convert2string(), UVM_LOW)
      vif.data <= req.data;
      vif.valid <= 'b1;
      @(posedge vif.clk);
      vif.valid <= 'b0;
      @(posedge vif.clk);
      seq_item_port.item_done();
    end    
  endtask

  virtual protected task reset_signals();
    forever begin
      @(posedge vif.rst);
      vif.data <= 'h0;
      vif.valid <= 'b0;
	end
  endtask
endclass
