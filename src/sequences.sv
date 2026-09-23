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
			set_const_mode();
			rand_on_resp();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask
	
	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task print_values();
		`uvm_info("SEQ",$sformatf("AWADDR=%0d, AWPROT=%0b, AWVALID=%0d, WDATA=%0d, WSTRB=%0b, WVALID=%0d, ARADDR=%0d, ARPROT=%0b, ARVALID=%0d, RREADY=%0d", req.AWADDR, req.AWPROT, req.AWVALID, req.WDATA, req.WSTRB, req.WVALID, req.ARADDR, req.ARPROT, req.ARVALID, req.RREADY),UVM_MEDIUM)
	endtask

	task rand_on_resp();
		if(rsp==null) begin
			if(req.randomize());
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
			if(req.randomize());
			else 
				`uvm_error("SEQ","SEQ failed");
		end else if ((wr_add)&&(wr_data)) begin
			if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_add)&&(rd_done)) begin
			if(rsp.WVALID) begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if ((wr_data)&&(rd_done)) begin
			if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_add) begin
			if((rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID; ARVALID==rsp.ARVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARVALID==rsp.ARVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (rd_done) begin
			if((rsp.WVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID; AWVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; WVALID==rsp.WVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; AWADDR==rsp.AWADDR;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else if (wr_data) begin
			if((rsp.ARVALID)&&(rsp.AWVALID)) begin
				if(req.randomize() with { ARADDR==rsp.ARADDR; AWADDR==rsp.AWADDR; ARVALID==rsp.ARVALID; AWVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with { AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;});
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end else begin
			if((rsp.AWVALID)&&(rsp.WVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; WVALID==rsp.WVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.ARVALID)&&(rsp.WVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; WVALID==rsp.WVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if((rsp.AWVALID)&&(rsp.ARVALID)) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; ARVALID==rsp.ARVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.AWVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; AWVALID==rsp.AWVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.WVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; WVALID==rsp.WVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else if(rsp.ARVALID) begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end else begin
				if(req.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR; });
				else 
					`uvm_error("SEQ","SEQ failed");
			end
		end
	endtask
endclass

class rd_only_always_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(rd_only_always_rand)

	function new (string name="rd_only_always_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp();
			set_arvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_1();
		req.AWVALID=1'b0;
		req.WVALID=1'b0;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_simul_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_only_always_simul_rand)

	function new (string name="wr_only_always_simul_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b0;
	endtask
endclass

class wr_rd_always_simul_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_rd_always_simul_rand)

	function new (string name="wr_rd_always_simul_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_arvalid_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_1_by_1_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_1_rand)

	function new (string name="wr_only_always_1_by_1_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.AWREADY==1'b1) begin
					c1++;
					req.AWVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.WREADY==1'b1) begin 
					req.WVALID=1'b1; 
					c1=0; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class wr_only_always_1_by_2_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_2_rand)

	function new (string name="wr_only_always_1_by_2_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.WREADY==1'b1) begin
					c1++;
					req.WVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.AWREADY==1'b1) begin 
					req.AWVALID=1'b1; 
					c1++; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class back_pressure_rand extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1,c2;

	`uvm_object_utils(back_pressure_rand)

	function new (string name="back_pressure_rand");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(1);
		req.araddr.constraint_mode(1);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.BREADY=0;
		req.RREADY=0;
		if (rsp!=null) begin
			if(req.BVALID==1) begin
				if (c1==5) begin
					req.BREADY=1;
					c1=0;
				end else begin
					c1++;
				end
			end else c1=0;
			if(req.RVALID==1) begin
				if (c2==5) begin
					req.RREADY=1;
					c2=0;
				end else begin
					c2++;
				end
			end else c2=0;
		end
	endtask
endclass

class rd_only_always_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(rd_only_always_v)

	function new (string name="rd_only_always_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp();
			set_arvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_1();
		req.AWVALID=1'b0;
		req.WVALID=1'b0;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_simul_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_only_always_simul_v)

	function new (string name="wr_only_always_simul_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b0;
	endtask
endclass

class wr_rd_always_simul_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_rd_always_simul_v)

	function new (string name="wr_rd_always_simul_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_arvalid_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_1_by_1_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_1_v)

	function new (string name="wr_only_always_1_by_1_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.AWREADY==1'b1) begin
					c1++;
					req.AWVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.WREADY==1'b1) begin 
					req.WVALID=1'b1; 
					c1=0; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class wr_only_always_1_by_2_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_2_v)

	function new (string name="wr_only_always_1_by_2_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.WREADY==1'b1) begin
					c1++;
					req.WVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.AWREADY==1'b1) begin 
					req.AWVALID=1'b1; 
					c1++; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class back_pressure_v extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1,c2;

	`uvm_object_utils(back_pressure_v)

	function new (string name="back_pressure_v");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(1);
		req.araddr_v.constraint_mode(1);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.BREADY=0;
		req.RREADY=0;
		if (rsp!=null) begin
			if(req.BVALID==1) begin
				if (c1==5) begin
					req.BREADY=1;
					c1=0;
				end else begin
					c1++;
				end
			end else c1=0;
			if(req.RVALID==1) begin
				if (c2==5) begin
					req.RREADY=1;
					c2=0;
				end else begin
					c2++;
				end
			end else c2=0;
		end
	endtask
endclass

class rd_only_always_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(rd_only_always_in)

	function new (string name="rd_only_always_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp();
			set_arvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_1();
		req.AWVALID=1'b0;
		req.WVALID=1'b0;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_simul_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_only_always_simul_in)

	function new (string name="wr_only_always_simul_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b0;
	endtask
endclass

class wr_rd_always_simul_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_rd_always_simul_in)

	function new (string name="wr_rd_always_simul_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_arvalid_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_arvalid_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_1_by_1_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_1_in)

	function new (string name="wr_only_always_1_by_1_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.AWREADY==1'b1) begin
					c1++;
					req.AWVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.WREADY==1'b1) begin 
					req.WVALID=1'b1; 
					c1=0; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class wr_only_always_1_by_2_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_2_in)

	function new (string name="wr_only_always_1_by_2_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.WREADY==1'b1) begin
					c1++;
					req.WVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.AWREADY==1'b1) begin 
					req.AWVALID=1'b1; 
					c1++; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class back_pressure_in extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1,c2;

	`uvm_object_utils(back_pressure_in)

	function new (string name="back_pressure_in");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(1);
		req.araddr_in.constraint_mode(1);
		req.awaddr_out.constraint_mode(0);
		req.araddr_out.constraint_mode(0);
	endtask

	task set_awvalid_wvalid_1();
		req.BREADY=0;
		req.RREADY=0;
		if (rsp!=null) begin
			if(req.BVALID==1) begin
				if (c1==5) begin
					req.BREADY=1;
					c1=0;
				end else begin
					c1++;
				end
			end else c1=0;
			if(req.RVALID==1) begin
				if (c2==5) begin
					req.RREADY=1;
					c2=0;
				end else begin
					c2++;
				end
			end else c2=0;
		end
	endtask
endclass

class rd_only_always_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(rd_only_always_out)

	function new (string name="rd_only_always_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			rand_on_resp();
			set_arvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_arvalid_1();
		req.AWVALID=1'b0;
		req.WVALID=1'b0;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_simul_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_only_always_simul_out)

	function new (string name="wr_only_always_simul_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b0;
	endtask
endclass

class wr_rd_always_simul_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;

	`uvm_object_utils(wr_rd_always_simul_out)

	function new (string name="wr_rd_always_simul_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_arvalid_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_arvalid_awvalid_wvalid_1();
		req.AWVALID=1'b1;
		req.WVALID=1'b1;
		req.ARVALID=1'b1;
	endtask
endclass

class wr_only_always_1_by_1_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_1_out)

	function new (string name="wr_only_always_1_by_1_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.AWREADY==1'b1) begin
					c1++;
					req.AWVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.WREADY==1'b1) begin 
					req.WVALID=1'b1; 
					c1=0; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class wr_only_always_1_by_2_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1;

	`uvm_object_utils(wr_only_always_1_by_2_out)

	function new (string name="wr_only_always_1_by_2_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_awvalid_wvalid_1();
		req.ARVALID=1'b0;
		req.AWVALID=1'b0;
		req.WVALID=1'b0; 
		if (rsp!=null) begin
			if (c1==0) begin
				if(rsp.WREADY==1'b1) begin
					c1++;
					req.WVALID=1'b1;
				end
			end else if (c1==5) begin 
				if (rsp.AWREADY==1'b1) begin 
					req.AWVALID=1'b1; 
					c1++; 
				end  
			end else if (c1 inside {[1:4],6,7}) begin
				c1++;
			end else if (c1==8) begin
				c1=0;
			end
		end
	endtask
endclass

class back_pressure_out extends sequences;
	
	bit wr_add, wr_data;
	bit rd_done;
	int c1,c2;

	`uvm_object_utils(back_pressure_out)

	function new (string name="back_pressure_out");
		super.new(name);
	endfunction

	task body();
		repeat(`n) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			set_const_mode();
			rand_on_resp();
			set_awvalid_wvalid_1();
			print_values();
			finish_item(req);
			get_response(rsp);
		end
	endtask

	task set_const_mode();
		req.awaddr.constraint_mode(0);
		req.araddr.constraint_mode(0);
		req.awaddr_v.constraint_mode(0);
		req.araddr_v.constraint_mode(0);
		req.awaddr_in.constraint_mode(0);
		req.araddr_in.constraint_mode(0);
		req.awaddr_out.constraint_mode(1);
		req.araddr_out.constraint_mode(1);
	endtask

	task set_awvalid_wvalid_1();
		req.BREADY=0;
		req.RREADY=0;
		if (rsp!=null) begin
			if(req.BVALID==1) begin
				if (c1==5) begin
					req.BREADY=1;
					c1=0;
				end else begin
					c1++;
				end
			end else c1=0;
			if(req.RVALID==1) begin
				if (c2==5) begin
					req.RREADY=1;
					c2=0;
				end else begin
					c2++;
				end
			end else c2=0;
		end
	endtask
endclass

