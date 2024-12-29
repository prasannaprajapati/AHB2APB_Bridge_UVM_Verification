class slave_agent extends uvm_agent;

`uvm_component_utils(slave_agent)

slave_config scfgh;
slave_seqr seqrh;
slave_driver drvh;
slave_monitor monh;


function new(string name="slave_agent",uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(slave_config)::get(this,"","slave_config",scfgh))
		`uvm_fatal(get_type_name(),"Cannot  get slave_config in slave _agent")
	monh=slave_monitor::type_id::create("monh",this);
	if(scfgh.is_active==UVM_ACTIVE)
	begin
		seqrh= slave_seqr::type_id::create("seqrh",this);
		drvh = slave_driver::type_id::create("drvh",this);
	end
endfunction

function void connect_phase(uvm_phase phase);
//connect seqr and drv
if(scfgh.is_active==UVM_ACTIVE)
drvh.seq_item_port.connect(seqrh.seq_item_export);
$display("In the slave agent connect_phase");
endfunction
endclass