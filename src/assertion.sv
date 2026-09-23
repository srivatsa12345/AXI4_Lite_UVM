module assertions#(parameter DATA_WIDTH=32)(
	input logic clk, rst,
	input logic [DATA_WIDTH-1:0] RDATA,
	input logic [1:0] BRESP, RRESP,
	input logic AWREADY, WREADY, BREADY, BVALID, ARREADY, RREADY, RVALID);

	checkrst:assert property (@(posedge clk) !rst |-> ({AWREADY, WREADY, BVALID, BRESP, ARREADY, RVALID, RDATA, RRESP} == 0));
	asyncrst:assert property (@(negedge clk) !rst |-> ({AWREADY, WREADY, BVALID, BRESP, ARREADY, RVALID, RDATA, RRESP} == 0));
	checkbvalid:assert property (@(posedge clk) disable iff (!rst) (BVALID && !BREADY) |=> BVALID);
	checkbresp:assert property (@(posedge clk) disable iff (!rst) (BVALID && !BREADY) |=> ($stable(BRESP)));
	checkrvalid:assert property (@(posedge clk) disable iff (!rst) (RVALID && !RREADY) |=> RVALID);
	checkrdata:assert property (@(posedge clk) disable iff (!rst) (RVALID && !RREADY) |=> ($stable(RDATA)));
	checkrresp:assert property (@(posedge clk) disable iff (!rst) (RVALID && !RREADY) |=> ($stable(RRESP)));
endmodule
