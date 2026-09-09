package pkg;
	`include "defines.svh"
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	`uvm_analysis_imp_decl(_out)
	`include "my_transaction.sv"
	`include "sequencer.sv"
	`include "sequences.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "agent.sv"
	`include "subscriber.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
	`include "test.sv"
endpackage

