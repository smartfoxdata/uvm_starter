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


// A super simple DUT
module starter_dut (
   // Outputs
   data_out, valid_out,
   // Inputs
   clk, rst, data_in, valid_in
   ) ;
   input clk;
   input rst;
   input [7:0] data_in;
   input valid_in;
   output [7:0] data_out;
   output valid_out;

   reg [7:0]		data_out;
   reg			valid_out;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
	 data_out <= 'h0;
	 valid_out <= 'h0;
      end
      else begin
	 data_out <= data_in;
	 valid_out <= valid_in;
      end
   end
endmodule // dut

