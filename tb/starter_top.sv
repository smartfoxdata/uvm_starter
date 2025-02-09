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


// This is the testbench top file. 
// This is the main input file to the compiler/simulator.
// The following are done here:
// - Import the UVM components (packages)
// - Include the UVM test(s)
// - Instantiate the DUT
// - Declare the interfaces
// - Connect interface to DUT thru assign
// - Connect interface to UVM components using uvm_config_db
// - Call "run_test". The actual test to run will be specified at runtime using "+UVM_TESTNAME"
// - Create and connect the clocks and resets

`include "starter_data_pkg.sv"
`include "starter_sel_pkg.sv"
`include "starter_dut.v"

module starter_top;

  import uvm_pkg::*;
  import starter_data_pkg::*;
  import starter_sel_pkg::*;

  reg clk;
  reg rst;
  
  `include "starter_test_lib.sv"

  starter_data_if vif_in0();
  starter_data_if vif_in1();
  starter_data_if vif_out();
  starter_sel_if vif_select();

  starter_dut dut (
    // Outputs
    .data_out (vif_out.data),
    .valid_out (vif_out.valid),
    // Inputs
    .clk (clk),
    .rst (rst),
    .sel (vif_select.sel),
    .data_in0 (vif_in0.data),
    .valid_in0 (vif_in0.valid),
    .data_in1 (vif_in1.data),
    .valid_in1 (vif_in1.valid));
  
  initial begin
    uvm_config_db#(virtual starter_data_if)::set(null,"*agt_in0*","vif",vif_in0);    
    uvm_config_db#(virtual starter_data_if)::set(null,"*agt_in1*","vif",vif_in1);
    uvm_config_db#(virtual starter_sel_if)::set(null,"*sel_agt*","vif",vif_select);
    uvm_config_db#(virtual starter_data_if)::set(null,"*agt_out*","vif",vif_out); 
    run_test();
  end
  
  initial begin
    rst <= 1'b1;
    clk <= 1'b1;
    #51 rst = 1'b0;
  end
  
  always
	#5 clk = ~clk;
  
  assign vif_in0.clk = clk;
  assign vif_in0.rst = rst;
  assign vif_in1.clk = clk;
  assign vif_in1.rst = rst;
  assign vif_out.clk = clk;
  assign vif_out.rst = rst;
  assign vif_select.clk = clk;
  assign vif_select.rst = rst;
      
endmodule // starter_top
