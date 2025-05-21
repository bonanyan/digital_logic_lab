`timescale 1ns/1ns
`include "../example/cnt.v"


module tb;

    parameter CLK_PERIOD = 10; 
    
    // 
    reg up_down, clk, reset;
    wire [7:0] out;
    
    // 
    up_down_counter uut (
        .out(out),
        .up_down(up_down),
        .clk(clk),
        .reset(reset)
    );
    
    // 
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // 
    initial begin
        // 
        up_down = 1'b0;
        reset = 1'b1;
        #20;
        
        // 
        reset = 1'b0;
        up_down = 1'b1;
        #200;
        
        // 
        up_down = 1'b0;
        #200;
        
        // 
        reset = 1'b1;
        #20;
        reset = 1'b0;
        #200;
        
        //  - 
        reset = 1'b1;
        #20;
        reset = 1'b0;
        up_down = 1'b1;
        #40;
        
        //  - 
        reset = 1'b1;
        #20;
        reset = 1'b0;
        up_down = 1'b0;
        #40;
        
        // 
        $finish;
    end
    
    // 
    initial begin
        $monitor("Time: %0t, Reset: %b, Up/Down: %b, Out: %h", 
                 $time, reset, up_down, out);
    end

endmodule    
