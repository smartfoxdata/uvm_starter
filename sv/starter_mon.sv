class starter_mon extends uvm_monitor;
   protected virtual starter_if vif;
   protected int id;

   uvm_analysis_port #(starter_txn) item_collected_port;

   protected starter_txn txn;

   `uvm_component_utils_begin(starter_mon)
      `uvm_field_int(id, UVM_DEFAULT)
   `uvm_component_utils_end

   function new (string name, uvm_component parent);
      super.new(name, parent);
      txn = new();
      item_collected_port = new("item_collected_port", this);
   endfunction // new

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual starter_if)::get(this, "", "vif", vif))
	`uvm_fatal("NOVIF",
		   {"virtual interface must be set for: ",
                    get_full_name(), ".vif"});
   endfunction // build_phase

   virtual task run_phase (uvm_phase phase);
      fork
	 collect_transactions();
      join
   endtask // run_phase

   virtual protected task collect_transactions();
      forever begin
	 txn = new();
	 if (vif.rst == 'b1)
	   @(negedge vif.rst);
	 @(posedge vif.valid);
	 txn.data = vif.data;
	 while (vif.valid == 'b1) begin
	    @(posedge vif.clk);
	    txn.cycles++;
	 end
	 txn.cycles--;
	 `uvm_info("MON", txn.convert2string(), UVM_LOW)
	 item_collected_port.write(txn);
      end
   endtask // collect_transactions
   
endclass // starter_mon
