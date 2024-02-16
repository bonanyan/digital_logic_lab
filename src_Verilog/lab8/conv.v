
module convolution (
    ports
);
    
parameter MAC_NUM = 8;

always @(posedge clk) begin
    if(rst) begin
        
    end
    else begin
        a_reg <= data_out1;
        b_reg <= data_out2;
        c_reg <= data_out3;
    end
end

assign a = a_reg;
assign b = b_reg;
assign c = c_reg;

// d = a * b + c
mac u_mac(
.a(a),
.b(b),
.c(c),
.d(d)
);


endmodule