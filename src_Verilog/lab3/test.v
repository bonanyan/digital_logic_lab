module RAM (
clk         , // Clock Input
address     , // Address Input
data_in     , // Data in
data_out    , // Data out
we          , // Write Enable/Read Enable
); 

input  clk,we;
input [7:0] address;

input [15:0] data_in;

reg [15:0] data_out;
reg [15:0] mem [0:255];

always @ (posedge clk)
begin : MEM_WRITE
    if(we)
        mem[address] = data_in;
    else
        data_out = mem[address];
end

endmodule
