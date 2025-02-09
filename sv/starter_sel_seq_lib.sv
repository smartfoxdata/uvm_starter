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

// This base sequence extends from uvm_sequence and specifies starter_sel_txn as the kind of sequence item.
// This base sequence can also be used to insert transactions that are common for all other sequences (such as an initialization sequence). There is none in our example.

virtual class starter_sel_base_seq extends uvm_sequence #(starter_sel_txn);
  function new (string name="starter_sel_base_seq");
    super.new(name);
  endfunction
endclass

// In our example, the starter_sel_rand_seq executes a transaction wherein the sel is randomized.
class starter_sel_rand_seq extends starter_sel_base_seq;
  `uvm_object_utils(starter_sel_rand_seq)
  
  function new(string name="starter_sel_rand_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    starter_sel_txn item;
    `uvm_info("SEQ", "executing...", UVM_LOW)
    `uvm_create(item)
    item.randomize();	
    `uvm_send(item);
  endtask
endclass
