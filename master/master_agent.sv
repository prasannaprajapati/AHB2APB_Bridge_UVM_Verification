class master_agent extends uvm_agent;

`uvm_component_utils(master_agent)

master_seqr seqrh;
master_driver drvh;
master_monitor monh;
master_config mcfgh;

//--------------new constructor()--------------------------------
function new(string name="master_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

//---------------build_phase()-------------------------------------
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(master_config)::get(this,"","master_config",mcfgh))
		`uvm_fatal(get_type_name(),"Cannot  get master_config in master _agent")
	monh=master_monitor::type_id::create("monh",this);
	if(mcfgh.is_active==UVM_ACTIVE)
	begin
		seqrh= master_seqr::type_id::create("seqrh",this);
		drvh = master_driver::type_id::create("drvh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
	if(mcfgh.is_active==UVM_ACTIVE)
	begin
	drvh.seq_item_port.connect(seqrh.seq_item_export);
	end
$display("In the master agent connect_phase");
endfunction
endclass
