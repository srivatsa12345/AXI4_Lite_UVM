class my_transaction extends uvm_sequence_item;

	rand logic [`AW-1:0] AWADDR;
	bit [2:0] AWPROT;
	rand logic AWVALID;
	logic AWREADY;

	randc logic [`DW-1:0] WDATA;
	rand logic [(`DW/8)-1:0] WSTRB;
	rand logic WVALID;
	logic WREADY;

	logic [1:0] BRESP;
	logic BVALID;
	rand logic BREADY;

	rand logic [`AW-1:0] ARADDR;
	bit [2:0] ARPROT;
	rand logic ARVALID;
	logic  ARREADY;

	logic [`DW-1:0] RDATA;
	logic [1:0] RRESP;
	logic RVALID;
	rand logic RREADY;

	bit rst;

	function new (string name="my_trans");
		super.new(name);
	endfunction

	constraint awaddr{soft AWADDR inside {[0:255]};}
	constraint araddr{soft ARADDR inside {[0:255]};}
	constraint awaddr_v{soft AWADDR inside {[0:63]}; AWADDR[1:0]==2'b00;}
	constraint araddr_v{soft ARADDR inside {[0:63]}; ARADDR[1:0]==2'b00;}
	constraint awaddr_in{soft AWADDR inside {[0:63]}; AWADDR[1:0]!=2'b00;}
	constraint araddr_in{soft ARADDR inside {[0:63]}; ARADDR[1:0]!=2'b00;}
	constraint awaddr_out{soft AWADDR inside {[64:(2**(`AW)-1)]};}
	constraint araddr_out{soft ARADDR inside {[64:(2**(`AW)-1)]};}

	`uvm_object_utils_begin(my_transaction)
		`uvm_field_int(rst, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(AWADDR, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(AWPROT, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(AWVALID, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(AWREADY, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(WDATA, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(WSTRB, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(WVALID, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(WREADY, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(BRESP, UVM_ALL_ON)
		`uvm_field_int(BVALID, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(BREADY, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(ARADDR, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(ARPROT, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(ARVALID, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(ARREADY, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(RDATA, UVM_ALL_ON)
		`uvm_field_int(RRESP, UVM_ALL_ON)
		`uvm_field_int(RVALID, UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_int(RREADY, UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end
endclass

