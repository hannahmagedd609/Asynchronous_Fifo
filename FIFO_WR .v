module FIFO_WR #(parameter ADD_WIDTH = 4)(
input wire winc,
input wire [ADD_WIDTH - 1:0] wq2_rptr,
input wire W_CLK, W_RST,
output wire wfull,
output reg [ADD_WIDTH - 2:0] waddr,
output reg [ADD_WIDTH - 1:0] wptr
);

integer k;
wire winc_pulse;
reg winc_flop;
reg [ADD_WIDTH - 1:0] wptr_reg;

assign winc_pulse = !winc_flop && winc;

always@(posedge W_CLK or negedge W_RST)
begin
if(!W_RST)
winc_flop <= 0;
else 
winc_flop <= winc;
end

always @(*) 
begin
wptr[ADD_WIDTH - 1] = wptr_reg[ADD_WIDTH - 1]; 
for (k = ADD_WIDTH - 2; k >= 0; k = k - 1) 
begin
wptr[k] = wptr_reg[k + 1] ^ wptr_reg[k]; 
end
end
  
assign wfull = ((wptr[3] != wq2_rptr[3]) && (wptr[2] != wq2_rptr[2]) && (wptr[1:0] == wq2_rptr[1:0]))?1:0;

always@(posedge W_CLK or negedge W_RST)
begin
if(!W_RST)
begin
waddr <= 'b0;
wptr_reg <= 'b0;
end
else
begin 
if(winc_pulse && !wfull)
begin
waddr <= waddr + 'b1;
wptr_reg <= wptr_reg + 'b1;
end
if(waddr == 'b111)
begin
waddr <= 'b0;
end
if(wptr_reg == 'b1111)
begin
wptr_reg <= 'b0;
end
end
end

endmodule 