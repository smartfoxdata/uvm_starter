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


// Our example uses two different set of components (i.e. agents) each with a UVM sequencer to generate stimulus for two kinds of interface.
// Hence a virtual sequencer starter_vsqr is used to coordinate the operation of the different sequencers - the starter_data_sqr that generates stimulus for the data and valid inputs, and the starter_sel_sqr that generates stimulus for the select input.

class starter_vsqr extends uvm_sequencer;
  `uvm_component_utils(starter_vsqr)
  
  starter_data_sqr start_sqr0;
  starter_data_sqr start_sqr1;
  starter_sel_sqr start_sel_sqr;
  
  function new(string name="starter_vsqr", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
