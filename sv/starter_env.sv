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


// This is the main testbench environment file.
// The starter_env class extends from uvm_env.
// The environment builds all needed UVM components. In our case we have agents that interface to 2 data inputs, 1 select input and 1 data output, along with the virtual sequencer and scoreboard.
// After building components, it is ideal to configure settings that we know are applicable to all use cases or tests that use this testbench. For example, when testing our DUT we do not drive anything at the output side, hence the output agent can be configured to be "passive" (i.e. only the monitor is enabled).
// The environment also connects UVM components as needed. In our case, the monitors within the agents connect to the scoreboard.

`include "starter_sb.sv"
`include "starter_vsqr.sv"

class starter_env extends uvm_env;
  `uvm_component_utils(starter_env)

  // components of the testbench
  starter_data_agt agt_in0; // input data
  starter_data_agt agt_in1; // input data
  starter_data_agt agt_out; // output data
  starter_sel_agt sel_agt; // input select
  starter_vsqr vsqr; // virtual sequencer
  starter_sb sb; // scoreboard
  
  function new (string name="starter_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // create the components
    sb = starter_sb::type_id::create("sb", this);
    vsqr = starter_vsqr::type_id::create("vsqr", this);
    agt_in0 = starter_data_agt::type_id::create("agt_in0", this);
	agt_in1 = starter_data_agt::type_id::create("agt_in1", this);
	agt_out = starter_data_agt::type_id::create("agt_out", this);
    sel_agt = starter_sel_agt::type_id::create("sel_agt", this);

    // configure output data agent as "passive" (enable monitor only)
	uvm_config_db#(uvm_bitstream_t)::set(this,
                                         "agt_out",
                                         "is_active",
                                         UVM_PASSIVE);	 
  endfunction
  
  function void connect_phase(uvm_phase phase);
    // assign the sequencers of the virtual sequencer
    vsqr.start_sqr0 = agt_in0.sqr;
	vsqr.start_sqr1 = agt_in1.sqr;
	vsqr.start_sel_sqr = sel_agt.sqr;
    
    // connect ports to scroreboard
	agt_in0.mon.item_collected_port.connect(sb.item_collected_export_exp0);
	agt_in1.mon.item_collected_port.connect(sb.item_collected_export_exp1);
	agt_out.mon.item_collected_port.connect(sb.item_collected_export_obs);
	sel_agt.mon.item_collected_port.connect(sb.item_collected_export_sel);	  
  endfunction
endclass // starter_env
