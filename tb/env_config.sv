class env_config extends uvm_object;

`uvm_object_utils(env_config)

master_config mcfgh;
slave_config scfgh;

int has_scoreboard=1;
int has_magent=1;
int has_sagent=1;
int has_virtual_seqr=1;
	
	// int no_of_duts;
	// int no_of_master_agents=1;
	// int no_of_slave_agents=1;

function new(string name="env_config");
	super.new(name);
endfunction
endclass