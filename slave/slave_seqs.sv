class slave_seqs extends uvm_sequence #(slave_xtn);  
	
	`uvm_object_utils(slave_sequence)  

function new(string name ="slave_seqs");
	super.new(name);
endfunction

 task body();
	req=slave_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize());
	finish_item(req);
endtask