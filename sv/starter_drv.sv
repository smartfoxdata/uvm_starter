////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2017 Smartfox Data Solutions Inc.
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


class starter_drv extends uvm_driver #(starter_txn);
   protected virtual starter_if vif;
   protected int id;

   `uvm_component_utils_begin(starter_drv)
      `uvm_field_int(id, UVM_DEFAULT)
   `uvm_component_utils_end

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual starter_if)::get(this, "", "vif", vif))
	`uvm_fatal("NOVIF", {"virtual interface must be set for: ",
			     get_full_name(), ".vif"});
   endfunction // build_phase

   virtual task run_phase (uvm_phase phase);
      fork
	 get_and_drive();
	 reset_signals();
      join
   endtask // run_phase

   virtual protected task get_and_drive();
      forever begin
	 @(posedge vif.clk);
	 if (vif.rst == 1'b1) begin
	   @(negedge vif.rst);
 	   @(posedge vif.clk);
	 end
	 seq_item_port.get_next_item(req);
	 `uvm_info("DRV", req.convert2string(), UVM_LOW)
	 vif.data <= req.data;
	 vif.valid <= 'b1;
	 repeat(req.cycles) begin
	    @(posedge vif.clk);
	 end
	 vif.valid <= 'b0;
	 seq_item_port.item_done();
      end
   endtask // get_and_drive

   virtual protected task reset_signals();
      forever begin
	 @(posedge vif.rst);
	 vif.data <= 'h0;
	 vif.valid <= 'b0;
      end
   endtask // reset_signals
   
endclass // starter_drv
