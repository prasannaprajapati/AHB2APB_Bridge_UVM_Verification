
//`include "master_if.sv"
//`include "master_if.sv"

import bridge_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	module top;

	//importing packages
	
	bit clk= 1'b0;

	// clk generation
	initial
	begin
		forever #5 clk = ~clk;
	end

	// interface instantiation	
  master_if h_if(clk);
  slave_if p_if(clk);

	 rtl_top DUT(
            .Hclk(clk),
            .Hresetn(h_if.Hresetn),
            .Htrans(h_if.Htrans),
            .Hsize(h_if.Hsize),
            .Hreadyin(h_if.Hreadyin),
            .Hwdata(h_if.Hwdata),
            .Haddr(h_if.Haddr),
            .Hwrite(h_if.Hwrite),
            .Hrdata(h_if.Hrdata),
            .Hresp(h_if.Hresp),
            .Hreadyout(h_if.Hreadyout),
            .Pselx(p_if.Pselx),
            .Pwrite(p_if.Pwrite),
            .Penable(p_if.Penable),
	    .Prdata(p_if.Prdata),
            .Paddr(p_if.Paddr),
	    .Pwdata(p_if.Pwdata)
            ) ;


/*property stable;
  @(posedge clock) disable iff(!master_if.Hresetn)
  (master_if.Hreadyout==0)|=>($stable(master_if.Haddr)&&$stable(master_if.Hwrite)&&$stable(master_if.Htrans)&&$stable(master_if.Hsize));
endproperty
assert property(stable);

property addr;
  @(posedge clock) disable iff(!master_if.Hresetn)
  (master_if.Hreadyout && slave_if.Pselx)|-> ((master_if.Hwrite==slave_if.Pwrite)&&(master_if.Haddr==slave_if.Paddr));
endproperty
assert property(addr);

assert property(stable)
$display("Property STABLE pass");
else 
$error("Error: Property STABLE fails");
assert property(addr)
$display("Property addr pass");
else 
$error("Error: Property addr fails");*/

  initial 
    begin
      //set config db vif
     uvm_config_db #(virtual master_if)::set(null,"*","h_if",h_if);
     uvm_config_db #(virtual slave_if)::set(null,"*","p_if",p_if);
     run_test("");
	end
	
	initial
     begin
		   `ifdef VCS
         		$fsdbDumpvars(0, top);
   		`endif
     end

endmodule


