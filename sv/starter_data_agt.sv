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

// The agent (starter_data_agt) contains a set of sequencer, driver and monitor that transacts/monitors one starter_data_if interface of the DUT.
// Multiple agents can be instantiated if there are multiple interfaces to test.
// Agents can be configured to be active or passive. A passive agent only monitors and does not drive the interface.
// In the connect_phase, if the agent is active, the driver seq_item_port is connected to the sequencer  seq_item_export. This allows the sequencer to send sequence items to the driver which the driver then uses to transact with the DUT interface.

class starter_data_agt extends uvm_agent;
  starter_data_sqr sqr;
  starter_data_drv drv;
  starter_data_mon mon;

  `uvm_component_utils(starter_data_agt)
  
  function new (string name="starter_data_agt", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    string inst_name;
    
	super.build_phase(phase);	
	mon = starter_data_mon::type_id::create("mon", this);
	if (get_is_active() == UVM_ACTIVE) begin
		sqr = starter_data_sqr::type_id::create("sqr", this);
		drv = starter_data_drv::type_id::create("drv", this);
	end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
