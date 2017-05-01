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
