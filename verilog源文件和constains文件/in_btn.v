`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 17:00:20
// Design Name: 
// Module Name: in_btn
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


module in_btn(
	input wire clk,
	input wire press1,
	input wire press2,
	input wire press3,
	input wire press4,
	output reg press_in1 = 0,
	output reg press_in2 = 0,
	output reg press_in3 = 0,
	output reg press_in4 = 0,
	input wire[4:0] state
    );
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	always @(posedge clk)
	begin
		if(press1)
			press_in1 <= ~press_in1;
		if(press2)
			press_in2 <= ~press_in2;
		if(press3)
			press_in3 <= ~press_in3;
		if(press4)
			press_in4 <= ~press_in4;
		
		
		if(n == max)
		begin
			n <= 0;
			case(state)
			5'b00000://无请求
				begin

				end
			5'b00001://请求1 当前1
				begin
				press_in1 <= 0;
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
				press_in2 <= 0;
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
				press_in3 <= 0;
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
				press_in4 <= 0;
				end
			endcase
		end
		else n <= n + 1;
	end
	
	
endmodule
