################################################################################
# MIT License
#
# Copyright (c) 2017 Smartfox Data Solutions, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

COPTS=
ROPTS=

USAGE = "\nUsage: \
 \n Compile and run sequence: make all ROPTS=\"+SEQ=starter_no_activity_seq\" \
 \n Compile with added options but don't run: make comp COPTS=\"<opts>\" \
 \n Run with added options but don't recompile: make run ROPTS=\"<opts>\" \
 \n Launch waveform viewer after run: make dbg & \
 \n Clean-up generated files: make clean \
 \n"

usage:
	@echo $(USAGE)

all: comp run

comp: work
	vlog \
 -timescale "1ns/1ns" \
 -mfcu -suppress 2181 +acc=rmb \
 -writetoplevels vlog.tops \
 +incdir+$(UVM_HOME)/src \
 $(UVM_HOME)/src/uvm.sv \
 +incdir+../sv+../tb \
 ../tb/starter_tb_top.sv \
 +define+UVM_REPORT_DISABLE_FILE_LINE \
 -l vlog.log \
 $(COPTS)

run:
	vsim \
 -sv_lib $(UVM_HOME)/lib/uvm_dpi \
 -c -do "log -r /*; run -all; q" -l vsim.log -f vlog.tops \
 +UVM_TESTNAME=starter_test \
 $(ROPTS)

dbg:
	vsim -view vsim.wlf

work:
	vlib work

clean:
	rm -rf work transcript *.log vlog.* vsim.*
