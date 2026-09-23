/*class test extends uvm_test;
	`uvm_component_utils(test);
	environment env;
	sequences seq;
	wr_rd_always_simul_rand wr_rd;
	wr_only_always_simul_rand wr;
	wr_only_always_1_by_1_rand wr1;
	wr_only_always_1_by_2_rand wr2;
	rd_only_always_rand rd;
	back_pressure_rand bk;

	wr_rd_always_simul_v wr_rd;
	wr_only_always_simul_v wr;
	wr_only_always_1_by_1_v wr1;
	wr_only_always_1_by_2_v wr2;
	rd_only_always_v rd;
	back_pressure_v bk;

	wr_rd_always_simul_in wr_rd;
	wr_only_always_simul_in wr;
	wr_only_always_1_by_1_in wr1;
	wr_only_always_1_by_2_in wr2;
	rd_only_always_in rd;
	back_pressure_in bk;

	wr_rd_always_simul_out wr_rd;
	wr_only_always_simul_out wr;
	wr_only_always_1_by_1_out wr1;
	wr_only_always_1_by_2_out wr2;
	rd_only_always_out rd;
	back_pressure_out bk;

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
		seq.start(env.act.sqr);
		wr=wr_only_always_simul_rand::type_id::create("wr");
		wr.start(env.act.sqr);
		rd=rd_only_always_rand::type_id_rand::create("rd");
		rd.start(env.act.sqr);
		wr1=wr_only_always_1_by_1_rand::type_id::create("wr1");
		wr1.start(env.act.sqr);
		rd=rd_only_always_rand::type_id::create("rd");
		rd.start(env.act.sqr);
		wr2=wr_only_always_1_by_2_rand::type_id::create("wr2");
		wr2.start(env.act.sqr);
		rd=rd_only_always_rand::type_id::create("rd");
		rd.start(env.act.sqr);
		wr_rd=wr_rd_always_simul_rand::type_id::create("wr_rd");
		wr_rd.start(env.act.sqr);
		bk=back_pressure_rand::type_id::create("bk");
		bk.start(env.act.sqr);
	endtask
endclass */

class wr_rd_simul_rand extends uvm_test;
	`uvm_component_utils(wr_rd_simul_rand);
	environment env;
	wr_rd_always_simul_rand wr_rd;

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
		wr_rd=wr_rd_always_simul_rand::type_id::create("wr_rd");
		wr_rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_simul_rand extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_simul_rand);
	environment env;
	wr_only_always_simul_rand wr;
	rd_only_always_rand rd;

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
		wr=wr_only_always_simul_rand::type_id::create("wr");
		wr.start(env.act.sqr);
		rd=rd_only_always_rand::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_awaddr_first_rand extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_awaddr_first_rand);
	environment env;
	wr_only_always_1_by_1_rand wr1;
	rd_only_always_rand rd;

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
		wr1=wr_only_always_1_by_1_rand::type_id::create("wr1");
		wr1.start(env.act.sqr);
		rd=rd_only_always_rand::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_wdata_first_rand extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_wdata_first_rand);
	environment env;
	wr_only_always_1_by_2_rand wr2;
	rd_only_always_rand rd;

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
		wr2=wr_only_always_1_by_2_rand::type_id::create("wr2");
		wr2.start(env.act.sqr);
		rd=rd_only_always_rand::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class back_rand extends uvm_test;
	`uvm_component_utils(back_rand);
	environment env;
	back_pressure_rand bk;

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
		bk=back_pressure_rand::type_id::create("bk");
		bk.start(env.act.sqr);
	endtask
endclass

class wr_rd_simul_v extends uvm_test;
	`uvm_component_utils(wr_rd_simul_v);
	environment env;
	wr_rd_always_simul_v wr_rd;

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
		wr_rd=wr_rd_always_simul_v::type_id::create("wr_rd");
		wr_rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_simul_v extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_simul_v);
	environment env;
	wr_only_always_simul_v wr;
	rd_only_always_v rd;

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
		wr=wr_only_always_simul_v::type_id::create("wr");
		wr.start(env.act.sqr);
		rd=rd_only_always_v::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_awaddr_first_v extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_awaddr_first_v);
	environment env;
	wr_only_always_1_by_1_v wr1;
	rd_only_always_v rd;

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
		wr1=wr_only_always_1_by_1_v::type_id::create("wr1");
		wr1.start(env.act.sqr);
		rd=rd_only_always_v::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_wdata_first_v extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_wdata_first_v);
	environment env;
	wr_only_always_1_by_2_v wr2;
	rd_only_always_v rd;

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
		wr2=wr_only_always_1_by_2_v::type_id::create("wr2");
		wr2.start(env.act.sqr);
		rd=rd_only_always_v::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class back_v extends uvm_test;
	`uvm_component_utils(back_v);
	environment env;
	back_pressure_v bk;

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
		bk=back_pressure_v::type_id::create("bk");
		bk.start(env.act.sqr);
	endtask
endclass

class wr_rd_simul_in extends uvm_test;
	`uvm_component_utils(wr_rd_simul_in);
	environment env;
	wr_rd_always_simul_in wr_rd;

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
		wr_rd=wr_rd_always_simul_in::type_id::create("wr_rd");
		wr_rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_simul_in extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_simul_in);
	environment env;
	wr_only_always_simul_in wr;
	rd_only_always_in rd;

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
		wr=wr_only_always_simul_in::type_id::create("wr");
		wr.start(env.act.sqr);
		rd=rd_only_always_in::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_awaddr_first_in extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_awaddr_first_in);
	environment env;
	wr_only_always_1_by_1_in wr1;
	rd_only_always_in rd;

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
		wr1=wr_only_always_1_by_1_in::type_id::create("wr1");
		wr1.start(env.act.sqr);
		rd=rd_only_always_in::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_wdata_first_in extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_wdata_first_in);
	environment env;
	wr_only_always_1_by_2_in wr2;
	rd_only_always_in rd;

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
		wr2=wr_only_always_1_by_2_in::type_id::create("wr2");
		wr2.start(env.act.sqr);
		rd=rd_only_always_in::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class back_in extends uvm_test;
	`uvm_component_utils(back_in);
	environment env;
	back_pressure_in bk;

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
		bk=back_pressure_in::type_id::create("bk");
		bk.start(env.act.sqr);
	endtask
endclass

class wr_rd_simul_out extends uvm_test;
	`uvm_component_utils(wr_rd_simul_out);
	environment env;
	wr_rd_always_simul_out wr_rd;

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
		wr_rd=wr_rd_always_simul_out::type_id::create("wr_rd");
		wr_rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_simul_out extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_simul_out);
	environment env;
	wr_only_always_simul_out wr;
	rd_only_always_out rd;

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
		wr=wr_only_always_simul_out::type_id::create("wr");
		wr.start(env.act.sqr);
		rd=rd_only_always_out::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_awaddr_first_out extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_awaddr_first_out);
	environment env;
	wr_only_always_1_by_1_out wr1;
	rd_only_always_out rd;

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
		wr1=wr_only_always_1_by_1_out::type_id::create("wr1");
		wr1.start(env.act.sqr);
		rd=rd_only_always_out::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class rd_after_wr_with_wdata_first_out extends uvm_test;
	`uvm_component_utils(rd_after_wr_with_wdata_first_out);
	environment env;
	wr_only_always_1_by_2_out wr2;
	rd_only_always_out rd;

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
		wr2=wr_only_always_1_by_2_out::type_id::create("wr2");
		wr2.start(env.act.sqr);
		rd=rd_only_always_out::type_id::create("rd");
		rd.start(env.act.sqr);
	endtask
endclass

class back_out extends uvm_test;
	`uvm_component_utils(back_out);
	environment env;
	back_pressure_out bk;

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
		bk=back_pressure_out::type_id::create("bk");
		bk.start(env.act.sqr);
	endtask
endclass
