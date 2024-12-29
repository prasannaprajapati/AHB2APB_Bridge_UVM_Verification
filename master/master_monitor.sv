class master_monitor extends uvm_monitor;

`uvm_component_utils(master_monitor)

//one interface from DUT a virtual interface
virtual master_if.MMON_MP vif;

//a tlm interface from monito to scoreboard
master_config mcfgh;

uvm_analysis_port #(master_xtn) ah;
//-------new constructor--------
function new(string name="master_monitor",uvm_component parent);
	super.new(name,parent);
	ah=new("ah",this);
endfunction

//-------build_phase------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(master_config)::get(this,"","master_config",mcfgh))
		`uvm_fatal("CONFIG","Cannot get master_config in monitor")
endfunction

//--------connect_phase-----------
function void connect_phase(uvm_phase phase);
	vif=mcfgh.vif;
	$display("From master monitor connect_phase");
endfunction

//------------run_phase-----------
task run_phase(uvm_phase phase);
	forever
		begin
		collect_data();
	end 
endtask

//-----------collect_data---------
task collect_data();
master_xtn h_trans;   //handle declaration of h_trans 
//wait(vif.mon_cb.Hreadyout==1)  when you are using Questa 

begin
h_trans=master_xtn::type_id::create("h_trans");
wait(vif.mon_cb.Hreadyout==1)
//@(vif.mon_cb);
begin
		h_trans.Haddr=vif.mon_cb.Haddr;
		h_trans.Hsize=vif.mon_cb.Hsize;
		h_trans.Hwrite=vif.mon_cb.Hwrite;
		h_trans.Htrans=vif.mon_cb.Htrans;
		h_trans.Hreadyin=vif.mon_cb.Hreadyin;
end
@(vif.mon_cb);
//while(vif.mon_cb.Hreadyout==0)
wait(vif.mon_cb.Hreadyout==1)
		if(h_trans.Hwrite)
		h_trans.Hwdata=vif.mon_cb.Hwdata;
		else
		h_trans.Hrdata=vif.mon_cb.Hrdata;
end 
h_trans.print();
ah.write(h_trans);
$display("*******************************PRINTING FROM AHB MONITOR RUN PHASE*******************************");
endtask

endclass




		



