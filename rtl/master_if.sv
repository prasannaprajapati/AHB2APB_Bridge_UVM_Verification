interface master_if(input bit clk);

logic Hresetn;
logic Hreadyout;
logic Hreadyin;
logic Hwrite;
logic [1:0] Htrans;
logic [1:0] Hresp;
logic [3:0] Hsize;
logic [31:0] Hrdata;
logic [31:0] Haddr;
logic [31:0] Hwdata;

clocking drv_cb@(posedge clk);
default input #1 output #1;

input Hrdata,Hreadyout;
output Hwrite,Htrans,Hsize,Haddr,Hwdata,Hresetn,Hreadyin;

endclocking

clocking mon_cb@(posedge clk);

default input #1 output #1;

input Haddr;
input Htrans;
input Hsize;
input Hreadyin;
input Hreadyout;
input Hwrite;
input Hwdata;
input Hrdata;

endclocking 

modport MDRV_MP(clocking drv_cb);
modport MMON_MP(clocking mon_cb);

endinterface