`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/15 18:01:42
// Design Name: 
// Module Name: top_module
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


module top_module(
	input wire floor1_btn,				//电梯内的楼层按钮-1楼
	input wire floor2_btn,				//电梯内的楼层按钮-2楼
	input wire floor3_btn,				//电梯内的楼层按钮-3楼
	input wire floor4_btn,				//电梯内的楼层按钮-4楼
	
	output wire floor1_led,				//楼层1的按钮对应的LED灯
	output wire floor2_led,				//楼层2的按钮对应的LED灯
	output wire floor3_led,				//楼层3的按钮对应的LED灯
	output wire floor4_led,				//楼层4的按钮对应的LED灯
	output wire door_open_led,			//开门对应的LED灯
	output wire door_close_led,			//关门对应的LED灯
	
	input wire door_open_sw,			//开门对应的switch
	input wire door_close_sw,			//关门对应的switch
	input clk,							//时钟
	
	output wire[10:0] display_floor,	//显示楼层
	
	input wire call_btn,				//呼叫按钮
	
	output wire call_led1,				//呼叫LED1
	output wire call_led2,				//呼叫LED2
	
	input wire out1_up_sw,				//电梯外的1楼↑sw
	input wire out2_up_sw,				//电梯外的2楼↑sw
	input wire out2_down_sw,			//电梯外的2楼↓sw
	input wire out3_up_sw,				//电梯外的3楼↑sw
	input wire out3_down_sw,			//电梯外的3楼↓sw
	input wire out4_down_sw,			//电梯外的4楼↓sw
	
	output wire out1_up_led,			//电梯外的1楼↑led
	output wire out2_up_led,			//电梯外的2楼↑led
	output wire out2_down_led,			//电梯外的2楼↓led
	output wire out3_up_led,			//电梯外的3楼↑led
	output wire out3_down_led,			//电梯外的3楼↓led
	output wire out4_down_led,			//电梯外的4楼↓led
	
	input wire led_out_test_sw			//测试用的，打开会把那六个LED熄灭（取消对应需求）
    );
	
	wire press1, press2, press3, press4;	//四个楼层按钮按下的标志
	
	wire press_call;		//呼叫按钮按下的标志
	
	wire call_state;		//呼叫状态，0为未呼叫，1为正在呼叫
	
	//电梯外一共六个按钮：1楼上，2楼上下，3楼上下，4楼下，等于0代表无请求（按下或取消）
	wire press_out1_up, press_out2_up, press_out2_down, press_out3_up, press_out3_down, press_out4_down;
	
	wire [1:0] now_floor;	//当前楼层：1楼,对应为00,以此类推
	
	wire [4:0] state;	//状态机状态
	
	wire [1:0] direction;	//电梯当前运行方向，00为停，01为上，10为下
	
	wire [1:0] pointer;	//电梯显示的↑或↓或不显示,00为不显示，01为↑，10为↓
	
	wire door_state;	//开关门状态，关门0  开门1,这是真正的电梯门状态
	
	wire [3:0] request_total;	//每层楼是否有请求 从左到右分别1234楼，值为1代表有请求

	wire press_in1, press_in2, press_in3, press_in4;	//电梯内的4个楼层按钮按下或取消
	
	//模块例化
	
	//按钮消抖模块
	btn_debounce u_btn_debounce1(
		.clk	(clk),
		.btn	(floor1_btn),
		.press	(press1)
	);
	btn_debounce u_btn_debounce2(
		.clk	(clk),
		.btn	(floor2_btn),
		.press	(press2)
	);
	btn_debounce u_btn_debounce3(
		.clk	(clk),
		.btn	(floor3_btn),
		.press	(press3)
	);
	btn_debounce u_btn_debounce4(
		.clk	(clk),
		.btn	(floor4_btn),
		.press	(press4)
	);
	btn_debounce u_btn_debounce_call(
		.clk	(clk),
		.btn	(call_btn),
		.press	(press_call)
	);
	
	//状态机状态转换模块（上下楼控制模块）
	state u_state(
		.clk	(clk),
		.now_floor		(now_floor),
		.state			(state),
		.direction		(direction),
		.door_state		(door_state),
		.pointer		(pointer),
		.press_out1_up		(press_out1_up),
		.press_out2_up		(press_out2_up),
		.press_out2_down	(press_out2_down),
		.press_out3_up		(press_out3_up),
		.press_out3_down	(press_out3_down),
		.press_out4_down	(press_out4_down),
		.request_total		(request_total),
		.press_in1	(press_in1),
		.press_in2	(press_in2),
		.press_in3	(press_in3),
		.press_in4	(press_in4)
	);
	
	//led模块
	led u_led(
		.clk	(clk),
		.press_in1	(press_in1),
		.press_in2	(press_in2),
		.press_in3	(press_in3),
		.press_in4	(press_in4),
		.led1	(floor1_led),
		.led2	(floor2_led),
		.led3	(floor3_led),
		.led4	(floor4_led),
		.state	(state),
		.door_open_sw	(door_open_sw),
		.door_close_sw	(door_close_sw),
		.door_open_led	(door_open_led),
		.door_close_led	(door_close_led),
		.call_state		(call_state),
		.call_led1		(call_led1),
		.call_led2		(call_led2),
		.press_out1_up		(press_out1_up),
		.press_out2_up		(press_out2_up),
		.press_out2_down	(press_out2_down),
		.press_out3_up		(press_out3_up),
		.press_out3_down	(press_out3_down),
		.press_out4_down	(press_out4_down),
		.out1_up_led		(out1_up_led),
		.out2_up_led		(out2_up_led),
		.out2_down_led		(out2_down_led),
		.out3_up_led		(out3_up_led),
		.out3_down_led		(out3_down_led),
		.out4_down_led		(out4_down_led)
	);
	
	//数码管显示模块
	display_seg u_display_seg(
		.clk	(clk),
		.display_floor	(display_floor),
		.now_floor		(now_floor),
		.direction		(direction),
		.door_state		(door_state),
		.pointer		(pointer)
	);
	
	//开关门控制模块
	door u_door(
		.clk	(clk),
		.door_state	(door_state),
		.direction	(direction),
		.state		(state),
		.door_open_sw	(door_open_sw),
		.door_close_sw	(door_close_sw)
	);
	
	//呼叫模块
	call u_call(
		.clk	(clk),
		.call_state	(call_state),
		.press_call	(press_call)
	);
	
	//电梯内的按钮响应模块
	in_btn u_in_btn(
		.clk	(clk),
		.press1	(press1),
		.press2 (press2),
		.press3 (press3),
		.press4 (press4),
		.press_in1	(press_in1),
		.press_in2	(press_in2),
		.press_in3	(press_in3),
		.press_in4	(press_in4),
		.state		(state)
	);
	
	//按钮模拟模块 每层楼的电梯sw模块（使用sw模拟上下楼按钮）
	out_btn u_out_btn(
		.clk	(clk),
		.press_out1_up		(press_out1_up),
		.press_out2_up		(press_out2_up),
		.press_out2_down	(press_out2_down),
		.press_out3_up		(press_out3_up),
		.press_out3_down	(press_out3_down),
		.press_out4_down	(press_out4_down),
		.out1_up_sw			(out1_up_sw),
		.out2_up_sw			(out2_up_sw),
		.out2_down_sw		(out2_down_sw),
		.out3_up_sw			(out3_up_sw),
		.out3_down_sw		(out3_down_sw),
		.out4_down_sw		(out4_down_sw),
		.led_out_test_sw	(led_out_test_sw),
		.state				(state),
		.pointer			(pointer),
		.request_total		(request_total),
		.press_in1			(press_in1),
		.press_in2			(press_in2),
		.press_in3			(press_in3),
		.press_in4			(press_in4)
	);
	
	
	
	
endmodule
