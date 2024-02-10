# 实验7、Macro应用-存储器

## 教程
### *4、“下个周期取数”*

程序7:
```Verilog
`timescale 1ns/1ns
module test;

    reg set;
    reg [31:0] mem [0:20]; //word length is [31:0], we define 16 words(address 0~15)
    integer i;
    initial begin
        for(i=0;i<=20;i=i+1) begin
            mem[i]=0;
        end
        for(i=0;i<=20;i=i+1) begin
            $display("%h",mem[i]);
        end
    end

endmodule

module ram (
    input CLK,
    input [31:0] D,
    output reg [31:0] Q,
    input [31:0] A,
    input WE
);

parameter LEN = 1024;

reg [31:0] mem_core [0:LEN-1];

// initial reset
integer i;
initial begin
    for(i=0;i<=LEN-1;i=i+1) begin
        mem_core[i] = 0;
    end
end

always @(posedge CLK) begin
    if(WE) begin
        mem_core[A] <= D;
    end
    else begin
        Q <= mem_core[A];
    end
end
    
endmodule
```


>**[问题4]**
>程序7为一个随机访问存储器（RAM）的基本行为模型，实验运行testbench,实现把数据32'hDEADBEEF放到存储器地址address=4里，然后把它通过data_out端口读出来再写入address=6里。

提示：注意读数的一周期延迟。

## 练习
