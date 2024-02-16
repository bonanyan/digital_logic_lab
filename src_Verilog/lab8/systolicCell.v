
module systolicCell #(
    WIDTH = 16
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