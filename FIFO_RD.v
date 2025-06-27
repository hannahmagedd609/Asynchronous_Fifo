module FIFO_RD #(parameter ADD_WIDTH = 4)(
input wire rinc,
input wire [ADD_WIDTH - 1:0] rq2_wptr,
input wire R_CLK, R_RST,
output wire rempty,
output reg [ADD_WIDTH - 2:0] raddr,
output reg [ADD_WIDTH - 1:0] rptr
);

integer k;
wire rinc_pulse;
reg rinc_flop;
reg [ADD_WIDTH - 1:0] rptr_reg;  

assign rinc_pulse = !rinc_flop && rinc;

always@(posedge R_CLK or negedge R_RST)
begin
if(!R_RST)
rinc_flop <= 0;
else 
rinc_flop <= rinc;
end

always @(*) 
begin
rptr[ADD_WIDTH - 1] = rptr_reg[ADD_WIDTH - 1]; 
for (k = ADD_WIDTH - 2; k >= 0; k = k - 1) 
begin
rptr[k] = rptr_reg[k + 1] ^ rptr_reg[k]; 
end
end
  
assign rempty = (rptr == rq2_wptr)?1:0;

always@(posedge R_CLK or negedge R_RST)
begin
if(!R_RST)
begin
raddr <= 'b0;
rptr_reg <= 'b0;
end
else
begin
if(rinc_pulse && !rempty)
begin
raddr <= raddr + 'b1;
rptr_reg <= rptr_reg + 'b1;
end
if(raddr == 'b111)
begin
raddr <= 'b0;
end
if(rptr_reg == 'b1111)
begin
rptr_reg <= 'b0;
end
end
end

endmodule 

