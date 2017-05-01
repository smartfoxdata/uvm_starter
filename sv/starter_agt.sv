class starter_agt extends uvm_agent;

   starter_sqr sqr;
   starter_drv drv;
   starter_mon mon;

   `uvm_component_utils(starter_agt)

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon = starter_mon::type_id::create("mon", this);
      if (get_is_active() == UVM_ACTIVE) begin
	 sqr = starter_sqr::type_id::create("sqr", this);
	 drv = starter_drv::type_id::create("drv", this);
      end
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      if (get_is_active() == UVM_ACTIVE) begin
	 drv.seq_item_port.connect(sqr.seq_item_export);
      end
   endfunction // connect_phase

endclass // starter_agt


   
   
