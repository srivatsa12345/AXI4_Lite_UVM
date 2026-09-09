class driver extends uvm_driver#(my_transaction,my_transaction);
	`uvm_component_utils(driver)
	virtual my_if.DRV vif;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif))
			`uvm_fatal("NOVIF", "vif not found in driver")
	endfunction
	
	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done(rsp);
		end
	endtask

	task drive(my_transaction tr);
		begin
			@(vif.cb_drv);
			fork 
				wr_addr(tr);
				wr_data(tr);
				rd_addr(tr);
				wr_rsp(tr);
				rd_rsp(tr);
				get_resp(tr);
			join
		end
	endtask

	task wr_addr(my_transaction tr);
		`uvm_info("DRV",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d", tr.AWADDR, tr.AWPROT, tr.AWVALID),UVM_MEDIUM)
		vif.cb_drv.AWADDR<=tr.AWADDR;
		vif.cb_drv.AWPROT<=tr.AWPROT;
		vif.cb_drv.AWVALID<=tr.AWVALID;
	endtask

	task wr_data(my_transaction tr);
		`uvm_info("DRV",$sformatf("WDATA=%0d, WSTRB=%0b, WVALID=%0d", tr.WDATA, tr.WSTRB, tr.WVALID),UVM_MEDIUM)
		vif.cb_drv.WDATA<=tr.WDATA;
		vif.cb_drv.WSTRB<=tr.WSTRB;	
		vif.cb_drv.WVALID<=tr.WVALID;
	endtask

	task rd_addr(my_transaction tr);
		`uvm_info("DRV",$sformatf("ARADDR=%0d, ARVALID", tr.ARADDR, tr.ARVALID),UVM_MEDIUM)
		vif.cb_drv.ARADDR<=tr.ARADDR; 
		vif.cb_drv.ARPROT<=tr.ARPROT;
		vif.cb_drv.ARVALID<=tr.ARVALID;
	endtask

	task wr_rsp(my_transaction tr);
		`uvm_info("DRV",$sformatf("BREADY=%0d", tr.BREADY),UVM_MEDIUM)
		vif.cb_drv.BREADY<=tr.BREADY;
	endtask

	task rd_rsp(my_transaction tr);
		`uvm_info("DRV",$sformatf("RREADY=%0d", tr.RREADY),UVM_MEDIUM)
		vif.cb_drv.RREADY<=tr.RREADY;
	endtask

	task get_resp(my_transaction tr);
		$cast(rsp,tr.clone());
		rsp.AWREADY=vif.cb_drv.AWREADY;
		rsp.WREADY=vif.cb_drv.WREADY;
		rsp.BVALID=vif.cb_drv.BVALID;
		rsp.ARREADY=vif.cb_drv.ARREADY;
		rsp.RVALID=vif.cb_drv.RVALID;
	endtask
endclass
