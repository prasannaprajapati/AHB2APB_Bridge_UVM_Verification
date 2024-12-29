class master_seqr extends uvm_sequencer;

`uvm_component_utils(master_seqr)

function new(string name="master_seqr",uvm_component parent);
	super.new(name,parent);
	$display("Im in the master_seqr");
endfunction

endclass
