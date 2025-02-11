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


// This is a simple DUT.
// There are two 8-bit data inputs (data_in0 and data_in1).
// Each data input has a corresponding valid signal (valid_in0 and valid_in1).
// A select input (sel) selects one of the two inputs. 
// There is a single data output (data_out) and valid output (valid_out).
// Depending on the select input, the data and valid output is just
//   the selected data and valid input delayed by 1 clock cycle.
// In our example, the select input is fixed and set before data and valid
//   inputs are toggled.
// This simple DUT mimics more complex practical DUTs where there are settings 
//   that are applied one time that is separate from the main data flow 
//   that occur repeatedly during runtime. 
// However practical DUTs typically have a different input vs. output interface. 
// In our simple DUT, the inputs and outputs have the same interface 
//   (i.e. data and valid signals).
  

module starter_dut (
   // Outputs
   data_out, valid_out,
   // Inputs
   clk, rst, data_in0, data_in1, valid_in0, valid_in1, sel
   ) ;
   input clk;
   input rst;
   input sel;
   input [7:0] data_in0;
   input valid_in0;
   input [7:0] data_in1;
   input valid_in1;
   output [7:0] data_out;
   output valid_out;
   
   reg [7:0]	datasel;
   reg			validsel;
   reg [7:0]	data_out;
   reg			valid_out;
   
   always@(data_in0 or data_in1 or sel) begin
	if(sel == 1'b1) begin
		datasel = data_in0;
	end
	else begin
		datasel = data_in1;
	end
   end
   
   always@(valid_in0 or valid_in1 or sel) begin
	if(sel == 1'b1) begin
		validsel = valid_in0;
	end
	else begin
		validsel = valid_in1;
	end
   end
   
   always @(posedge clk or posedge rst) begin
	if (rst) begin
		data_out <= 'h0;
		valid_out <= 'h0;
	end
	else begin
		data_out <= datasel;
		valid_out <= validsel;
	end	  
   end
endmodule // starter_dut

