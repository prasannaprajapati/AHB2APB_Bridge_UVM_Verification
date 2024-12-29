class master_agt_top extends uvm_env;

`uvm_component_utils(master_agt_top)


master_agent magent;
env_config ecfgh;
master_config mcfgh;

function new(string name="master_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",ecfgh))
		`uvm_fatal(get_type_name(),"Cannot get env_config in agt_top")
	uvm_config_db #(master_config)::set(this, "*", "master_config", ecfgh.mcfgh);
	magent=master_agent::type_id::create("magent",this);
endfunction

endclass

