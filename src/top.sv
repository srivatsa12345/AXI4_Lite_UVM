`include "DUT.sv"
`include "package.sv"
`include "interface.sv"
module top;
	import uvm_pkg::*;
	import pkg::*;
	
	bit clk,rst;
	always #5 clk=~clk;

	my_if vif(.clk(clk),.rst(rst));
	
	initial begin
		uvm_config_db#(virtual my_if)::set(null,"*","vif",vif);
		run_test("test");
	end
endmodule
