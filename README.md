## uvm_starter

uvm_starter is a simple template for starting UVM projects.

Coincidentally, uvm_starter can be run completely using only the free simulator Modelsim ASE (Altera Starter Edition). It is meant to be a starting point for making more elaborate UVM testbenches or for learning the basics of UVM.

In this template, we included all the modules needed to create a simple but complete testbench for practical applications.

The said modules include:
 - The DUT (Design Under Test)
 - UVM Agents that interact with a specific interface of the DUT. Each UVM Agent contains Driver, Monitor and Sequencer.
 - UVM Sequences, or the set of UVM Sequence Items that determine how the Driver drives the DUT interface it connects to. 
 - A Virtual Sequencer that combines Sequences from different Sequencers.
 - A Scoreboard that checks transactions at the output match the expected behaviour based on the input(s).
 - UVM Environment that builds and connects the Agents, Virtual Sequencer and Scoreboard.
 - UVM Tests that instantiate the Environment and specifies Sequence(s) to run. Note that in UVM, Environments, Agents (Driver+Monitor+Sequencer), configuration objects are "built". Sequences are "run".
 - All other modules for containing/listing the modules: top module, packages.

A thorough description is provided in the comments of each file.
