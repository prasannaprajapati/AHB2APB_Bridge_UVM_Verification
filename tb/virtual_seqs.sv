class virtual_seqs extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(virtual_seqs);

function new(string name="virtual_seqs");
 super.new(name);
endfunction

 master_seqr m_seqrh;
 slave_seqr seqrh;
 virtual_seqr v_seqrh;
  
  single_transfer seq1;
  inc_seqs seq2;
  wrap_seqs seq3;
  
  task body();
   if(!$cast(v_seqrh, m_sequencer))
   begin
      `uvm_error("BODY", "Failed to cast virtual sequencer")
   return;
   end
    m_seqrh=v_seqrh.m_seqrh;
	seqrh=v_seqrh.seqrh;
  endtask
endclass

class v_seq1 extends virtual_seqs;
  `uvm_object_utils(v_seq1);

function new(string name="v_seq1");
  super.new(name);
endfunction
  
task body();
  super.body();
  seq1=single_transfer::type_id::create("seq1");
  seq1.start(m_seqrh);
 endtask
endclass
  
class v_seq2 extends virtual_seqs;
  `uvm_object_utils(v_seq2);

  function new(string name="v_seq2");
    super.new(name);
  endfunction
  
  task body();
  super.body();
   seq2=inc_seqs::type_id::create("seq2");
     seq2.start(m_seqrh);
   endtask
endclass
 
class v_seq3 extends virtual_seqs;
  `uvm_object_utils(v_seq3);

  function new(string name="v_seq3");
    super.new(name);
  endfunction

   task body();
    super.body();
     seq3=wrap_seqs::type_id::create("seq3");
     seq3.start(m_seqrh);
   endtask
endclass
 


