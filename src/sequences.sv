class sequences extends uvm_sequence #(my_transaction, my_transaction);
	
	bit wr_add, wr_data;
	bit rd_done;

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
			get_response(rsp);
		end
	endtask
	
	task rand_on_resp(my_transaction tr);
		if(rsp==null) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else begin
			fork 
				wr_channel();
				rd_channel();
			join
			rand_on_protocol();
		end
	endtask

	task wr_channel();
		if((rsp.AWREADY)&&(rsp.AWVALID)) wr_add=1; else wr_add=0; 
		if((rsp.WREADY)&&(rsp.WVALID)) wr_data=1; else wr_data=0;
	endtask

	task rd_channel();
		if((rsp.ARREADY)&&(rsp.ARVALID)) rd_done=1; else rd_done=0;
	endtask

	task rand_on_protocol();
		if ((wr_add)&&(wr_data)&&(rd_done)) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else if ((wr_add)&&(wr_data)) begin
			if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_add)&&(rd_done)) begin
			if(rsp.WVALID) begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_data)&&(rd_done)) begin
			if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_add) begin
			if((rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (rd_done) begin
			if((rsp.WVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_data) begin
			if((rsp.ARVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { ARADDR==rsp.ARADDR; AWADDR==rsp.AWADDR; ARVALID==rsp.ARVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else begin
			if((rsp.AWVALID)&&(rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.ARVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end
	endtask
endclass

class rd_only_always extends uvm_sequence #(my_transaction, my_transaction);
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(rd_only_always)

	function new (string name="rd_only_always");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp(req);
			set_arvalid_1(req);
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_arvalid_1(my_transaction tr);
		req.AWVALID=1'b0;
		req.WVALID=1'b0;
		req.ARVALID=1'b1;
	endtask
	
	task rand_on_resp(my_transaction tr);
		if(rsp==null) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else begin
			fork 
				wr_channel();
				rd_channel();
			join
			rand_on_protocol();
		end
	endtask

	task wr_channel();
		if((rsp.AWREADY)&&(rsp.AWVALID)) wr_add=1; else wr_add=0; 
		if((rsp.WREADY)&&(rsp.WVALID)) wr_data=1; else wr_data=0;
	endtask

	task rd_channel();
		if((rsp.ARREADY)&&(rsp.ARVALID)) rd_done=1; else rd_done=0;
	endtask

	task rand_on_protocol();
		if ((wr_add)&&(wr_data)&&(rd_done)) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else if ((wr_add)&&(wr_data)) begin
			if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_add)&&(rd_done)) begin
			if(rsp.WVALID) begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_data)&&(rd_done)) begin
			if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_add) begin
			if((rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (rd_done) begin
			if((rsp.WVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_data) begin
			if((rsp.ARVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { ARADDR==rsp.ARADDR; AWADDR==rsp.AWADDR; ARVALID==rsp.ARVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else begin
			if((rsp.AWVALID)&&(rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.ARVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end
	endtask
endclass

class wr_only_always_simul extends uvm_sequence #(my_transaction, my_transaction);
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_only_always_simul)

	function new (string name="wr_only_always_simul");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp(req);
			set_awvalid_wvalid_1(req);
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_awvalid_wvalid_1(my_transaction tr);
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b0;
	endtask
	
	task rand_on_resp(my_transaction tr);
		if(rsp==null) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else begin
			fork 
				wr_channel();
				rd_channel();
			join
			rand_on_protocol();
		end
	endtask

	task wr_channel();
		if((rsp.AWREADY)&&(rsp.AWVALID)) wr_add=1; else wr_add=0; 
		if((rsp.WREADY)&&(rsp.WVALID)) wr_data=1; else wr_data=0;
	endtask

	task rd_channel();
		if((rsp.ARREADY)&&(rsp.ARVALID)) rd_done=1; else rd_done=0;
	endtask

	task rand_on_protocol();
		if ((wr_add)&&(wr_data)&&(rd_done)) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else if ((wr_add)&&(wr_data)) begin
			if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_add)&&(rd_done)) begin
			if(rsp.WVALID) begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_data)&&(rd_done)) begin
			if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_add) begin
			if((rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (rd_done) begin
			if((rsp.WVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_data) begin
			if((rsp.ARVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { ARADDR==rsp.ARADDR; AWADDR==rsp.AWADDR; ARVALID==rsp.ARVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else begin
			if((rsp.AWVALID)&&(rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.ARVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end
	endtask
endclass

class wr_rd_always_simul extends uvm_sequence #(my_transaction, my_transaction);
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_rd_always_simul)

	function new (string name="wr_rd_always_simul");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp(req);
			set_arvalid_awvalid_wvalid_1(req);
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_arvalid_awvalid_wvalid_1(my_transaction tr);
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b1;
	endtask
	
	task rand_on_resp(my_transaction tr);
		if(rsp==null) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else begin
			fork 
				wr_channel();
				rd_channel();
			join
			rand_on_protocol();
		end
	endtask

	task wr_channel();
		if((rsp.AWREADY)&&(rsp.AWVALID)) wr_add=1; else wr_add=0; 
		if((rsp.WREADY)&&(rsp.WVALID)) wr_data=1; else wr_data=0;
	endtask

	task rd_channel();
		if((rsp.ARREADY)&&(rsp.ARVALID)) rd_done=1; else rd_done=0;
	endtask

	task rand_on_protocol();
		if ((wr_add)&&(wr_data)&&(rd_done)) begin
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
		end else if ((wr_add)&&(wr_data)) begin
			if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_add)&&(rd_done)) begin
			if(rsp.WVALID) begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_data)&&(rd_done)) begin
			if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_add) begin
			if((rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (rd_done) begin
			if((rsp.WVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_data) begin
			if((rsp.ARVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { ARADDR==rsp.ARADDR; AWADDR==rsp.AWADDR; ARVALID==rsp.ARVALID; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;})
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else begin
			if((rsp.AWVALID)&&(rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.ARVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; WVALID==rsp.WVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; })
					`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end
	endtask
endclass

