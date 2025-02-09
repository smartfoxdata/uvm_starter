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

// This file contains definitions of virtual sequences.
// Our test uses a virtual sequencer and virtual sequences since multiple different kind of sequences are run to generate stimulus to multiple interfaces of the DUT.
// The required sequence(s) are created and "sent" in the "body" task of each virtual sequence.
// The type of UVM sequencer that does the sending to the UVM driver is specified using the `uvm_declare_p_sequencer macro i.e. casts the parent's sequencer, which is used by the sequences defined here (p_sequencer)

// A base virtual sequence may be defined to perform sequences that are common for all (such as an initialization sequence). There is none in our example.
virtual class starter_base_vseq extends uvm_sequence;
  function new (string name="starter_base_vseq");
    super.new(name);
  endfunction
  
  virtual task body();
  endtask
endclass

// A no_activity_seq is useful for debug/test purposes such as when testing the verification components while DUT is not yet ready, or the other UVM components are not ready (i.e. driver and/or sequencer)
class starter_no_activity_seq extends starter_base_vseq;
  `uvm_object_utils(starter_no_activity_seq)
  
  function new (string name="starter_no_activity_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info("body", "executing starter_no_activity_seq", UVM_LOW)
  endtask
endclass

// In this example virtual sequences, the select interface is initialized with a random setting followed by  random sequences on one data input and incrementing sequences for the other data input. The data input sequences are executed concurrently.
class starter_example_seq extends starter_base_vseq;
  `uvm_object_utils(starter_example_seq)
  `uvm_declare_p_sequencer(starter_vsqr)
  
  starter_data_rand8_seq ran_seq0;
  starter_data_incr8_seq ran_seq1;
  starter_sel_rand_seq sel_seq;
	
  function new (string name="starter_example_seq");
	super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info("body", "executing", UVM_LOW)
	super.body();

	`uvm_create_on(ran_seq0, p_sequencer.start_sqr0)
	`uvm_create_on(ran_seq1, p_sequencer.start_sqr1)
	`uvm_create_on(sel_seq, p_sequencer.start_sel_sqr)	
	`uvm_send(sel_seq);
	fork
      repeat (2)
        `uvm_send(ran_seq0);
      repeat (2)
		`uvm_send(ran_seq1);		
	join	
  endtask  
endclass
