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

