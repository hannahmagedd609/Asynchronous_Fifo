module FIFO_MEM_CTRL #(parameter DATA_WIDTH = 8, FIFO_DEP = 8)(
input wire [DATA_WIDTH - 1:0] w_data,
input wire W_CLK, W_RST,
input wire [2:0] w_addr, r_addr,
input wire winc,
input wire wfull,
output wire [DATA_WIDTH - 1:0] r_data
);

reg [DATA_WIDTH - 1:0] FIFO_Memory [FIFO_DEP - 1:0];
wire wclken;
integer k;

assign r_data = FIFO_Memory[r_addr];
assign wclken = winc && !wfull;

always@(posedge W_CLK or negedge W_RST)
begin
if(!W_RST)
begin
for(k = 0; k < FIFO_DEP; k = k + 1)
begin
FIFO_Memory[k] = 'b0;
end
end
else if(wclken)
begin
FIFO_Memory[w_addr] <= w_data;
end
end

endmodule

