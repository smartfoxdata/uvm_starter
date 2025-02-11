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

// This file contains definitions of tests.
// Each test extends from uvm_test base class.
// Each test does the following:
// - Builds the environment in build_phase()
// - Starts the sequence(s) to be run in run_phase(). In our examples such sequences are virtual sequences.
// - Waits for UVM components to finish activities using uvm_phase / objection mechanism.
// - If a configuration needs to be modified, uvm_config_db can be called in build_phase(). This is a good place to modify configurations that should only be applied to specific tests or scenarios.

// To illustrate the above concepts, we create 3 example tests:
// 1) starter_one_test - The simplest minimal test that calls only one sequence.
// 2) starter_any_test - This test is able to call any test(s) by using the +SEQ=<test name> runtime option. It uses uvm_cmdline_processor to extract the test name.
// The example VCS runtime command below runs no_activity_seq followed by starter_example_seq
// > simv +UVM_TESTNAME=starter_any_test +SEQ=starter_no_activity_seq +SEQ=starter_example_seq
// 3) starter_idle_cycles_test - In our example, we create a test where idle_cycles_on is changed to 1 from default of 0. By default, there are no idle cycles in between transactions, and this is changed in this specific test only.

`include "starter_env.sv"
`include "starter_vseq_lib.sv"

class starter_one_test extends uvm_test;
  `uvm_component_utils (starter_one_test)
  
  starter_env tb;
    
  function new (string name = "starter_one_test",
                uvm_component parent=null);
    super.new(name, parent);
  endfunction // new
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    tb = starter_env::type_id::create("tb", this);
  endfunction
  
  task run_phase (uvm_phase phase);
    starter_example_seq seq;
    seq = starter_example_seq::type_id::create("seq");
	phase.raise_objection(this);
    seq.start(tb.vsqr);
	phase.drop_objection(this);
	phase.phase_done.set_drain_time(this, 100);
  endtask 
endclass

class starter_any_test extends uvm_test;
  
  `uvm_component_utils(starter_any_test)
  
  starter_env tb;

  function new (string name = "starter_any_test",
	uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
	tb = starter_env::type_id::create("tb", this);
  endfunction

  task run_phase (uvm_phase phase);
	starter_base_vseq seq;
	string list_of_sequences[$];
	uvm_cmdline_processor clp;
    uvm_factory factory = uvm_factory::get();

	phase.raise_objection(this);
	clp = uvm_cmdline_processor::get_inst();
	  
	if (clp.get_arg_values("+SEQ=", list_of_sequences) == 0) begin
		`uvm_fatal("RUNPHASE", "no sequence specified")
	end
	foreach (list_of_sequences[n]) begin
		$cast(seq, factory.create_object_by_name(list_of_sequences[n]));
		seq.start(tb.vsqr);
	end
	phase.drop_objection(this);
	phase.phase_done.set_drain_time(this, 100);
  endtask
endclass

class starter_idle_cycles_test extends uvm_test;
  `uvm_component_utils (starter_idle_cycles_test)
  
  starter_env tb;
    
  function new (string name = "starter_idle_cycles_test",
                uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    starter_data_cfg cfg;
    super.build_phase(phase);
    tb = starter_env::type_id::create("tb", this);
    cfg = starter_data_cfg::type_id::create("cfg", this);
    cfg.idle_cycles_on = 1;
    uvm_config_db#(starter_data_cfg)::set(null, "tb.agt_in*", "cfg", cfg);
  endfunction
  
  task run_phase (uvm_phase phase);
    starter_example_seq seq;
    seq = starter_example_seq::type_id::create("seq");
	phase.raise_objection(this);
    seq.start(tb.vsqr);
	phase.drop_objection(this);
	phase.phase_done.set_drain_time(this, 100);
  endtask
endclass
