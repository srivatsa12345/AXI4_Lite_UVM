`include "DUT.sv"
`include "package.sv"
`include "interface.sv"
`include "assertion.sv"

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

	bind axi4_lite_slave assertions #(.DATA_WIDTH(`DW)) sva (
	.clk(ACLK), .rst(ARESETn), .RDATA(RDATA), .BRESP(BRESP), .RRESP(RRESP), .AWREADY(AWREADY), .WREADY(WREADY), .BREADY(BREADY), .BVALID(BVALID), .ARREADY(ARREADY), .RREADY(RREADY), .RVALID(RVALID));

	initial begin
		rst=1;
		#1 rst=0;
		repeat(3)@(posedge clk);
		#1 rst=1;
		repeat(10) mid_rst();
	end	

	task mid_rst();
		repeat(200) @ (posedge clk);
		#1 rst=0;
		repeat(2) @ (posedge clk);
		#1 rst=1;
	endtask
	initial begin
		uvm_config_db#(virtual my_if)::set(null,"*","vif",vif);
	//	run_test("test");
	end
	initial begin
	//	$fsdbDumpfile("wave.fsdb");
	//	$fsdbDumpvars(0, top);
	//	$fsdbDumpMDA(); 
	end
endmodule
