`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 16:56:19
// Design Name: 
// Module Name: out_btn
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


module out_btn(
	input wire clk,
	output reg press_out1_up = 0,
	output reg press_out2_up = 0,
	output reg press_out2_down = 0,
	output reg press_out3_up = 0,
	output reg press_out3_down = 0,
	output reg press_out4_down = 0,
	input wire out1_up_sw,
	input wire out2_up_sw,
	input wire out2_down_sw,
	input wire out3_up_sw,
	input wire out3_down_sw,
	input wire out4_down_sw,
	input wire led_out_test_sw,
	input wire[4:0] state,
	input wire[1:0]	pointer,
	input wire[3:0] request_total,
	input wire press_in1,
	input wire press_in2, 
	input wire press_in3, 
	input wire press_in4
    );
	
	reg[5:0] last_state = 6'b000000;	//从左到右依次是1上，2上下，3上下，4下
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	always @(posedge clk)
	begin
		if(last_state[5] != out1_up_sw)
			press_out1_up <= ~press_out1_up;
		if(last_state[4] != out2_up_sw)
			press_out2_up <= ~press_out2_up;
		if(last_state[3] != out2_down_sw)
			press_out2_down <= ~press_out2_down;
		if(last_state[2] != out3_up_sw)
			press_out3_up <= ~press_out3_up;
		if(last_state[1] != out3_down_sw)
			press_out3_down <= ~press_out3_down;
		if(last_state[0] != out4_down_sw)
			press_out4_down <= ~press_out4_down;
			
		last_state <= {out1_up_sw,out2_up_sw,out2_down_sw,out3_up_sw,out3_down_sw,out4_down_sw};
		
		if(led_out_test_sw)
		begin
			press_out1_up <= 0;
			press_out2_up <= 0;
			press_out2_down <= 0;
			press_out3_up <= 0;
			press_out3_down <= 0;
			press_out4_down <= 0;
		end
		
		if(n == max)
		begin
			n <= 0;
			case(state)
			5'b00000://无请求
				begin
					
				end
			5'b00001://请求1 当前1
				begin
					press_out1_up <= 0;
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
					if(press_out2_up == 0 && press_out2_down == 1 && (request_total == 4 ||
						(press_out3_up == 0 && press_out3_down == 1  && request_total == 6)))
						press_out2_down <= 0;
					if(press_out2_up == 1 && press_out2_down == 0 && (request_total == 4 ||
						(press_out3_up == 1 && press_out3_down == 0 && request_total == 6)))
						press_out2_up <= 0;
					if(pointer == 2'b10)
						press_out2_down <= 0;
					if(pointer == 2'b01)
						press_out2_up <= 0;
					if(pointer == 2'b00)
					begin
						press_out2_down <= 0;
						press_out2_up <= 0;
					end
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
					if(press_out3_up == 0 && press_out3_down == 1 && (request_total == 2 ||
						(request_total == 6 && press_out2_up == 0 && press_out2_down == 1)))
						press_out3_down <= 0;
					if(press_out3_up == 1 && press_out3_down == 0 && (request_total == 2 ||
						(request_total == 6 && press_out2_up == 1 && press_out2_down == 0)))
						press_out3_up <= 0;
					if(pointer == 2'b10)
						press_out3_down <= 0;
					if(pointer == 2'b01)
						press_out3_up <= 0;
					if(pointer == 2'b00)
					begin
						press_out3_down <= 0;
						press_out3_up <= 0;
					end
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
					press_out4_down <= 0;
				end
			endcase
		end
		else n <= n + 1;
	end
	
	
	
endmodule
