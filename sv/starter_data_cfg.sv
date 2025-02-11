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

// Testbench components (drivers, monitors, environment, etc) typically have configurable features.
// This class encapsulates configuration variables for starter_drv.
// We use starter_data_cfg to illustrate setting configurations using uvm_config_db.
// In our example, the starter_drv can be configured to insert idle cycles
//   at the start of a transaction. By default, this feature is disabled.

class starter_data_cfg extends uvm_object;
  `uvm_object_utils(starter_data_cfg)
  
  bit idle_cycles_on = 0;
  
  function new (string name = "starter_data_cfg");
	super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("idle_cycles_on='b%b", idle_cycles_on);
  endfunction
endclass
