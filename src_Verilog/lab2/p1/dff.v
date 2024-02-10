module dff_sync_reset (
data   , // Data Input
clk    , // Clock Input
reset  , // Reset input
q        // Q output
);

input data, clk, reset ; //Input Ports

output reg q;//Output Ports

always @ ( posedge clk)
if (reset) begin
  q <= 1'b0;
end  else begin
  q <= data;
end

endmodule

module dff_async_reset (
data   , // Data Input
clk    , // Clock Input
reset  , // Reset input
q        // Q output
);

input data, clk, reset ; //Input Ports

output reg q;//Output Ports

always @ ( posedge clk or posedge reset)
if (reset) begin
  q <= 1'b0;
end  else begin
  q <= data;
end

endmodule

module dlatch_reset (
data   , // Data Input
en     , // LatchInput
reset  , // Reset input
q        // Q output
);

input data, en, reset ; //Input Ports

output reg q; //Output Ports

always @ ( en or reset or data)
if (reset) begin
  q <= 1'b0;
end else if (en) begin
  q <= data;
end

endmodule