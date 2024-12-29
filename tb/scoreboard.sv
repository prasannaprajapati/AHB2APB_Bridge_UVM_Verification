class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard);
	
	uvm_tlm_analysis_fifo #(master_xtn) master_fifo;
	uvm_tlm_analysis_fifo #(slave_xtn) slave_fifo;
	
	master_xtn h_trans;
	slave_xtn p_trans;   
	
	//ahb_trans ahb_cov_data;
	//apb_trans apb_cov_data ;
	

	
	covergroup cg1;
	
		option.per_instance = 1;
		
		Haddr: coverpoint h_trans.Haddr { 
											bins slave_1 = { [32'h8000_0000:32'h8000_03ff]};
											bins slave_2 = { [32'h8400_0000:32'h8400_03ff]};
											bins slave_3 = { [32'h8800_0000:32'h8800_03ff]};
											bins slave_4 = { [32'h8c00_0000:32'h8c00_03ff]};
										}
		
		HSIZE: coverpoint h_trans.Hsize { 
											bins byte_1 ={0};
											bins byte_2 ={1};
											bins byte_3 ={2};
										}
										
		HWRITE: coverpoint h_trans.Hwrite{ 
											bins write ={1};
											bins read ={0};
										}
										
		HTRANS: coverpoint h_trans.Htrans {
											bins non_seq ={2'b10};
											bins seq = {2'b11};
										  }
										  
		ADDR_X_HSIZE_X_HWRITE_X_HTRANS: cross Haddr, HWRITE, HSIZE, HTRANS;
		
	endgroup
	
	covergroup cg2;
	
		option.per_instance = 1;
		
		Paddr: coverpoint p_trans.Paddr { 
											bins slave_1 = { [32'h8000_0000:32'h8000_03ff]};
											bins slave_2 = { [32'h8400_0000:32'h8400_03ff]};
											bins slave_3 = { [32'h8800_0000:32'h8800_03ff]};
											bins slave_4 = { [32'h8c00_0000:32'h8c00_03ff]};
										}
										
		PSELX: coverpoint p_trans.Pselx {
											bins selx_1 ={1};
											bins selx_2 ={2};
											bins selx_3 ={4};
											bins selx_4 ={8};
										}
		
	endgroup
	
function new(string name="scoreboard", uvm_component parent);
super.new(name,parent);
cg1 = new();
cg2 = new();
master_fifo = new("master_fifo",this);
    slave_fifo = new("slave_fifo",this);
endfunction

//----------build_phase-----------------
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
  
  
 //--------run_phase------------------
task run_phase(uvm_phase phase);
super.run_phase(phase);
	forever
	begin
	fork
	begin
	//Getting data from master monitor to tlm fifo inside scoreboard
		master_fifo.get(h_trans);
		`uvm_info(get_type_name(),$sformatf("printing the master_fifo_trans = %s",h_trans.sprint),UVM_LOW);
		cg1.sample();
		end
			// comparing the h_trans and p_trans transcation
			begin
			//Getting the data from slave monitor to tlm fifo insdie scoreboard
				slave_fifo.get(p_trans); //trans class name 
				`uvm_info(get_type_name(),$sformatf("printing the slave_fifo_trans = %s",p_trans.sprint),UVM_LOW);
				cg2.sample();
			end
		join

	check_data(h_trans, p_trans);
	end
	
endtask

task check_data(master_xtn h_trans, slave_xtn p_trans);
// Comparing on condition hsize and hwrite
	if(h_trans.Hwrite == 1)  //write condition
		begin
	if(h_trans.Hsize == 2'b00) //2^0=1 byte so addr is 2e882088 according to the 8=1000, last 2bits 00 will be taken, 00 means 1st btye 
		begin   //Haddr=84000248, then 8=10|00 so 00 is 1st byte is cosider from Hdata
	                if(h_trans.Haddr[1:0] == 2'b00) //1st byte sent to pwdata
	                compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[7:0], p_trans.Pwdata);
						
						/*Hwdata= 3e 5f 22 94
								 -- -- -- --
						Byte=     4  3  2  1 
								 -- -- -- --
						2'b=	11 10 01 00*/
						
					if(h_trans.Haddr[1:0] == 2'b01)
					compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[15:8], p_trans.Pwdata);
						
					if(h_trans.Haddr[1:0] == 2'b10)
					compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[23:16], p_trans.Pwdata);
						
					if(h_trans.Haddr[1:0] == 2'b11)
					compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[31:24], p_trans.Pwdata);
				end
				
			if(h_trans.Hsize == 2'b01)//2^1= 2 byte
				begin
					if(h_trans.Haddr[1:0] == 2'b00) //2 bytes sending
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[15:0], p_trans.Pwdata);
						
					if(h_trans.Haddr[1:0] == 2'b10) //MSB 2 bytes 
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata[31:16], p_trans.Pwdata);
				end
				
			if(h_trans.Hsize == 2'b10) //2^2= 4 byte
			// all data transfer
				begin
					compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hwdata, p_trans.Pwdata);
				end
		end
		
	if(h_trans.Hwrite == 0)
		begin
			if(h_trans.Hsize == 2'b00)
				begin
					if(h_trans.Haddr[1:0] == 2'b00)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[7:0]);
						
					if(h_trans.Haddr[1:0] == 2'b01)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[15:8]);
						
					if(h_trans.Haddr[1:0] == 2'b10)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[23:16]);
						
					if(h_trans.Haddr[1:0] == 2'b11)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[31:24]);
				end
				
			if(h_trans.Hsize == 2'b01)
				begin
					if(h_trans.Haddr[1:0] == 2'b00)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[15:0]);
						
					if(h_trans.Haddr[1:0] == 2'b10)
						compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata[31:16]);
				end
				
			if(h_trans.Hsize == 2'b10) //2^2=4 bytes
				begin
					compare(h_trans.Haddr, p_trans.Paddr, h_trans.Hrdata, p_trans.Prdata);
				end
		end
endtask  

task compare(int Haddr, Paddr, Hrdata, Prdata);	
	if(Haddr == Paddr)
		$display("ADDRESS are sucessfully matching");
	else
		$display("ADDRESS are NOT matching");
		
	if(Hrdata == Prdata)
		$display("DATA are sucessfully matching");
	else
		$display("DATA are NOT matching");
endtask
endclass
	
	
