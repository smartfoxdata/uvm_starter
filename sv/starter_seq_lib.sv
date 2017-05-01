virtual class starter_base_seq extends uvm_sequence #(starter_txn);

   function new (string name="starter_base_seq");
      super.new(name);
   endfunction // new

endclass // starter_base_seq

class starter_no_activity_seq extends starter_base_seq;
   `uvm_object_utils(starter_no_activity_seq)
   
   function new(string name="starter_no_activity_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info("SEQ", "executing", UVM_LOW)
   endtask // body
			    
endclass // starter_no_activity_seq

class starter_random_seq extends starter_base_seq;
   `uvm_object_utils(starter_random_seq)
   
   function new(string name="starter_random_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      starter_txn item;
      `uvm_info("SEQ", "executing...", UVM_LOW)
      `uvm_create(item)
      item.cycles = $urandom_range(1,5);
      item.data = $urandom();
      `uvm_send(item);
   endtask // body

endclass // starter_random_seq

class starter_directed_seq extends starter_base_seq;
   `uvm_object_utils(starter_directed_seq)
   
   function new(string name="starter_directed_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      starter_txn item;
      `uvm_info("SEQ", "executing...", UVM_LOW)
      `uvm_create(item)
      item.cycles = 2;
      item.data = 8'hf;
      `uvm_send(item);
   endtask // body

endclass // starter_directed_seq

class starter_usevar_seq extends starter_base_seq;
   `uvm_object_utils(starter_usevar_seq)
   `uvm_declare_p_sequencer(starter_sqr)
   
   function new(string name="starter_usevar_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      starter_txn item;
      int id;

      `uvm_info("SEQ", "executing...", UVM_LOW)
      id = p_sequencer.id;
      `uvm_info("SEQ", $sformatf("using id=%0hh from sequencer", id), UVM_LOW)
      `uvm_create(item)
      item.cycles = $urandom_range(1,5);
      item.data = id;
      `uvm_send(item);
   endtask // body

endclass // starter_usevar_seq
