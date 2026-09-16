class subscriber extends uvm_subscriber#(my_transaction);
  	`uvm_component_utils(subscriber)    
  	
	uvm_analysis_imp_out #(my_transaction,subscriber) out_mon;  
  	my_transaction in_mon_xn;   
  	my_transaction out_mon_xn;  
	covergroup input_cg;   
		awaddr:coverpoint in_mon_xn.AWADDR iff((in_mon_xn.AWVALID)&&(in_mon_xn.AWREADY)){
			bins rw1={[0:39]} with (item%4==0);
			bins ro={[40:51]} with (item%4==0);
			bins wo={[52:59]} with (item%4==0);
			bins rw2={[60:63]} with (item%4==0);
			bins invalid1={[0:63]} with (item%4!=0);
			bins invalid2={[64:$]};
		}
		wstrb:coverpoint in_mon_xn.WSTRB iff((in_mon_xn.WVALID)&&(in_mon_xn.WREADY)){
			bins strb[]={[0:15]};
		}
		araddr:coverpoint in_mon_xn.ARADDR iff((in_mon_xn.ARVALID)&&(in_mon_xn.ARREADY)){
			bins rw1={[0:39]} with (item%4==0);
			bins ro={[40:51]} with (item%4==0);
			bins wo={[52:59]} with (item%4==0);
			bins rw2={[60:63]} with (item%4==0);
			bins invalid1={[0:63]} with (item%4!=0);
			bins invalid2={[64:$]};
		}
		AWADDRxWSTRB:cross awaddr,wstrb{
			ignore_bins ig=binsof(awaddr.invalid1)|| binsof(awaddr.invalid2);
		}
	endgroup:input_cg
  	covergroup output_cg;  
		bresp:coverpoint out_mon_xn.BRESP iff(out_mon_xn.BVALID){
			bins okay={0};
			bins slverr={2};
			bins decerr={3};
		}
		rresp:coverpoint out_mon_xn.RRESP iff(out_mon_xn.RVALID){
			bins okay={0};
			bins slverr={2};
			bins decerr={3};
		}
	endgroup:output_cg
 
	function new(string name, uvm_component parent);
    		super.new(name,parent);
    		input_cg = new();
    		output_cg = new();
  	endfunction:new
 
  	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		out_mon = new("out_mon",this);
  	endfunction
 
  	virtual function void write(my_transaction t);     
    		$cast(in_mon_xn,t);
   		input_cg.sample();
    		`uvm_info(get_name,"[SUB]:INPUT RECIEVED",UVM_HIGH)
  	endfunction
 
  	virtual function void write_out(my_transaction seq);  
    		$cast(out_mon_xn,seq);
    		output_cg.sample();
    		`uvm_info(get_name,"[SUB]:OUTPUT RECIEVED",UVM_HIGH)
 	 endfunction

  	function void report_phase(uvm_phase phase);
    		super.report_phase(phase);
    		`uvm_info(get_name,$sformatf("INPUT COVERAGE = %0f\n",input_cg.get_coverage()),UVM_NONE);
    		`uvm_info(get_name,$sformatf("OUTPUT COVERAGE = %0f\n",output_cg.get_coverage()),UVM_NONE);
  	endfunction
endclass
