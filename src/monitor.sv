class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	//virtual my_if.MON vif;
	virtual my_if vif;
	uvm_analysis_port #(my_transaction) ap;

	my_transaction tr;

	function new(string name, uvm_component parent);
		super.new(name,parent);
		ap=new("ap",this);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif))
			`uvm_fatal("NOVIF","vif is not set for monitor");
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.cb_mon);
		forever
			collect_input();
	endtask

	task collect_input();
		begin
			tr=my_transaction::type_id::create("tr");
			@(vif.cb_mon);
			tr.rst=vif.cb_mon.rst; 
			tr.AWADDR=vif.cb_mon.AWADDR; 
			tr.AWPROT=vif.cb_mon.AWPROT; 
			tr.AWVALID=vif.cb_mon.AWVALID; 
			tr.AWREADY=vif.cb_mon.AWREADY;

			tr.WDATA=vif.cb_mon.WDATA; 
			tr.WSTRB=vif.cb_mon.WSTRB; 
			tr.WVALID=vif.cb_mon.WVALID; 
			tr.WREADY=vif.cb_mon.WREADY;	

			tr.BRESP=vif.cb_mon.BRESP;
			tr.BVALID=vif.cb_mon.BVALID;
			tr.BREADY=vif.cb_mon.BREADY; 

			tr.ARADDR=vif.cb_mon.ARADDR; 
			tr.ARPROT=vif.cb_mon.ARPROT; 
			tr.ARVALID=vif.cb_mon.ARVALID; 
			tr.ARREADY=vif.cb_mon.ARREADY;

			tr.RREADY=vif.cb_mon.RREADY; 
			tr.RDATA=vif.cb_mon.RDATA;
			tr.RRESP=vif.cb_mon.RRESP;
			tr.RVALID=vif.cb_mon.RVALID;
			`uvm_info(get_full_name(),$sformatf("rst=%0d, AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0d, WVALID=%0d, BREADY=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d, AWREADY=%0d, WREADY=%0d, BRESP=%0d, BVALID=%0d, ARREADY=%0d, ARPROT=%0h, RDATA=%0d, RRESP=%0d, RVALID=%0d",vif.cb_mon.rst, vif.cb_mon.AWADDR, vif.cb_mon.AWPROT, vif.cb_mon.AWVALID, vif.cb_mon.WDATA, vif.cb_mon.WSTRB, vif.cb_mon.WVALID, vif.cb_mon.BREADY, vif.cb_mon.ARADDR, vif.cb_mon.ARPROT, vif.cb_mon.ARVALID, vif.cb_mon.RREADY, vif.cb_mon.AWREADY, vif.cb_mon.WREADY, vif.cb_mon.BRESP, vif.cb_mon.BVALID, vif.cb_mon.ARREADY, vif.cb_mon.ARPROT, vif.cb_mon.RDATA, vif.cb_mon.RRESP, vif.cb_mon.RVALID),UVM_NONE)
			ap.write(tr);
		end
	endtask

endclass
