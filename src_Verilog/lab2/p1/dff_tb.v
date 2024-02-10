`timescale 1ns/1ns
`include "dff.v"

module dff_tb;

reg d,clk,rst;
wire q1,q2,q3;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0);
    $monitor("time=%4t, d=%2b, clk=%2b, rst=%2b, q1=%2b, q2=%2b, q3=%2b",$time,d,clk,rst,q1,q2,q3);
end

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst = 0;
    #1 rst = 1;
    #10 rst = 0;
    #25 rst = 1;
    #1 rst = 0;
end

initial begin
    d = 0;
    #10 d = 1;
    #7 d = 0;
    #1 d = 1;
    #3 d = 0;
    #1 d = 1;
    #1 d = 0;
    #10 d = 1;
    #10 $finish;
end

dff_sync_reset dut1(
.data   (d)   ,// Data Input
.clk    (clk) ,// Clock Input
.reset  (rst) ,// Reset input
.q      (q1)    // Q output
);


dff_async_reset dut2(
.data   (d)   ,// Data Input
.clk    (clk) ,// Clock Input
.reset  (rst) ,// Reset input
.q      (q2)    // Q output
);

dlatch_reset dut3(
.data (d)   , // Data Input
.en (clk)     , // LatchInput
.reset (rst)  , // Reset input
.q (q3)        // Q output
);

endmodule