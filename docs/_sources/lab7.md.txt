# 实验7、Macro应用-存储器

## 教程
我们介绍几种常见的块状存储器：
- register file(简称RegFile,一般翻译为寄存器堆或寄存器文件)
- random-access memory (RAM,一般翻译为随机访问存储器)
  - RAM with synchronous read (同步读出)
  - RAM with asynchronous read (异步读出)

### *1、RegFile*
一个dual-port(双读写口)的RegFile:
```Verilog
module RegisterFile #(
  parameter DataWidth  = 32,
  parameter NumRegs    = 32,
  parameter IndexWidth = $clog2(NumRegs)
) (
  input  clk,
  input  writeEn,
  input  [IndexWidth-1:0] writeAddr,
  input  [ DataWidth-1:0] writeData,
  input  [IndexWidth-1:0] readAddr1,
  input  [IndexWidth-1:0] readAddr2,
  output [ DataWidth-1:0] readData1,
  output [ DataWidth-1:0] readData2
);

  logic [DataWidth-1:0] regs[NumRegs];

  always_ff @(posedge clk) begin
    if (writeEn) begin
      regs[writeAddr] <= writeData;
    end
  end

  assign readData1 = regs[readAddr1];
  assign readData2 = regs[readAddr2];

endmodule
```
寄存器文件一般就是用DFF直接堆成的，将寄存器们堆成像文件一样，可同时读写（读是Q端读、写是D端写）。上面的32bit的寄存器文件，就是常见的32位CPU中数据通路中用到的片上32位寄存器文件。但是，我们平常用到的主存可不一样，主存一般来说是RAM（见下方）。

### *2、RAM with sync read*
一般的RAM都是通过全定制芯片设计流程设计的，这里我们给出的只是**behavioral model**，也就是“行为模型”（端口、行为和正常的一模一样，但它只是基于Verilog的行为描述，一般来说不是由DFF而是由RAM bitcell组成）：
```Verilog
module ram_sr # 
(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
(
clk         , // Clock Input
address     , // Address Input
d           , // Data input
q           , // Data output
cs          , // Chip Select
web         , // Write Enable/Read Enable, low active
oe            // Output Enable
); 

localparam RAM_DEPTH = 1 << ADDR_WIDTH;

//--------------Input Ports----------------------- 
input clk;
input [ADDR_WIDTH-1:0] address;
input cs;
input web;
input oe; 

//--------------Inout Ports----------------------- 
input [DATA_WIDTH-1:0]  d;
output [DATA_WIDTH-1:0]  q;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

//--------------Core Function--------------------- 
// Tri-State Buffer control 
// output : When web = 1, oe = 1, cs = 1
assign q = (cs && oe && web) ? data_out : 'bz; 

// Memory Write Block 
// Write Operation : When web = 0, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && ~web ) begin
       mem[address] = d;
   end
end

// Memory Read Block 
// Read Operation : When web = 1, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
    if (cs && web && oe) begin
         data_out = mem[address];
    end
end

endmodule
```

### *3、RAM with async read*
一般的RAM都是手动做的，这里我们给出的只是**behavioral model**，也就是“行为模型”（端口、行为和正常的一模一样，但它只是基于Verilog的行为描述）：
```Verilog
module ram_ar # 
(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)
(
clk         , // Clock Input
address     , // Address Input
d           , // Data input
q           , // Data output
cs          , // Chip Select
web         , // Write Enable/Read Enable, low active
oe            // Output Enable
); 

localparam RAM_DEPTH = 1 << ADDR_WIDTH;

//--------------Input Ports----------------------- 
input clk;
input [ADDR_WIDTH-1:0] address;
input cs;
input web;
input oe; 

//--------------Inout Ports----------------------- 
input [DATA_WIDTH-1:0]  d;
output [DATA_WIDTH-1:0]  q;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

//--------------Core Function--------------------- 
// Tri-State Buffer control 
// output : When web = 1, oe = 1, cs = 1
assign q = (cs && oe && web) ? data_out : 'bz; 

// Memory Write Block 
// Write Operation : When web = 0, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && ~web ) begin
       mem[address] = d;
   end
end

// Memory Read Block 
// Read Operation : When web = 1, oe = 1, cs = 1
always @ (address or cs or web or oe)
begin : MEM_READ
    if (cs && web && oe) begin
         data_out = mem[address];
    end
end

endmodule
```

### *4、Testbench*
我们用同一套testbench测试上述两种RAM：
```Verilog
`timescale 1ns/1ns
module tb;

reg clk;
reg [7:0] addr;
reg [15:0] d;
reg cs;
reg web;
reg oe;
wire [15:0] q;
integer i;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0);
    $monitor("time=%4t, clk=%1b, web=%1b, d=%2h, q=%2h",$time,clk,web,d,q);
end

initial
begin
    clk = 0;
    forever #1 clk = ~clk;
end

initial
begin
    cs = 1;
    oe = 1;
    // test write
    for(i=0;i<(1<<4);i=i+1) begin
        #2 web=0;
        addr = i;
        d = i;
    end
    // test read
    for(i=0;i<(1<<4);i=i+1) begin
        #2 web=1;
        addr = i;
        d = $random;
    end

    #10 $finish;
end

//这里需要改成想要实例化的ram_ar或者ram_sr
ram #(.DATA_WIDTH(16), .ADDR_WIDTH(8)) u0 (
    .clk( clk )
    ,.address ( addr )
    ,.d  ( d )
    ,.q ( q )
    ,.cs ( cs )
    ,.web ( web )
    ,.oe ( oe )
); 

endmodule
```

然后在terminal里用iverilog+gtkwave来验证读、写功能：
```bash
iverilog -o wave a.v
vvp -n wave
gtkwave wave.vcd
```

---
## 练习
### *基础概念分辨*

```{note}
**[问题1]** 请设计一个testbench测试一下上述regfil的设计，请提交波形图并用箭头标出相关的功能；另外，请总结regfile与RAM的主要区别。
````
```{note}
**[问题2]** 请结合波形图，说明async read与sync read的区别。
```

### *基于RAM的FIFO*
FIFO是first in first out的首字母缩写，

```{note}
**[问题3]** 请基于RAM with sync read（实例化）包装出一个新的FIFO memory出来,并设计testbench测试一下，提交波形图截图并标记说明其功能。
```
FIFO是一种这样的功能模块：
![FIFO](_static/assets/fifo.png)

请使用下方module商品定义：
````Verilog
module fifo (
input   clk             , // Clock input
input   rstb            , // Reset all function, low active
input   rd              , // Pop one datum out
input   wr              , // Push one datum in
input   [15:0] data_in  , // Data input port
output  [15:0] data_out , // Data output port
output  empty           , // FIFO empty indicator, high active
output  full              // FIFO full indicator, low active
);  
````




