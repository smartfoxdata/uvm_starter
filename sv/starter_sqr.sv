class starter_sqr extends uvm_sequencer #(starter_txn);
   int id;
   
   `uvm_component_utils_begin(starter_sqr)
      `uvm_field_int(id, UVM_DEFAULT)
   `uvm_component_utils_end

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

endclass // starter_sqr
