////////-Base sequence-----////
class master_seqs extends uvm_sequence #(master_xtn);

        `uvm_object_utils(master_seqs)
             
	        logic [31:0] haddr;
            logic hwrite;
            logic [2:0] hsize;
            logic [2:0] hburst;
			
function new(string name = "master_seqs");
        super.new(name);
endfunction
endclass
//------------Single Transfer----------
class single_transfer extends master_seqs;

`uvm_object_utils(single_transfer)

function new(string name="single_transfer");
super.new(name);
endfunction

    task body();
     repeat(2)
		begin
		req=master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with{Htrans==2'b10; Hburst==3'b000;Hwrite==1'b1;});// writing non seqs m
        finish_item(req);
        end
   endtask
endclass
//Incr transfer- it is byte addressable which means at each location we can store 1Bytes or 8bits of data
//---------------------INCR-------------------------
class inc_seqs extends master_seqs;
  
  `uvm_object_utils(inc_seqs);
  
  bit[31:0] haddr;
  bit[2:0] hburst;
  bit[2:0] hsize;
  bit[9:0] Length;
  bit hwrite;
  
  function new(string name = "inc_seqs");
    super.new(name);
  endfunction
  
  task body();
    req = master_xtn::type_id::create("req");
    start_item(req);
    assert (req.randomize() with { Htrans == 2'b10;
                 Hburst inside {3'd1,3'd3,3'd5,3'd7};});
                 
    finish_item(req);
//this is only for non seq now need to wrte for sequnentilal for which we need startinfg addr by
// storing the randomized values in local variable
   
   //local variables
 haddr = req.Haddr;
 hburst = req.Hburst;
 hsize = req.Hsize;
 hwrite = req.Hwrite;
 Length = req.length;
  
for(int i=1; i<= Length; i++)
  begin
    start_item(req);
    assert (req.randomize() with { Htrans == 2'b11;
                Hsize == hsize;
                Hwrite == hwrite;
                Hburst == hburst;
                Haddr == (haddr +(2**Hsize));});
    finish_item(req);
    haddr = req.Haddr;
  end  
  endtask
 endclass
/*WRAP
- How to calculate memory block startingaddr and ending addr in WRAP
- when we are randomizing Haddr, first Non seqs then followed with seqs addr
- 
starting addr=(NS addr/(no.of beats*no.of bytes))*(no.of bytes/no.of beats*no

boundry address= starting addr + (no.of beats*no.ofbytes)

Depending factor  1. Size of a transfer
2. total no. of a transfer

ex-WRAP 4 = 1=2^1=2bytes
=(24/(4*2))*(4*2)=24/8=3*8=24
=24 is starting address

Boundry value= starting addr+(no.of bytes*no.of beats)
=24+(2*4)
=24+8
=32

*/

//-----------------WRAP-------------------
class wrap_seqs extends master_seqs;

	`uvm_object_utils(wrap_seqs)

            bit hwrite;
			bit [2:0] hsize;
			bit [31:0] haddr;
			bit [9:0] Length;
			bit [31:0] Starting_addr;
			bit [31:0] Boundry_addr;

	
function new(string name = "wrap_seqs");
        super.new(name);
endfunction

task body();

   repeat(15)
   begin
        req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize () with { Htrans == 2'b10;
		Hburst inside {3'd2,3'd4,3'd6} ;}) ;
		finish_item(req);
		
		haddr=req.Haddr;
		hsize=req.Hsize;
		hwrite=req.Hwrite;
		Length=req.length;
		hburst=req.Hburst;

		Starting_addr=(haddr/((2**hsize) *Length))*((2**hsize) *Length) ;

		Boundry_addr=Starting_addr +((2**hsize)*Length);

		haddr=req.Haddr+(2**hsize);

//hlength is the length of the no. of transfers
for (int i=1; i<= Length; i++)
			begin 
			if(haddr>=Boundry_addr)
					haddr=Starting_addr;
			start_item(req);
			assert(req.randomize() with {Htrans == 2'b11;
										Hsize == hsize;
										Hwrite == hwrite;
										Hburst == hburst; 
										Haddr == haddr ;});
			finish_item(req);
			haddr=req.Haddr+(2**hsize);

		    end
			end
endtask
endclass
