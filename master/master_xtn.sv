class master_xtn extends uvm_sequence_item;

`uvm_object_utils(master_xtn)

rand bit [31:0] Haddr;
rand bit [31:0] Hwdata;
rand bit [2:0] Hsize;
rand bit [2:0] Hburst;
rand bit Hwrite;
rand bit [1:0] Htrans;
rand bit Hresetn;
rand bit Hresp;
rand bit Hreadyin;
rand bit Hreadyout;
rand bit [31:0] Hrdata;
rand bit [9:0] length;

constraint valid_Hsize{Hsize inside {0,1,2};}
constraint vlaid_Haddr{Haddr inside{
				[32'h8000_0000:32'h8000_03FF],
				[32'h8400_0000:32'h8400_03FF],
				[32'h8800_0000:32'h8800_03FF],
				[32'h8C00_0000:32'h8C00_03FF]};}
constraint valid_length{Hburst==3'b000->length==1;}
constraint valid_unspecified_length{Hburst==3'b001->(Haddr%1024+(length*(2**Hsize)))<=1024;}

constraint valid_wrap4{Hburst==3'b010->length==4;} //wrap burst
constraint valid_inc4{Hburst==3'b011->length==4;} //inc burst
constraint valid_wrap8{Hburst==3'b100->length==8;}  
constraint valid_inc8{Hburst==3'b101->length==8;}
constraint valid_wrap16{Hburst==3'b110->length==16;} //wrap burst 
constraint valid_inc16{Hburst==3'b111->length==16;} //increment burst

//now when Hsize=2 then each time werare going to write 2bytes
constraint valid_size2{Hsize==2'b01->Haddr%2==0;} //will generate values/Haddr with multiples of 2, ex00,02,04,06...

//now when Hsize=2 then each time we are going to write 4bytes so generating address only with multiple of 4 
constraint valid_size4{Hsize==2'b10->Haddr%4==0;} //will generate values/Haddr with multiples of 2, ex: - 00,04,08,012...

function new(string name="master_xtn");
super.new(name);
endfunction

function void do_print(uvm_printer printer);
	super.do_print(printer);
	
	printer.print_field("Haddr",  this.Haddr, 32, UVM_DEC);
	printer.print_field("Hwdata", this.Hwdata, 32, UVM_DEC);
	printer.print_field("Hrdata", this.Hrdata, 32, UVM_DEC);
	printer.print_field("Htrans", this.Htrans, 2, UVM_BIN);
	printer.print_field("Hsize",  this.Hsize,  3, UVM_BIN);
	printer.print_field("Hburst", this.Hburst, 3, UVM_BIN);
	printer.print_field("Hresp",  this.Hresp,  2, UVM_BIN);
	printer.print_field("Length", this.length, 10, UVM_DEC);
	printer.print_field("Hresetn",this.Hresetn,1, UVM_BIN);
	printer.print_field("Hwrite", this.Hwrite,1, UVM_BIN);
	printer.print_field("HReadyin",this.Hreadyin,1, UVM_BIN);
	printer.print_field("HReadyout",this.Hreadyout,1, UVM_BIN);
	
endfunction
endclass