class starter_txn extends uvm_sequence_item;
   rand bit [7:0] data;
   rand int unsigned cycles;

   `uvm_object_utils_begin(starter_txn)
      `uvm_field_int (data, UVM_DEFAULT)
      `uvm_field_int (cycles, UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "starter_txn");
      super.new(name);
   endfunction // new

   function string convert2string();
      return $sformatf("data='h%0h, cycles='d%0d",
		       data, cycles);
   endfunction // convert2string
   
endclass // starter_txn
