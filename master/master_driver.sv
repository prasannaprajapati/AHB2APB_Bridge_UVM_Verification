class master_driver extends uvm_driver;

`uvm_component_utils(master_driver)

//Virtual Interface for master and modport name 
//config database in master agent top
virtual master_if.MDRV_MP vif;

master_config mcfgh;


//----------new constructor()----------
function new(string name="master_driver",uvm_component parent);
	super.new(name,parent);
endfunction

//--------build_phase()---------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(master_config)::get(this,"","master_config",mcfgh))
		`uvm_fatal(get_type_name(),"Cannot get master_config in driver")
endfunction

//--------connect_phase----------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	vif=mcfgh.vif;
	$display("I am in the master driver connect_phase %p", mcfgh.vif);
endfunction

//--------run_phase------------
task run_phase(uvm_phase phase);

		@(vif.drv_cb);
		//reset dut in 1CC
		vif.drv_cb.Hresetn<=1'b0;
		@(vif.drv_cb);  //2CC
		vif.drv_cb.Hresetn<=1'b1; //set
$display("From master driver run_phase");
 forever
      begin
        seq_item_port.get_next_item(req);
        `uvm_info("AHB_DRIVER","DATA SENT TO DUT",UVM_MEDIUM)
	     send_to_dut(req);
	     seq_item_port.item_done();
      end
endtask

task send_to_dut(master_xtn req);

wait(vif.drv_cb.Hreadyout == 1)
    vif.drv_cb.Hwrite  <= req.Hwrite;
    vif.drv_cb.Htrans  <= req.Htrans;
    vif.drv_cb.Hsize   <= req.Hsize;
    vif.drv_cb.Haddr   <= req.Haddr;
    vif.drv_cb.Hreadyin<= 1'b1;
	
    @(vif.drv_cb);
    wait(vif.drv_cb.Hreadyout==1)
    if(req.Hwrite==1)
      vif.drv_cb.Hwdata<=req.Hwdata;
    else
      vif.drv_cb.Hwdata<=0;
	  $display("*****************************PRINTING FROM AHB DRIVER********************************");
	req.print();
endtask
endclass
