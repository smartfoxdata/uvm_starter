////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2025 Smartfox Data Solutions Inc.
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

// Sequences determine the sequence item(s) or transaction(s) that the sequencer will generate and send to the driver for execution.
// This file contains definitions of such sequences.
// Sequences are extended from uvm_sequence.
// The required sequence item(s) are "created" and "sent" in the "body" task of each sequence.

// This base sequence extends from uvm_sequence and specifies starter_data_txn as the kind of sequence item.
// This base sequence can also be used to insert transactions that are common for all other sequences (such as an initialization sequence). There is none in our example.
virtual class starter_data_base_seq extends uvm_sequence #(starter_data_txn);
  function new (string name="starter_data_base_seq");
    super.new(name);
  endfunction // new
endclass

// In our example, we illustrate the concept using 3 sequnces:
// - starter_data_rand1_seq sends 1 transaction with random data.
// - starter_data_rand8_seq sends 8 transactions with random data.
// - starter_data_incr8_seq sends 8 transactions with incrementing data. 
class starter_data_rand1_seq extends starter_data_base_seq;
  `uvm_object_utils(starter_data_rand1_seq)
  
  function new(string name="starter_data_rand1_seq");
    super.new(name);
  endfunction // new
  
  virtual task body();
    starter_data_txn item;
    `uvm_info("seq", "executing...", UVM_LOW)
    `uvm_create(item)
    item.randomize();
    `uvm_send(item);
  endtask
endclass

class starter_data_rand8_seq extends starter_data_base_seq;
  `uvm_object_utils(starter_data_rand8_seq)
  
  function new(string name="starter_data_rand8_seq");
    super.new(name);
  endfunction // new
  
  virtual task body();
    starter_data_txn item;
    `uvm_info("seq", "executing...", UVM_LOW)
    repeat (8) begin
      `uvm_create(item)
      item.randomize();
      `uvm_send(item);
    end
  endtask
endclass

class starter_data_incr8_seq extends starter_data_base_seq;
  `uvm_object_utils(starter_data_incr8_seq)
  
  function new(string name="starter_data_incr8_seq");
    super.new(name);
  endfunction

  virtual task body();
    starter_data_txn item;
    bit[7:0] val = 8'h0;
    `uvm_info("seq", "executing...", UVM_LOW)
    repeat (8) begin
      `uvm_create(item)
      item.data = val;
      val = val + 8'h1;
      `uvm_send(item);
    end    
  endtask
endclass
