class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_analysis_imp #(my_transaction, scoreboard) in_mon;
	uvm_analysis_imp_out #(my_transaction, scoreboard) out_mon;

	my_transaction in_q[$],out_q[$];
	my_transaction held;

	int TOTAL,MISMATCH,MATCH;
	bit [7:0] mem [63:0];
	bit wr_add,wr_data;
	bit count;

	function new(string name, uvm_component parent);
		super.new(name,parent);
		in_mon=new("in_mon",this);
		out_mon=new("out_mon",this);
	endfunction

	virtual function void write(my_transaction tx);
		in_q.push_back(tx);
	endfunction
	
	virtual function void write_out(my_transaction tx);
		out_q.push_back(tx);
	endfunction
	
	task run_phase(uvm_phase phase);
		my_transaction inp_mon_xn;
		my_transaction out_mon_xn;
		held=my_transaction::type_id::create("held");
		forever begin
			wait((in_q.size()!=0)&&(out_q.size()!=0)) begin
				if (inp_mon_xn==null) begin
					inp_mon_xn=in_q.pop_front();
					void'(out_q.pop_front());
				end else begin
					out_mon_xn=out_q.pop_front();
					ref_task(inp_mon_xn);
					validate_outputs(inp_mon_xn,out_mon_xn);
					inp_mon_xn=in_q.pop_front();
				end
			end
		end
	endtask

	task validate_outputs(my_transaction inp, my_transaction out);
		++TOTAL;
		if(inp.compare(out)) begin
			++MATCH;
			`uvm_info("SCOREBOARD",$sformatf("DUT: BRESP=%0h, RDATA=%0h, RRESP=%0h\nREF: BRESP=%0h, RDATA=%0h, RRESP=%0h\n\n", out.BRESP, out.RDATA, out.RRESP, inp.BRESP, inp.RDATA, inp.RRESP),UVM_NONE);
		end else begin
			++MISMATCH;
			`uvm_info("SCOREBOARD",$sformatf("DUT: BRESP=%0h, RDATA=%0h, RRESP=%0h\nREF: BRESP=%0h, RDATA=%0h, RRESP=%0h\n_______________________________________________________________________________________________________________________\n_", out.BRESP, out.RDATA, out.RRESP, inp.BRESP, inp.RDATA, inp.RRESP),UVM_NONE);
		end
	endtask

	task ref_task(my_transaction inp);
		if (!inp.rst) begin
			reset_operation();
			reset_hold();
			feed_held_values(inp);
		end else begin
			feed_held_values(inp);
			rd_task(inp);
			wr_task(inp);
		end
	endtask
	
	task wr_task(my_transaction tr);
		if((!wr_add)&&(tr.AWREADY)&&(tr.AWVALID)) begin held.AWADDR=tr.AWADDR; held.AWPROT=tr.AWPROT; wr_add=1; end
		if((!wr_data)&&(tr.WREADY)&&(tr.WVALID)) begin held.WDATA=tr.WDATA; held.WSTRB=tr.WSTRB; wr_data=1; end
		if((wr_add)&&(wr_data)) if(count==1) begin gen_wr_resp(tr); wr_add=0; wr_data=0; count=0; end else count++;
	endtask

	task rd_task(my_transaction tr);
		if((tr.ARREADY)&&(tr.ARVALID)) begin held.ARADDR =tr.ARADDR; held.ARPROT=tr.ARPROT; gen_rd_resp(tr); end
	endtask

	task gen_wr_resp(my_transaction tr);
		wr_operation(tr);
		hold_wr_values(tr);
	endtask

	task gen_rd_resp(my_transaction tr);
		rd_operation(tr);
		hold_rd_values(tr);
	endtask
	
	task reset_operation();
		for(int i=0;i<64;i++) mem[i]=0;
	endtask

	task wr_operation(my_transaction tr);
		if (held.AWADDR>63) begin
			tr.BRESP=2'b11;
		end else if ((held.AWADDR>`AW'h24&&held.AWADDR<`AW'h34)||(held.AWADDR[1:0]!=00)) begin
			tr.BRESP=2'b10;
		end else begin
			tr.BRESP=00;
			if(held.AWPROT==00) begin
				if(held.WSTRB[3]) mem[held.AWADDR+3]=held.WDATA[31:24];
				if(held.WSTRB[2]) mem[held.AWADDR+2]=held.WDATA[23:16];
				if(held.WSTRB[1]) mem[held.AWADDR+1]=held.WDATA[15:8];
				if(held.WSTRB[0]) mem[held.AWADDR+0]=held.WDATA[7:0];
			end
		end
	endtask

	task rd_operation(my_transaction tr);
		if (held.ARADDR>63) begin
			tr.RRESP=2'b11;
			tr.RDATA={`DW{1'b0}};
		end else if ((held.ARADDR>`AW'h30&&held.ARADDR<`AW'h3C)||(held.ARADDR[1:0]!=00)) begin
			tr.RRESP=2'b10;
			tr.RDATA={`DW{1'b0}};
		end else begin
			tr.RRESP=00;
			if(held.ARPROT==00) begin
				tr.RDATA[7:0]=mem[held.ARADDR];
				tr.RDATA[15:8]=mem[held.ARADDR+1];
				tr.RDATA[23:16]=mem[held.ARADDR+2];
				tr.RDATA[31:24]=mem[held.ARADDR+3];
			end
		end	
	endtask

	task reset_hold();
		held.RRESP=0;
		held.RDATA=0;
		held.BRESP=0;
	endtask

	task hold_wr_values(my_transaction tr);
		held.BRESP=tr.BRESP;
	endtask

	task hold_rd_values(my_transaction tr);
		held.RRESP=tr.RRESP;
		held.RDATA=tr.RDATA;
	endtask

	task feed_held_values(my_transaction tr);
		tr.RDATA=held.RDATA;
		tr.RRESP=held.RRESP;
		tr.BRESP=held.BRESP;
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCOREBOARD",$sformatf("\nTotal clock Cycles Checked:%0d\n Total cycles matched:%0d\n Total cycles failes:%0d",TOTAL,MATCH,MISMATCH),UVM_NONE);
	endfunction
endclass
