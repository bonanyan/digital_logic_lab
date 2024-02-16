
module gemm #(
    parameter N = 3,
    parameter WIDTH = 16
) (
    clk,
    en,
);
    

    // generate systolic array
    wire [WIDTH-1:0] P [N:0] [N:0];
    wire [WIDTH-1:0] Q [N:0] [N:0];
    genvar i,j;
    generate
        for (i = 0; i < N ; i = i + 1) begin : genvar_loop
            for (j = 0; j < N; j = j + 1) begin : genvar_loop2
                systolicCell #(.WIDTH(WIDTH)) uCell  
                                (.M (P[i][j])
                                ,.N (Q[i][j])
                                ,.P (P[i][j+1])
                                ,.Q (Q[i][j+1])
                                );
            end
        end
    endgenerate

endmodule

module systolicCell #(
    parameter WIDTH = 16
) (
    M,
    N,
    P,
    Q
);
    input [WIDTH-1:0] M;
    input [WIDTH-1:0] N;
    output reg [WIDTH-1:0] P;
    output reg [WIDTH-1:0] Q;
    reg [WIDTH-1:0] R;

    wire [2*WIDTH-1:0] R_next;

    always @(posedge clk) begin
        P <= M;
        Q <= N;
        R <= R_next;
    end

    MAC u_mac(
        .a(M),
        .b(N),
        .c(R_next),
        .d(R)
    );

endmodule

module MAC ( //multiply-accumulate
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output [15:0] d
);

    assign d = a * b + c;
    
endmodule