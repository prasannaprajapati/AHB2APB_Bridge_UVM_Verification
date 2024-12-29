interface slave_if(input bit clk);

logic Penable;
logic Pwrite;
logic [31:0] Prdata;
logic [31:0] Paddr;
logic [3:0] Pselx;
logic [31:0] Pwdata;

clocking drv_cb@(posedge clk);
default input #1 output #1;

output Prdata;
input Penable;
input Pwrite;
input Pselx;

endclocking

clocking mon_cb@(posedge clk);

default input #1 output #1;

input Prdata;
input Pwdata;
input Penable;
input Pwrite;
input Pselx;
input Paddr;

endclocking 

modport MDRV_MP(clocking drv_cb);
modport MMON_MP(clocking mon_cb);

endinterface