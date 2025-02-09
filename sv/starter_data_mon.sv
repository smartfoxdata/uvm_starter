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

// This component monitors the starter interface, which connects to the data and valid signals of the DUT.
// Each valid signal pulse indicates a transaction.
// The virtual interface is set at the testbench top (starter_top.sv). It uses a virtual interface (starter_if) to monitor the DUT ports. The build_phase checks that the virtual interface gets set.
// A uvm_sequence_item object (starter_data_txn) instance is used to store each observed transaction.
// Each uvm_sequence_item instance representing an observed transaction is written to a uvm_analysis_port.

class starter_data_mon extends uvm_monitor;
  protected virtual starter_data_if vif;
  protected starter_data_txn txn;
  uvm_analysis_port #(starter_data_txn) item_collected_port;

  `uvm_component_utils(starter_data_mon)
  
  function new (string name="starter_data_mon", uvm_component parent);
    super.new(name, parent);
    txn = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual starter_data_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ",get_full_name(), ".vif"});
  endfunction

  virtual task run_phase (uvm_phase phase);
	fork
      collect_transactions();
    join
  endtask

  virtual protected task collect_transactions();
	forever begin
      txn = new();
      if (vif.rst == 'b1)
        @(negedge vif.rst);
      @(posedge vif.valid);
      txn.data = vif.data;
      @(negedge vif.valid);
      `uvm_info("collect_transactions", txn.convert2string(), UVM_LOW);
      item_collected_port.write(txn);
    end
  endtask
endclass
