`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/23 23:16:40
// Design Name: 
// Module Name: door
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


module door(
	input wire clk,
	output reg door_state = 0,
	input wire[1:0] direction,
	input wire[4:0] state,
	input wire door_open_sw,
	input wire door_close_sw
    );
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	always @(posedge clk)
	begin
	
		if(direction == 2'b00)
		begin
			if(door_open_sw && door_close_sw)	//开关门sw同时打开 视为开门
				door_state <= 1;
			else if(door_open_sw)	//开门sw打开
				door_state <= 1;
			else if(door_close_sw)	//关门sw打开
				door_state <= 0;
		end
		
		if(n == max)
		begin
			n <= 0;
			case(state)
			5'b00000://无请求
				begin
					if(door_open_sw == 0)
						door_state <= 0;
				end
			5'b00001://请求1 当前1
				begin
					door_state <= 1;
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
					door_state <= 1;
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
					door_state <= 1;
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
					door_state <= 1;
				end
			endcase
		end
		else n <= n + 1;
	end
	
	
	
endmodule
