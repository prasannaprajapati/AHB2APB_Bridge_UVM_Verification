class slave_config extends uvm_object;
`uvm_object_utils(slave_config)
uvm_active_passive_enum is_active=UVM_ACTIVE;
virtual slave_if vif;
function new(string name="slave_config");
	super.new(name);
endfunction

endclass
