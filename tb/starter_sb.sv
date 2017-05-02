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

`uvm_analysis_imp_decl( _exp )
`uvm_analysis_imp_decl( _obs )

class starter_sb extends uvm_scoreboard;
   uvm_analysis_imp_exp#(starter_txn, starter_sb) item_collected_export_exp;
   uvm_analysis_imp_obs#(starter_txn, starter_sb) item_collected_export_obs;

   protected int num_exp = 0;
   protected int num_obs = 0;
   protected int num_err = 0;
   starter_txn curr_txn;

   `uvm_component_utils_begin(starter_sb)
      `uvm_field_int(num_exp, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(num_obs, UVM_DEFAULT|UVM_DEC)
      `uvm_field_int(num_err, UVM_DEFAULT|UVM_DEC)
   `uvm_component_utils_end

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      item_collected_export_exp = new("item_collected_export_exp", this);
      item_collected_export_obs = new("item_collected_export_obs", this);
   endfunction // build_phase

   function void write_exp (starter_txn txn);
      `uvm_info("SB_EXP", txn.convert2string(), UVM_LOW)
      num_exp++;
      curr_txn = new();
      curr_txn = txn;
   endfunction // write_exp

   function void write_obs (starter_txn txn);
      num_obs++;
      if (curr_txn.compare(txn) == 0) begin
	`uvm_info("SB_OBS", {txn.convert2string(), " (miscompare)"}, UVM_LOW)
	 num_err++;
      end
      else begin
	`uvm_info("SB_OBS", {txn.convert2string(), " (match)"}, UVM_LOW)
      end
   endfunction // write_obs

   virtual function void report_phase (uvm_phase phase);
      `uvm_info("SB_REPORT", {"\n",this.sprint()}, UVM_LOW)
   endfunction // report_phase
   
endclass // starter_sb
