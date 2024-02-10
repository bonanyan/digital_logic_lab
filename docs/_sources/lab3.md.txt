# 实验3、那些Verilog里令人费解的概念

## 教程

这次实验没有教程，直接练习起来吧！

---

## 练习

### *1、阻塞与非阻塞赋值*
程序1:
```Verilog
module test;

reg en;
reg [7:0] a,b,i;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a = 0;
    b = 0;
    i = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a, b, i);
    
end

always @(posedge clk) begin
if(i<=8'd16) begin
//与程序1唯一的不同：换成了阻塞赋值
    i <= i+1; 
    a <= i;
    b <= a;
end
end

endmodule
```

程序2:
```Verilog
module test;

reg en;
reg [7:0] a,b,i;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a = 0;
    b = 0;
    i = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a, b, i);
    
end

always @(posedge clk) begin
if(i<=8'd16) begin
    i<=i+1;
    a<=i;
    b<=a;
end
end

endmodule
```
>**[问题1]**
>写出两个段程序的运行结果，运行Verilog仿真验证，并加以解释为什么会这样。

### *2、一个变量不能在两个always块里赋值*

程序3:
```Verilog
module test;

reg [7:0] counter;
reg rst;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    rst = 0;
    #10 rst = 1
    #10 rst = 0;
    #100 $finish;
end

initial begin
    $monit(counter);
end

always @(posedge rst) begin
    counter <= 0;
end

always @(posedge clk) begin
    counter <= counter + 1;
end

endmodule
```

>**[问题2]**
>2.1 程序3运行起来会出什么错？请实验验证，解释为什么会这样。
>2.2 要想实现程序3的功能，请把程序改对。

### *3、“Verilog”是一门并行执行的语言？*

程序4:
```Verilog
module test;

reg en;
reg [7:0] a,b,i;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a = 0;
    b = 0;
    i = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a, b, i);
    
end

always @(posedge clk) begin
if(i<=8'd16) begin
    i = i+1;
    b = a+1;
    a = i;
end
end

endmodule
```

程序5:
```Verilog
module test;

reg en;
reg [7:0] a,b,i;
reg clk;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    a = 0;
    b = 0;
    i = 0;
    en = 1;
    #100 $finish;
end

initial begin
    $monitor("a=%d, b=%d, i=%d", a, b, i);
    
end

always @(posedge clk) begin
if(i<=8'd16) begin
    i = i+1;
    a = i;
    b = a+1;
end
end

endmodule
```

程序6
```Verilog
module test;

reg [3:0] counter;
reg rst;
reg clk;
reg [1:0] led;

initial clk = 0;
always #1 clk = ~clk;

initial begin
    rst = 0;
    led = 2'd0;
    #10 rst = 1
    #10 rst = 0;
    #100 $finish;
end

initial begin
    $monit(counter);
end

always @(posedge clk) begin
    counter <= counter + 1 + led;
end

assign led = counter[1]+1;

endmodule
```

>**[问题3]**
>对比程序4与程序5，实验运行一下展示区别,并解释为什么会这样。
>程序6中，请手画波形图，注意led信号是什么时候发生变化。

提示：
1. "begin...end"里的是按顺序执行，除非是fork语句
2. 不同的always块、assign语句之间是并行运行，确切地说不是并行执行，而它们只是电路之前的连接。


## 总结
Verilog里看起来很费解的上面这些概念，其实本质是在用DFF搭建电路，Verilog HDL如其名只是在描述DFF的行为。