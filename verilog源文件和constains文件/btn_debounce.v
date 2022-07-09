`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/15 21:25:21
// Design Name: 
// Module Name: btn_debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module btn_debounce(
	input wire clk,		//时钟
	input wire btn,		//按下的按钮
	output reg press	//按钮按下的标志输出
    );
	
	//全局参数定义
	parameter DELAY_TIME = 1000000;	//延时20ms
	
	//信号定义
	reg btn_r0;		//同步 当前时钟周期输入状态
	reg btn_r1;		//打拍 前一个时钟周期输入的状态
	wire btn_nedge;	//下降沿
	
	reg [19:0] delay_cnt;	//计数20ms
	reg delay_flag;			//按下的下降沿标志
	
	//同步计数实现
	always @(posedge clk)
	begin
		btn_r0 <= btn;		//不断获取新值
		btn_r1 <= btn_r0;	//保留原本的值 两个信号之间有一个时钟周期差
	end
	
	assign btn_nedge = ~btn_r0 & btn_r1;	//检测下降沿
	//assign btn_pedge = btn_r0 & ~btn_r1;	//检测上升沿
	
	//delay_flag
	always @(posedge clk)
	begin
		if(btn_nedge)
		begin	//下降沿出现后设置按下标志位为1
			delay_flag <= 1'b1;
		end
		if(delay_cnt == DELAY_TIME - 1)
		begin	//表示按键按下结束 以备下次按键 
			delay_flag <= 1'b0;
		end
	end
	
	//delay_cnt
	always @(posedge clk)
	begin
		if(delay_flag)
		begin
			if(delay_cnt == DELAY_TIME - 1)
			begin	//如果到了20ms则清零
				delay_cnt <= 0;
			end
			else	
			begin	//没到20ms
				delay_cnt <= delay_cnt + 1;
			end
		end	
	end
	

	
	//press
	always @(posedge clk)
	begin
		if(delay_cnt == DELAY_TIME - 1)
		begin	//20ms后获取当前按压标志
			press <= ~btn_r0;
		end
		else
		begin	//没有到20ms
			press <= 1'b0;
		end
	end
	
	
endmodule
