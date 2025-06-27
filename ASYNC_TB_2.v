
`timescale 1ns/1ps
module ASYNC_2_TB;

parameter DATA_WIDTH_TB = 8;
parameter DATA_DEP_TB = 8;
parameter W_CLK_Per = 10;
parameter R_CLK_Per = 25.0;

reg W_CLK_TB;



reg W_RST_TB;
reg W_INC_TB;
reg R_CLK_TB;
reg R_RST_TB;
reg R_INC_TB;
reg [DATA_WIDTH_TB - 1:0] WR_DATA_TB;
wire FULL_TB;
wire [DATA_WIDTH_TB - 1:0] RD_DATA_TB;
wire EMPTY_TB;


ASYNC_FIFO DUT (
.W_CLK(W_CLK_TB),
.W_RST(W_RST_TB),
.W_INC(W_INC_TB),
.R_CLK(R_CLK_TB),
.R_RST(R_RST_TB),
.R_INC(R_INC_TB),
.WR_DATA(WR_DATA_TB),
.FULL(FULL_TB),
.RD_DATA(RD_DATA_TB),
.EMPTY(EMPTY_TB)
);

always #(W_CLK_Per/2) W_CLK_TB = ~W_CLK_TB;
always #(R_CLK_Per/2) R_CLK_TB = ~R_CLK_TB;

initial
begin
$dumpfile("ASYNC_FIFO.vcd");
$dumpvars;

initialize;
reset;

write_data(8'hB9);
read_data(8'hB9);

write_data(8'h64);
read_data(8'h64);

write_data(8'h3E);
read_data(8'h3E);

write_data(8'h2A);
read_data(8'h2A);

write_data(8'h1D);
read_data(8'h1D);

write_data(8'h48);
read_data(8'h48);

write_data(8'hBF);
read_data(8'hBF);

write_data(8'h5C);
read_data(8'h5C);

#(W_CLK_Per)
#(R_CLK_Per)

detect_full;

detect_empty;

#100 $stop;
end

task initialize;
begin
W_CLK_TB = 1'b0;
R_CLK_TB = 1'b0;
W_RST_TB = 1'b1;
R_RST_TB = 1'b1;
W_INC_TB = 1'b0;
R_INC_TB = 1'b0;
WR_DATA_TB = 'b0;
end
endtask

task reset;
begin
W_RST_TB = 1'b1;
R_RST_TB = 1'b1;
#(R_CLK_Per)
R_RST_TB = 1'b0;
#(R_CLK_Per)
R_RST_TB = 1'b1;
#(W_CLK_Per)
W_RST_TB = 1'b0;
#(W_CLK_Per)
W_RST_TB = 1'b1;
end
endtask

task write_data;
input [DATA_WIDTH_TB - 1:0] data;
begin
@(posedge W_CLK_TB)
if(!FULL_TB)
begin
WR_DATA_TB = data;
W_INC_TB = 1'b1;
@(posedge W_CLK_TB)
W_INC_TB = 1'b0;
$display("Data is being written: %h", data);
end
else
begin
$display("Unable to write the data: %h", data);
end
end
endtask

task read_data;
input [DATA_WIDTH_TB - 1:0] data;
begin
wait(!(EMPTY_TB))
if(!EMPTY_TB)
begin
R_INC_TB = 1'b1;
@(posedge R_CLK_TB)
R_INC_TB = 1'b0;
if(RD_DATA_TB == data)
begin
$display("Data: %h has been read successfully!", data);
end
else
begin
$display("Data: %h has NOT been read!", data);
end
end
else
begin
$display("No available data");
end
end
endtask

task detect_full;
integer num;
begin
if(!FULL_TB)
begin
for(num = 0; num < 8; num = num + 1)
begin
write_data(num);
end
end
@(posedge W_CLK_TB)
if(FULL_TB)
$display("FIFO became full after writing in all memory locations");
else
$display("FIFO is not full!");
end
endtask

task detect_empty;
integer num;
begin
if(!EMPTY_TB)
begin
for(num = 0; num < 7; num = num + 1)
begin
read_data(num);
@(posedge R_CLK_TB);
end
read_data(num);
end
@(posedge R_CLK_TB)
if(EMPTY_TB)
$display("FIFO became empty after reading all memory locations");
else
$display("FIFO is not empty!");
end
endtask

endmodule 
