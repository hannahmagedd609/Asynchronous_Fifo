
module ASYNC_FIFO #(parameter DATA_WIDTH = 8, ADD_WIDTH = 4)(
input wire W_CLK,
input wire W_RST,
input wire W_INC,
input wire R_CLK,
input wire R_RST,
input wire R_INC,
input wire [DATA_WIDTH - 1:0] WR_DATA,
output wire FULL,
output wire [DATA_WIDTH - 1:0] RD_DATA,
output wire EMPTY
);

wire [ADD_WIDTH - 1:0] wptr, rptr, wq2_rptr, rq2_wptr;
wire [ADD_WIDTH - 2:0]  waddr, raddr;

FIFO_MEM_CTRL U0(
.w_data(WR_DATA),
.W_CLK(W_CLK),
.W_RST(W_RST),
.w_addr(waddr),
.r_addr(raddr),
.winc(W_INC),
.wfull(FULL),
.r_data(RD_DATA)
);

DF_SYNC U1(
.in_ptr(wptr),
.CLK(R_CLK),
.RST(R_RST),
.out_ptr(rq2_wptr)
);

DF_SYNC U2(
.in_ptr(rptr),
.CLK(W_CLK),
.RST(W_RST),
.out_ptr(wq2_rptr)
);

FIFO_WR U3(
.winc(W_INC),
.wq2_rptr(wq2_rptr),
.W_CLK(W_CLK), 
.W_RST(W_RST),
.wfull(FULL),
.waddr(waddr),
.wptr(wptr)
);

FIFO_RD U4(
.rinc(R_INC),
.rq2_wptr(rq2_wptr),
.R_CLK(R_CLK),
.R_RST(R_RST),
.rempty(EMPTY),
.raddr(raddr), 
.rptr(rptr)
);



endmodule 

