module DF_SYNC #(parameter NUM_STAGES = 2, ADD_WIDTH = 4)(
input wire [ADD_WIDTH - 1:0] in_ptr,
input wire CLK, RST,
output reg [ADD_WIDTH - 1:0] out_ptr
);

reg  [NUM_STAGES - 1:0] SYNC_reg [ADD_WIDTH - 1:0];
integer j;

always@(posedge CLK or negedge RST)
begin
if(!RST)
begin
for(j = 0; j < ADD_WIDTH; j = j + 1)
SYNC_reg[j] <= 'b0;
end
else 
begin
for(j = 0; j < ADD_WIDTH; j = j + 1)
SYNC_reg[j] <= {SYNC_reg[j][NUM_STAGES - 2:0], in_ptr[j]};
end
end

always@(*)
begin
for(j = 0; j < ADD_WIDTH; j = j + 1)
out_ptr[j] = SYNC_reg[j][NUM_STAGES - 1];
end

endmodule
