# 实验1、组合逻辑

## 教程

Verilog HDL拥有非常自由的语法，条条大路通罗马。

### *1、2-4译码器的三种写法*
```Verilog
module decoder2_4 (
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
```

```Verilog
module decoder2_4 (
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
```

```Verilog
module decoder2_4 (
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
```

### *2、Testbench验证*

用iverilog快速验证一下：
```bash
cd [到当前存放dff.v和dff_tb.v的文件夹]
iverilog -o wave dff_tb.v
vvp -n wave
```
如果到此运行顺利的话，当前文件夹会生成一个新的wave.vcd（正如dff_tb.v里面写的$dumpfile("wave.vcd")所写)。然后用gtkwave打开这个波形：
```bash
gtkwave wave.vcd
```
就可以得到。你之前预测的结果是正确的么？

由于我们的testbench.v里写了$monitor(每当里面涉及的variable)

### *3、2-4译码器的FPGA实现验证*
请根据以下教程，将上述testbench和三种decoder的设计置于FPGA上实验，输入用按键。

参考：
- [vivado下LED流水灯实验及仿真](_static/assets/01.vivado下LED流水灯实验及仿真.pdf)
- [vivado下按键实验](_static/assets/02.vivado下按键实验.pdf)
- [vivado下PLL实验](_static/assets/03.vivado下PLL实验.pdf)

## 练习

### *1、奇偶校验码 (parity check code)设计*

奇偶校验码是最简单的查错编码 (error detection code)，其行为是输入m位码字，如果有奇数个1则编码器输出1；如果有偶数个1则编码输出为0。

```{note}
**[问题1]** 用Verilog HDL设计一个输入有16位的奇偶校验码，并写testbench验证。
```


- 提示：这是对于输入位的什么按位逻辑操作？一种逻辑操作即可搞定。

### *2、温度计码 (thermometer code)设计*

温度计码是模数转换器ADC中常用的编码，一个温度计码解码器的例子为：

|    输入 | 输出 |
| ------: | ---: |
| 0000000 |  000 |
| 0000001 |  001 |
| 0000011 |  010 |
| 0000111 |  011 |
| 0001111 |  100 |
| 0011111 |  101 |
| 0111111 |  110 |
| 1111111 |  111 |

它就是长得像温度计。

```{note}
**[问题2]** 用Verilog HDL设计一个输入是1023位的温度计解码器，并写testbench验证。
```
- 提示：Verilog HDL支持for loop, [Verilog-2005 standard manual](http://staff.ustc.edu.cn/~songch/download/IEEE.1364-2005.pdf)。
