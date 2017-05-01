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
