class test extends uvm_test;
	`uvm_component_utils(test);
	environment env;
	sequences seq;

	function new (string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "env.act", "is_active", UVM_ACTIVE);
		uvm_config_db#(uvm_active_passive_enum)::set(this, "env.pass", "is_active", UVM_PASSIVE);
		env=environment::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		run();
		phase.phase_done.set_drain_time(this,20);
		phase.drop_objection(this);
	endtask

	task run();
		seq=sequences::type_id::create("seq");
		seq.start(env.a_ag.sqr);
	endtask
endclass


