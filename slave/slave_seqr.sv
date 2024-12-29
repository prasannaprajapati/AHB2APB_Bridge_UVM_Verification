class slave_seqr extends uvm_sequencer;

`uvm_component_utils(slave_seqr)

function new(string name="slave_seqr",uvm_component parent);
	super.new(name,parent);
  $display("Im in the slave_seqr");
endfunction

endclass