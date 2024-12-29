class virtual_seqr extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_seqr);
  
  master_seqr m_seqrh;
  slave_seqr seqrh; 

  function new(string name="virtual_seqr",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_seqrh=master_seqr::type_id::create("m_seqrh",this);
  seqrh=slave_seqr::type_id::create("seqrh",this);
  endfunction
endclass