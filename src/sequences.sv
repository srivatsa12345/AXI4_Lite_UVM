class sequences extends uvm_sequence #(my_transaction, my_transaction);
	
	`uvm_object_utils(sequences)

	function new (string name="seq");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp(req);
			finish_item(req);
		end
	endtask
	
	task rand_on_resp(my_transaction tr);
		if(rsp==null) begin
			if(req.randomize());
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else begin
			if(req.randomize());
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end
	endtask
endclass

