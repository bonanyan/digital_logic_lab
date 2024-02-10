module decoder2_4_1 (
decode_in,
decode_out
);
input [1:0] decode_in;
output [3:0] decode_out;

//写出逻辑表达式，然后像卡诺图一样写出来
assign decode_out[0] = ~decode_in[1] & ~decode_in[0];
assign decode_out[1] = ~decode_in[1] & decode_in[0];
assign decode_out[2] = decode_in[1] & ~decode_in[0];
assign decode_out[3] = decode_in[1] & decode_in[0];

endmodule

module decoder2_4_2 (
decode_in,
decode_out
);
input [1:0] decode_in;
output [3:0] decode_out;

//用?:语句写
assign decode_out = decode_in[0] ? 
    (decode_in[1]? 4'b1000: 4'b0010):
    (decode_in[1]? 4'b0100: 4'b0001);

endmodule

module decoder2_4_3 (
decode_in,
decode_out
);
input [1:0] decode_in;
output reg [3:0] decode_out;

always @(*) begin //组合逻辑的always块写法，这样就可以用if-else或者case语句啦
    if (decode_in == 2'b00)
        decode_out = 4'b0001;
    else if (decode_in == 2'b01)
        decode_out = 4'b0010;
    else if (decode_in == 2'b10)
        decode_out = 4'b0100;
    else if (decode_in == 2'b11)
        decode_out = 4'b1000;
end

endmodule