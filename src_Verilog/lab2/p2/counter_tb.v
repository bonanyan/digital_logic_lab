`timescale 1ns/1ns
`include "counter.v"

module counter_tb;

reg en,clk,rst;
wire [7:0] out;

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $monitor("time=%0t, en=%0b, rst=%0b, out=%0d", $time, en, rst, out);
    $dumpfile("wave.vcd");
    $dumpvars(0);
end

initial begin
    en=1;
    rst = 1;
    #10 rst = 0;
    #5000 $finish;
end

counter dut(
.out(out)     ,  // Output of the counter
.enable(en)  ,  // enable for counter
.clk(clk)     ,  // clock Input
.reset(rst)      // reset Input
);

endmodule