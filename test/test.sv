class base_test extends uvm_test;

`uvm_component_utils(base_test);

function new(string name="base_test",uvm_component parent);	
	super.new(name,parent);
endfunction

environment envh;
env_config ecfgh;
master_config mcfgh;
slave_config  scfgh;


int has_sagent=1;
int has_magent=1;
int has_scoreboard=1;

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("TEST", " In BUILD_PHASE of TEST class", UVM_LOW)
	
	// create object for env_config handle
	ecfgh = env_config::type_id::create("ecfgh");

	// declaring no of cfg required for master and slave
	if(has_magent)
	begin
			mcfgh = master_config::type_id::create("mcfgh");
	if(!uvm_config_db #(virtual master_if)::get(this, "", "h_if",mcfgh.vif))
		`uvm_fatal("CONFIIG", " Failed to get config from top module")
		mcfgh.is_active = UVM_ACTIVE;
		ecfgh.has_magent =1;
		ecfgh.mcfgh= mcfgh;
	end
	if(has_sagent)
	begin
		scfgh = slave_config::type_id::create("scfgh");
	if(!uvm_config_db #(virtual slave_if)::get(this, "", "p_if",scfgh.vif))
		`uvm_fatal("CONFIIG", " Failed to get config from top module")
		scfgh.is_active = UVM_ACTIVE;
		ecfgh.has_sagent =1;
		ecfgh.scfgh= scfgh;
	end
	uvm_config_db #(env_config)::set(this, "*", "env_config", ecfgh);
	envh = environment::type_id::create("envh", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
endfunction

endclass

class single_test extends base_test;

  `uvm_component_utils(single_test);
  
 v_seq1 vseq1; 
 
  function new (string name="single_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq1=v_seq1::type_id::create("vseq1");
    vseq1.start(envh.v_seqrh);
 #90;
   phase.drop_objection(this);
  endtask  
endclass

class incr_test extends base_test;

  `uvm_component_utils(incr_test);

  function new (string name="incr_test",uvm_component parent);
    super.new(name,parent);
  endfunction

v_seq2 vseq2;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq2=v_seq2::type_id::create("vseq2");
    vseq2.start(envh.v_seqrh);
#100;
    phase.drop_objection(this);
  endtask
endclass



class wrap_test extends base_test;
  
 `uvm_component_utils(wrap_test);


  function new (string name="wrap_test",uvm_component parent);
    super.new(name,parent);
  endfunction

 v_seq3 vseq3;
 
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq3=v_seq3::type_id::create("vseq3");
    vseq3.start(envh.v_seqrh);
#200;   
 phase.drop_objection(this);
  endtask
endclass



