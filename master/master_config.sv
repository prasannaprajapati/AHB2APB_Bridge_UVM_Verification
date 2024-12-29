class master_config extends uvm_object;

`uvm_object_utils(master_config)

uvm_active_passive_enum is_active=UVM_ACTIVE;

virtual master_if vif;

function new(string name="master_config");
	super.new(name);
endfunction
endclass
