class test extends uvm_test;
	`uvm_component_utils(test);
	environment env;
	sequences seq;
	wr_rd_always_simul wr_rd;
	wr_only_always_simul wr;
	wr_only_always_1_by_1 wr1;
	rd_only_always rd;

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
		test_cases();
		my_transaction::type_id::set_type_override(out_of_bound_addr::get_type());
		test_cases();
		my_transaction::type_id::set_type_override(inv_addr::get_type());
		test_cases();

	endtask
	
	task test_cases();
		fork 
			begin
				wr=wr_only_always_simul::type_id::create("wr");
				wr.start(env.act.sqr);
			end
			begin
				rd=rd_only_always::type_id::create("rd");
				rd.start(env.act.sqr);
			end
			begin
				wr1=wr_only_always_1_by_1::type_id::create("wr1");
				wr1.start(env.act.sqr);
			end
			begin
				rd=rd_only_always::type_id::create("rd");
				rd.start(env.act.sqr);
			end
			begin
				wr_rd=wr_rd_always_simul::type_id::create("wr_rd");
				wr_rd.start(env.act.sqr);
			end
			begin
				seq=sequences::type_id::create("seq");
				seq.start(env.act.sqr);
			end
		join
	endtask
endclass


