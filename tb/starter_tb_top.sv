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


`include "starter_pkg.sv"
`include "starter_dut.v"

module starter_tb_top;

   import uvm_pkg::*;
   import starter_pkg::*;

   reg clk;
   reg rst;

   uvm_factory factory;
   
   `include "starter_test.sv"

   starter_if vif_in();
   starter_if vif_out();

   starter_dut dut (
		    // Outputs
		    .data_out			(vif_out.data),
		    .valid_out                  (vif_out.valid),
		    // Inputs
		    .clk			(clk),
		    .rst			(rst),
		    .data_in			(vif_in.data),
                    .valid_in                   (vif_in.valid));

   initial begin
      automatic uvm_coreservice_t cs_ = uvm_coreservice_t::get();
      uvm_config_db#(virtual starter_if)::set(cs_.get_root(),
                                              "*env_in*",
                                              "vif",
                                              vif_in);
      uvm_config_db#(virtual starter_if)::set(cs_.get_root(),
                                              "*env_out*",
                                              "vif",
                                              vif_out);
      factory = cs_.get_factory();
      run_test();
   end

   initial begin
      rst <= 1'b1;
      clk <= 1'b1;
      #51 rst = 1'b0;
   end

   always
     #5 clk = ~clk;

   assign vif_in.clk = clk;
   assign vif_in.rst = rst;
   assign vif_out.clk = clk;
   assign vif_out.rst = rst;
      
endmodule // starter_tb_top
