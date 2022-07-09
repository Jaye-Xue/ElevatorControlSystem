`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/21 09:55:47
// Design Name: 
// Module Name: led
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


module led(
	input wire clk,
	input wire press_in1,
	input wire press_in2, 
	input wire press_in3, 
	input wire press_in4,
	output reg led1 = 0,
	output reg led2 = 0,
	output reg led3 = 0,
	output reg led4 = 0,
	input wire[4:0] state,
	input wire door_open_sw,
	input wire door_close_sw,
	output reg door_open_led = 0,
	output reg door_close_led = 0,
	input wire call_state,
	output reg call_led1 = 0,
	output reg call_led2 = 0,
	input wire press_out1_up,
	input wire press_out2_up,
	input wire press_out2_down,
	input wire press_out3_up,
	input wire press_out3_down,
	input wire press_out4_down,
	output reg out1_up_led = 0,
	output reg out2_up_led = 0,
	output reg out2_down_led = 0,
	output reg out3_up_led = 0,
	output reg out3_down_led = 0,
	output reg out4_down_led = 0
    );
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	parameter max_5HZ = 10000000;	//5HZ
	reg[30:0] n_5HZ;
	reg clk_5HZ;
	
	always @(posedge clk)
	begin
		if(press_out1_up == 1)
			out1_up_led <= 1;
		else
			out1_up_led <= 0;
		if(press_out2_up == 1)
			out2_up_led <= 1;
		else
			out2_up_led <= 0;
		if(press_out2_down == 1)
			out2_down_led <= 1;
		else
			out2_down_led <= 0;
		if(press_out3_up == 1)
			out3_up_led <= 1;
		else
			out3_up_led <= 0;
		if(press_out3_down == 1)
			out3_down_led <= 1;
		else
			out3_down_led <= 0;
		if(press_out4_down == 1)
			out4_down_led <= 1;
		else
			out4_down_led <= 0;
	end
	
	always @(posedge clk)
	begin
		if(n_5HZ == max_5HZ)
		begin
			clk_5HZ <= ~clk_5HZ;
			n_5HZ <= 0;
		end
		else
		begin
			n_5HZ <= n_5HZ + 1;
		end
	end
	
	always @(posedge clk_5HZ)
	begin
		if(call_state == 1)
		begin
			if(call_led1 == 0 && call_led2 == 0)
			begin
				call_led1 <= 1;
				call_led2 <= 0;
			end
			else
			begin
				call_led1 <= ~call_led1;
				call_led2 <= ~call_led2;
			end
		end
		else
		begin
			call_led1 <= 0;
			call_led2 <= 0;
		end
	end
	
	always @(posedge clk)
	begin
		led1 <= press_in1;
		led2 <= press_in2;
		led3 <= press_in3;
		led4 <= press_in4;
		
		if(door_open_sw)
			door_open_led = 1;
		else
			door_open_led = 0;
			
		if(door_close_sw)
			door_close_led = 1;
		else
			door_close_led = 0;
		
		//其实好像不要底下这个也行 不想改了（不需要input state）
		if(n == max)
		begin
			n <= 0;
			case(state)
			5'b00000://无请求
				begin
					
				end
			5'b00001://请求1 当前1
				begin
					led1 <= 0;
				end
			5'b00010://请求1 当前2
				begin
					
				end
			5'b00011://请求1 当前3
				begin
					
				end
			5'b00100://请求1 当前4
				begin
					
				end
			5'b00101://请求2 当前1
				begin
					
				end
			5'b00110://请求2 当前2
				begin
					led2 <= 0;
				end
			5'b00111://请求2 当前3
				begin
					
				end
			5'b01000://请求2 当前4
				begin
					
				end
			5'b01001://请求3 当前1
				begin
					
				end
			5'b01010://请求3 当前2
				begin
					
				end
			5'b01011://请求3 当前3
				begin
					led3 <= 0;
				end
			5'b01100://请求3 当前4
				begin
					
				end
			5'b01101://请求4 当前1
				begin
					
				end
			5'b01110://请求4 当前2
				begin
					
				end
			5'b01111://请求4 当前3
				begin
					
				end
			5'b10000://请求4 当前4
				begin
					led4 <= 0;
				end
			endcase
		end
		else n <= n + 1;
	end
	
endmodule
