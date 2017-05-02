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

`include "starter_tb.sv"

class starter_test extends uvm_test;
   
   `uvm_component_utils(starter_test)

   starter_tb tb;

   function new (string name = "starter_test",
		 uvm_component parent=null);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      tb = starter_tb::type_id::create("tb", this);
   endfunction // build_phase

   task run_phase (uvm_phase phase);
      starter_base_seq seq;
      string list_of_sequences[$];
      uvm_cmdline_processor clp;

      phase.raise_objection(this);
      clp = uvm_cmdline_processor::get_inst();
      if (clp.get_arg_values("+SEQ=", list_of_sequences) == 0) begin
	 `uvm_fatal("RUNPHASE", "no sequence specified")
      end
      foreach (list_of_sequences[n]) begin
	 $cast(seq, factory.create_object_by_name(list_of_sequences[n]));
	 seq.start(tb.env_in.agt.sqr);
      end
      phase.drop_objection(this);
      phase.phase_done.set_drain_time(this, 100);
   endtask // run_phase  
   
endclass // starter_test
