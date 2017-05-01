class starter_env extends uvm_env;
   
   protected virtual interface starter_if vif;

   // components of the environment
   starter_agt agt;

   `uvm_component_utils(starter_env)

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase (uvm_phase phase);
      string inst_name;

      super.build_phase(phase);
      if (!uvm_config_db#(virtual starter_if)::get(this, "", "vif", vif))
	`uvm_fatal("NOVIF",{"virtual interface must be set for: ",
			    get_full_name(),".vif"});

      agt = starter_agt::type_id::create("agt", this);
   endfunction // build_phase

endclass // starter_env

