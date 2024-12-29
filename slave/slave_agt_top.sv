 class slave_agt_top extends uvm_env;
`uvm_component_utils(slave_agt_top)

slave_agent sagent;
env_config ecfgh;
slave_config scfgh;


function new(string name="slave_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(env_config)::get(this,"","env_config",ecfgh))
		`uvm_fatal(get_type_name(),"Cannot get env_config in agt_top")
uvm_config_db #(slave_config)::set(this, "*", "slave_config", ecfgh.scfgh);
	sagent=slave_agent::type_id::create("sagent",this);
endfunction
endclass
