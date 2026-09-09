`include "DUT.sv"
`include "package.sv"
`include "interface.sv"
module top;
	import uvm_pkg::*;
	import pkg::*;
	
	bit clk,rst;
	always #5 clk=~clk;

	my_if vif(.clk(clk),.rst(rst));

	axi4_lite_slave #(.DATA_WIDTH(`DW),.ADDR_WIDTH(`AW),.MEM_DEPTH(`MD),.DEFAULT_PROT(000)) m1 (
	.ACLK(clk),.ARESETn(rst),

	.AWADDR(vif.AWADDR),
        .AWPROT(vif.AWPROT),
   	.AWVALID(vif.AWVALID),
    	.AWREADY(vif.AWREADY),

    	.WDATA(vif.WDATA),
    	.WSTRB(vif.WSTRB),
    	.WVALID(vif.WVALID),
        .WREADY(vif.WREADY),

        .BRESP(vif.BRESP),
    	.BVALID(vif.BVALID),
        .BREADY(vif.BREADY),

        .ARADDR(vif.ARADDR),
        .ARPROT(vif.ARPROT),
        .ARVALID(vif.ARVALID),
        .ARREADY(vif.ARREADY),

        .RDATA(vif.RDATA),
        .RRESP(vif.RRESP),
        .RVALID(vif.RVALID),
        .RREADY(vif.RREADY)
	);

	initial begin
		rst=1;
		#1 rst=0;
		repeat(3)@(posedge clk);
		#1 rst=1;
	end	

	initial begin
		uvm_config_db#(virtual my_if)::set(null,"*","vif",vif);
		run_test("test");
	end
endmodule
