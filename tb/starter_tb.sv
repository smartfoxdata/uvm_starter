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


`include "starter_sb.sv"

class starter_tb extends uvm_env;
   `uvm_component_utils(starter_tb)

   // components of the testbench
   starter_env env_in; //input side
   starter_env env_out; //output side
   starter_sb sb; //scoreboard

   function new (string name, uvm_component parent=null);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(int)::set(this, "env_in.*", "id", 100);
      uvm_config_db#(int)::set(this, "env_out.*", "id", 101);
      uvm_config_db#(uvm_bitstream_t)::set(this, 
                                           "env_out.agt",
                                           "is_active",
                                           UVM_PASSIVE);
      env_in = starter_env::type_id::create("env_in", this);
      env_out = starter_env::type_id::create("env_out", this);
      sb = starter_sb::type_id::create("sb", this);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      env_in.agt.mon.item_collected_port.connect(sb.item_collected_export_exp);
      env_out.agt.mon.item_collected_port.connect(sb.item_collected_export_obs);
   endfunction // connect_phase

endclass // starter_tb
