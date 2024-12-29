class environment extends uvm_env;

`uvm_component_utils(environment)

master_agt_top magt_top;
slave_agt_top sagt_top;
virtual_seqr v_seqrh;
scoreboard sb;
env_config ecfg;


function new(string name = "environment", uvm_component parent);
		super.new(name,parent);
endfunction
	
function void build_phase(uvm_phase phase);
	// Get the config object using uvm_config_db 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",ecfg))
		`uvm_fatal("CONFIG","cannot get() ecfg from uvm_config_db. Have you set() it?")
		
    //Create agents based on environment configuration
      if(ecfg.has_magent) 
	   begin
          uvm_config_db #(master_config)::set(this,"master_agt_top*","master_agt_config",ecfg.mcfgh);
          magt_top=master_agt_top::type_id::create("magt_top",this); 
       end
	  if(ecfg.has_sagent)
		begin
		  uvm_config_db #(slave_config)::set(this,"slave_agt_top*","slave_agt_config",ecfg.scfgh);
		  sagt_top=slave_agt_top::type_id::create("sagt_top",this);
		end
		
	  super.build_phase(phase);
 //Ensure virtual sequencer is created with proper checks
 if(ecfg.has_virtual_seqr && (ecfg.has_magent || ecfg.has_sagent)) 
  begin
   v_seqrh = virtual_seqr::type_id::create("v_seqrh",this);
  end
sb=scoreboard::type_id::create("sb",this);
endfunction 
	  
function void connect_phase(uvm_phase phase);
	  if(ecfg.has_virtual_seqr)
	  begin
	      if(ecfg.has_magent)
	      v_seqrh.m_seqrh = magt_top.magent.seqrh;
		 // if(ecfg.has_sagent)
          //v_seqrh.slave_seqrh = slave_agt_top.magent.seqrh;
      end
		magt_top.magent.monh.ah.connect(sb.master_fifo.analysis_export);
        sagt_top.sagent.monh.ap.connect(sb.slave_fifo.analysis_export);
endfunction
endclass

		