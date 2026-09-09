class agent extends uvm_agent;
	`uvm_component_utils(agent)
	driver drv;
	my_sequencer sqr;
	monitor mon;
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon=monitor::type_id::create("mon",this);
		if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active)) begin
			`uvm_info("AGENT", "ACTIVE AGENT CREATED", UVM_LOW)
			 is_active = UVM_ACTIVE;
		end
		if (is_active==UVM_ACTIVE) begin
			drv=driver::type_id::create("drv",this);
			sqr=my_sequencer::type_id::create("sqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		if (is_active==UVM_ACTIVE)
			drv.seq_item_port.connect(sqr.seq_item_export);
	endfunction
endclass	

	
