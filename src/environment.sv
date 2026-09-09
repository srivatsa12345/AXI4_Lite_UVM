class environment extends uvm_env;
	`uvm_component_utils(environment)
	agent act;
	agent pass;
	scoreboard sc;
	subscriber sub;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		act=agent::type_id::create("act",this);
		pass=agent::type_id::create("pass",this);
		sc=scoreboard::type_id::create("sc",this);
		sub=subscriber::type_id::create("sub",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		act.mon.ap.connect(sc.in_mon);
		pass.mon.ap.connect(sc.out_mon);
		act.mon.ap.connect(sub.analysis_export);
		pass.mon.ap.connect(sub.out_mon);
	endfunction

endclass
