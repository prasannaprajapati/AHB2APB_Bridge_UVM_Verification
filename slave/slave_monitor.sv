class slave_monitor extends uvm_monitor;

`uvm_component_utils(slave_monitor)

virtual slave_if.MMON_MP vif;

uvm_analysis_port #(slave_xtn) ap;

slave_config scfgh;
slave_xtn p_trans;

function new(string name="slave_monitor",uvm_component parent);
	super.new(name,parent);
	ap=new("ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(slave_config)::get(this,"","slave_config",scfgh))
	`uvm_fatal(get_type_name(),"Cannot get slave_config in monitor")
endfunction

function void connect_phase(uvm_phase phase);
	vif=scfgh.vif;
	$display("From slave monitor connect_phase");
endfunction

task run_phase(uvm_phase phase);
forever
	collect_data();
endtask

task collect_data();

p_trans = slave_xtn::type_id::create("p_trans");
wait(vif.mon_cb.Penable==1)
	p_trans.Paddr=vif.mon_cb.Paddr;
	p_trans.Pwrite=vif.mon_cb.Pwrite;
	p_trans.Pselx=vif.mon_cb.Pselx;
	p_trans.Penable=vif.mon_cb.Penable;

if(p_trans.Pwrite==1)
	p_trans.Pwdata=vif.mon_cb.Pwdata;
else
	p_trans.Prdata=vif.mon_cb.Prdata;
@(vif.mon_cb);

	p_trans.print;
	ap.write(p_trans);

$display("From slave monitor run_phase");
p_trans.print();
endtask

endclass
