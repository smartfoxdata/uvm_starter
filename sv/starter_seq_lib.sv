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
