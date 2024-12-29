class slave_driver extends uvm_driver;
`uvm_component_utils(slave_driver)

virtual slave_if.MDRV_MP vif;
slave_config scfgh;
slave_xtn xtn;


function new(string name="slave_driver",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(slave_config)::get(this,"","slave_config",scfgh))
		`uvm_fatal(get_type_name(),"Cannot get slave_config in driver")
endfunction

function void connect_phase(uvm_phase phase);
	vif=scfgh.vif;
	$display("From slave driver connect_phase");
endfunction


task run_phase(uvm_phase phase);
 forever
   begin
	seq_item_port.get_next_item(req);
	send_to_dut();
	seq_item_port.item_done(req);   
	end 
endtask

task send_to_dut();
 wait(vif.drv_cb.Pselx!==0) //x=1,2,4,8
	if(vif.drv_cb.Pwrite==0)
	//@(vif);
	begin
	wait(vif.drv_cb.Penable==1)
	vif.drv_cb.Prdata<={$random};
	end
	@(vif.drv_cb);
	xtn.print();
 $display("From slave driver run_phase");
 
 endtask
 
 endclass
 