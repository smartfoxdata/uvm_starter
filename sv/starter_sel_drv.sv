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

// This component drives the sel interface to the DUT.
// It uses a virtual interface (starter_sel_if) to drive the DUT ports. The virtual interface is set at the testbench top (starter_top.sv). In the build_phase, it checks that the virtual interface gets set.
// During the run phase, it reads the next uvm_sequence_item object (starter_sel_txn) from the seq_item_port, which is already part of the uvm_driver base class.
// Each sequence item represents the transaction to drive to the DUT. In our example, the transaction is just the sel bit value to drive the sel port of the DUT.
// Also while in the run phase, the reset signal is checked and the sel signal is driven to 1'bx during reset condition.

class starter_sel_drv extends uvm_driver #(starter_sel_txn);
  protected virtual starter_sel_if vif;
  
  `uvm_component_utils(starter_sel_drv)

  function new (string name="starter_sel_drv", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual starter_sel_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ",
                           get_full_name(), ".vif"});
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask

  virtual protected task get_and_drive();
    forever begin
      @(posedge vif.clk);
      if (vif.rst == 1'b1) begin
        @(negedge vif.rst);
        @(posedge vif.clk);
      end
      seq_item_port.get_next_item(req);
      `uvm_info("get_and_drive", req.convert2string(), UVM_LOW)
      vif.sel <= req.sel;
      seq_item_port.item_done();
    end
  endtask

  virtual protected task reset_signals();
    forever begin
      @(posedge vif.rst);
      vif.sel <= 'bx;
    end
  endtask
endclass
