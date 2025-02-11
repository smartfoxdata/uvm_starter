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

// The starter_sb extends from uvm_scoreboard. The scoreboard is a UVM component that receives and checks transaction level objects via TLM analysis ports. The transaction objects are usually sent by UVM monitors that monitor the DUT interfaces.
// In our example, the starter_sb receives and checks starter_data_item and stater_sel_item objects.

// Use the `uvm_analysis_imp_decl macro to declare a TLM export wherein you can define the "write" method.
// The string suffix specified will match the write method. 
// For example, `uvm_analysis_imp_decl(_sel) creates type uvm_analysis_imp_sel TLM port which allows you to define the method write_sel. Whenever a transaction object is sent thru this port then the write_sel method will be called.
`uvm_analysis_imp_decl(_exp0)
`uvm_analysis_imp_decl(_exp1)
`uvm_analysis_imp_decl(_obs)
`uvm_analysis_imp_decl(_sel)

class starter_sb extends uvm_scoreboard;
  // Declare analysis ports. 
  uvm_analysis_imp_exp0#(starter_data_txn, starter_sb) item_collected_export_exp0;
  uvm_analysis_imp_exp1#(starter_data_txn, starter_sb) item_collected_export_exp1;
  uvm_analysis_imp_obs#(starter_data_txn, starter_sb) item_collected_export_obs;
  uvm_analysis_imp_sel#(starter_sel_txn, starter_sb) item_collected_export_sel;
  
  // In this scoreboard, we keep counts of the expected and observed transaction
  protected int num_exp0 = 0;
  protected int num_exp1 = 0;
  protected int num_obs = 0;
  protected int num_sel = 0;
  protected int num_err = 0;
  
  starter_data_txn curr_txn0;
  starter_data_txn curr_txn1;
  starter_sel_txn curr_sel_txn;
  
  `uvm_component_utils_begin(starter_sb)
  	`uvm_field_int(num_exp0, UVM_DEFAULT|UVM_DEC)
	`uvm_field_int(num_exp1, UVM_DEFAULT|UVM_DEC)
	`uvm_field_int(num_obs, UVM_DEFAULT|UVM_DEC)
	`uvm_field_int(num_sel, UVM_DEFAULT|UVM_DEC)
	`uvm_field_int(num_err, UVM_DEFAULT|UVM_DEC)
  `uvm_component_utils_end
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction // new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    // instantiate the analysis ports
	item_collected_export_exp0 = new("item_collected_export_exp0", this);
	item_collected_export_exp1 = new("item_collected_export_exp1", this);
	item_collected_export_obs = new("item_collected_export_obs", this);
	item_collected_export_sel = new("item_collected_export_sel", this);
  endfunction
  
  // Define the write methods. Depending on the starter_sel_txn.sel value, the starter_txn.data observed at the output should be equal to the starter_txn.data of the selected input.
  function void write_exp0 (starter_data_txn txn);
    `uvm_info ("sb_write_exp0", txn.convert2string(), UVM_LOW)
    num_exp0++;
    curr_txn0 = new();
    curr_txn0 = txn;
  endfunction // write_exp

  function void write_exp1 (starter_data_txn txn);
    `uvm_info ("sb_write_exp1", txn.convert2string(), UVM_LOW)
    num_exp1++;
    curr_txn1 = new();
    curr_txn1 = txn;
  endfunction // write_exp1

  function void write_sel (starter_sel_txn txn);
    `uvm_info ("sb_write_sel", txn.convert2string(), UVM_LOW)
    num_sel++;
    curr_sel_txn = new();
    curr_sel_txn = txn;
  endfunction // write_sel

  // In our example, the output and input objects are the same. In many cases the objects can be different hence the correlation of input vs.output data could be done in the write method for the output.
  function void write_obs (starter_data_txn txn);
    if (curr_sel_txn.sel == 1) begin
      if (curr_txn0.compare(txn)==0) begin
        `uvm_info("sb_write_obs", {txn.convert2string(), " (miscompare)"}, UVM_LOW)
		num_err++;
      end
      else begin
        `uvm_info("sb_write_obs", {txn.convert2string(), " (match)"}, UVM_LOW)
      end
	end
	else begin
      if (curr_txn1.compare(txn)==0) begin
        `uvm_info("sb_write_obs", {txn.convert2string(), " (miscompare)"}, UVM_LOW)
        num_err++;
      end
      else begin
        `uvm_info("sb_write_obs", {txn.convert2string(), " (match)"}, UVM_LOW)
      end
    end
    num_obs++;
  endfunction // write_obs

  // Print the counts at the report phase
  virtual function void report_phase (uvm_phase phase);
    `uvm_info("sb_report", {"\n",this.sprint()}, UVM_LOW)
  endfunction // report_phase 
endclass // starter_sb
