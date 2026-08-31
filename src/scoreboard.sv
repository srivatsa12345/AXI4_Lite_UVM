`uvm_analysis _imp_decl(_out)

class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	uvm_analysis_imp #(my_transaction, scoreboard) in_mon;
	uvm_analysis_imp_out #(my_transaction, scoreboard) out_mon;

	my_transaction in_q[$],out_q[$];

	int TOTAL,MISMATCH,MATCH;

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
		forever begin
			if((in_q.size()!=0)&&(out_q.size()!=0)) begin
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
			`uvm_info("SCOREBOARD",$sformatf("DUT: AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID\nREF: AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID", out.AWREADY, out.WREADY, out.BRESP, out.BVALID, out.ARREADY, out.RDATA, out.RRESP, out.RVALID, inp.AWREADY, inp.WREADY, inp.BRESP, inp.BVALID, inp.ARREADY, inp.RDATA, inp.RRESP, inp.RVALID),UVM_NONE);
		end else begin
			++MISMATCH;
			`uvm_info("SCOREBOARD",$sformatf("DUT: AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID\nREF: AWREADY, WREADY, BRESP, BVALID, ARREADY, RDATA, RRESP, RVALID\n_______________________________________________________________________________________________________________________\n_", out.AWREADY, out.WREADY, out.BRESP, out.BVALID, out.ARREADY, out.RDATA, out.RRESP, out.RVALID, inp.AWREADY, inp.WREADY, inp.BRESP, inp.BVALID, inp.ARREADY, inp.RDATA, inp.RRESP, inp.RVALID),UVM_NONE);
		end
	endtask

	task ref_task(my_transaction inp);
	endtask
	
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCOREBOARD",$sformatf("Total clock Cycles Checked:%0d\n Total cycles matched:%0d\n Total cycles failes:%0d",TOTAL,MATCH,MISMATCH),UVM_NONE);
	endfunction
endclass
