`include "starter_sb.sv"

class starter_tb extends uvm_env;
   `uvm_component_utils(starter_tb)

   // components of the testbench
   starter_env env_in; //input side
   starter_env env_out; //output side
   starter_sb sb; //scoreboard

   function new (string name, uvm_component parent=null);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(int)::set(this, "env_in.*", "id", 100);
      uvm_config_db#(int)::set(this, "env_out.*", "id", 101);
      uvm_config_db#(uvm_bitstream_t)::set(this, 
                                           "env_out.agt",
                                           "is_active",
                                           UVM_PASSIVE);
      env_in = starter_env::type_id::create("env_in", this);
      env_out = starter_env::type_id::create("env_out", this);
      sb = starter_sb::type_id::create("sb", this);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      env_in.agt.mon.item_collected_port.connect(sb.item_collected_export_exp);
      env_out.agt.mon.item_collected_port.connect(sb.item_collected_export_obs);
   endfunction // connect_phase

endclass // starter_tb
