# 实验4、有限状态机

## 教程：有限状态机

程序7:
```Verilog
module PasscodeDetector(
    input clk, data_in, rstb,
    output reg data_out
)

reg [1:0] state;
parameter STAT_IDLE = 0,
            STATE_R1 = 1,
            STATE_R2 = 2,
            STATE_R3 = 3;

always @(state) begin
    if(state==STATE_R3)
        data_out <= 1;
    else
        data_out <= 0;
end

always @(posedge clk or negedge rstb) begin
    if(!rstb)
        state <= STAT_IDLE;
    else
        case(state)
            STAT_IDLE:
                if(data_in==1)
                    state <= STATE_R1;
            STATE_R1:
                if(data_in==1)
                    state <= STATE_R2;
                else
                    state <= STAT_IDLE;
            STATE_R2:
                if(data_in==0)
                    state <= STATE_R3;
                else
                    state <= STATE_IDLE;
            default://STATE_R3
                if(data_in==1)
                        state <= STATE_R1;
                    else
                        state <= STATE_IDLE;
        endcase
end

endmodule
```

---

## 练习

### *1、为*



>**[问题1]**
>用Verilog HDL设计交通灯控制器，并写testbench验证。

>**[问题2]**
>现在我们扩展探究上面的控制器的管理效果。请设计一款模拟器，在不同时间随机生成车辆，模拟测试上述。求平均等待车辆数。