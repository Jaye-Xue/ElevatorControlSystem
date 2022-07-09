`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/15 21:27:31
// Design Name: 
// Module Name: state
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


module state(
	input wire clk,
	output reg[1:0] now_floor = 2'b00,
	output reg[4:0] state = 5'b00000,
	output reg[1:0] direction = 2'b00,
	input wire door_state,
	output reg[1:0]	pointer = 2'b00,
	input wire press_out1_up,
	input wire press_out2_up,
	input wire press_out2_down,
	input wire press_out3_up,
	input wire press_out3_down,
	input wire press_out4_down,
	output reg[3:0] request_total = 4'b0000,
	input wire press_in1,
	input wire press_in2, 
	input wire press_in3, 
	input wire press_in4
    );
	
	parameter max=100000000; //2秒
	reg[30:0] n;
	
	function [4:0] jump_state;
	input [1:0] floor;
		begin
		case(floor)
		2'b00:	//响应1楼请求，会在1楼停
			begin
			
			case(now_floor)
			2'b00:
				begin
				jump_state = 5'b00001;
				end
			2'b01:
				begin
				jump_state = 5'b00010;
				end
			2'b10:
				begin
				jump_state = 5'b00011;
				end
			2'b11:
				begin
				jump_state = 5'b00100;
				end
			endcase
			end
		2'b01:	//响应2楼请求，会在2楼停
			begin
			case(now_floor)
			2'b00:
				begin
				jump_state = 5'b00101;
				end
			2'b01:
				begin
				jump_state = 5'b00110;
				end
			2'b10:
				begin
				jump_state = 5'b00111;
				end
			2'b11:
				begin
				jump_state = 5'b01000;
				end
			endcase
			end
		2'b10:	//响应3楼请求，会在3楼停
			begin
			case(now_floor)
			2'b00:
				begin
				jump_state = 5'b01001;
				end
			2'b01:
				begin
				jump_state = 5'b01010;
				end
			2'b10:
				begin
				jump_state = 5'b01011;
				end
			2'b11:
				begin
				jump_state = 5'b01100;
				end
			endcase
			end
		2'b11:	//响应4楼请求，会在4楼停
			begin
			case(now_floor)
			2'b00:
				begin
				jump_state = 5'b01101;
				end
			2'b01:
				begin
				jump_state = 5'b01110;
				end
			2'b10:
				begin
				jump_state = 5'b01111;
				end
			2'b11:
				begin
				jump_state = 5'b10000;
				end
			endcase
			end
		endcase
		end
	endfunction
	
	always @(posedge clk)
	begin
		if(press_in1 || press_out1_up)
		begin
			
			if(direction == 2'b00 && door_state == 0)
			begin
				if(now_floor > 0)	//电梯在2、3、4楼
					direction <= 2'b10;
			end
			
			if(pointer == 2'b00)
			begin
				if(now_floor > 0)	//电梯在2、3、4楼
					pointer <= 2'b10;
				else 
				begin
					if(press_out1_up == 1)
						pointer <= 2'b01;
				end
			end
		end

		if(press_in2 || press_out2_up || press_out2_down)
		begin
			
			if(direction == 2'b00 && door_state == 0)
			begin
				if(now_floor == 0)	//电梯在1楼
					direction <= 2'b01;
				if(now_floor > 1)	//电梯在3、4楼
					direction <= 2'b10;
			end
			
			if(pointer == 2'b00)
			begin
				if(now_floor == 0)	//电梯在1楼
					pointer <= 2'b01;
				else if(now_floor > 1)	//电梯在3、4楼
					pointer <= 2'b10;
				else
				begin
					if(press_out2_down == 1)
						pointer <= 2'b10;
					if(press_out2_up == 1)
						pointer <= 2'b01;
				end
			end
		end
		
		if(press_in3 || press_out3_up || press_out3_down)
		begin
			
			if(direction == 2'b00 && door_state == 0)
			begin
				if(now_floor == 3)	//电梯在4楼
					direction <= 2'b10;
				if(now_floor < 2)	//电梯在1、2楼
					direction <= 2'b01;
			end
			
			if(pointer == 2'b00)
			begin
				if(now_floor == 3)	//电梯在4楼
					pointer <= 2'b10;
				else if(now_floor < 2)	//电梯在1、2楼
					pointer <= 2'b01;
				else
				begin
					if(press_out3_down == 1)
						pointer <= 2'b10;
					if(press_out3_up == 1)
						pointer <= 2'b01;
				end
			end
		end
		
		if(press_in4 || press_out4_down)
		begin
			
			if(direction == 2'b00 && door_state == 0)
			begin
				if(now_floor < 3)	//电梯在1、2、3楼
					direction <= 2'b01;
			end
			
			if(pointer == 2'b00)
			begin
				if(now_floor < 3)	//电梯在1、2、3楼
					pointer <= 2'b01;
				else
				begin
					if(press_out4_down == 1)
						pointer <= 2'b10;
				end
			end
		end
		
		request_total = {press_in1 | press_out1_up, press_in2 | press_out2_up | press_out2_down, 
					press_in3 | press_out3_up | press_out3_down, press_in4 | press_out4_down};	//将楼层请求合并
					
	
		if(n == max)
		begin
			n <= 0;
			case(state)
			5'b00000://等待状态
				begin
					if(door_state == 1)	//开门状态
						state <= 5'b00000;
					else				//关门状态
					begin
						case(request_total)
						4'b0000:	//无楼层请求
							begin
							state <= 5'b00000;
							pointer <= 2'b00;
							direction <= 2'b00;
							end
						4'b0001:	//4楼请求
							begin
							state = jump_state(4-1);
							end
						4'b0010:	//3楼请求
							begin
							state = jump_state(3-1);
							end
						4'b0011:	//3楼和4楼均有请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(3-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(3-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								if(press_out3_down == 1 && press_out3_up == 0)
									state = jump_state(4-1);
								else
									state = jump_state(3-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(4-1);
								end
							endcase
							end
						4'b0100:	//2楼请求
							begin
							state = jump_state(2-1);
							end
						4'b0101:	//2、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(2-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									
									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(4-1);
								end
							2'b10:	//正在下行
								begin
								if(press_out2_down == 0 && press_out2_up == 1)
									state = jump_state(4-1);
								else
									state = jump_state(2-1);
								end
							endcase
							end
						4'b0110:	//2、3楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									if(press_out3_down == 1 && press_out3_up == 0 && press_out2_down == 1 && press_out2_up == 0 && press_in2 == 0 && press_in3 == 0)
										state = jump_state(3-1);
									else
										state = jump_state(2-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									if(press_out3_down == 0 && press_out3_up == 1 && press_out2_down == 0 && press_out2_up == 1 && press_in2 == 0 && press_in3 == 0)
										state = jump_state(2-1);
									else
										state = jump_state(3-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								if(press_out2_up == 0 && press_out2_down == 1)
								begin
									if(press_out3_up == 0 && press_out3_down == 1 && now_floor == 2'b10)
										pointer <= 2'b10;
									else
										state = jump_state(3-1);
								end
								else
									state = jump_state(2-1);
								end
							2'b10:	//正在下行
								begin
								if(press_out3_down == 0 && press_out3_up == 1)
								begin
									if(press_out2_down == 0 && press_out2_up == 1 && now_floor == 2'b01) 
										pointer <= 2'b01;
									else
										state = jump_state(2-1);
								end
								else
									state = jump_state(3-1);
								end
							endcase
							end
						4'b0111:	//2、3、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(2-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								if(press_out2_down == 1 && press_out2_up == 0)
								begin
									if(press_out3_down == 1 && press_out3_up == 0)
										state = jump_state(4-1);
									else
										state = jump_state(3-1);
								end
								else
									state = jump_state(2-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(4-1);
								end
							endcase
							end
						4'b1000:	//1楼请求
							begin
							state = jump_state(1-1);
							end
						4'b1001:	//1、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin

									end
								2'b10:	//在3楼
									begin

									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(4-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(1-1);
								end
							endcase
							end
						4'b1010:	//1、3楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin

									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(3-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								if(press_out3_up == 0 && press_out3_down == 1)
									state = jump_state(1-1);
								else
									state = jump_state(3-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(1-1);
								end
							endcase
							end
						4'b1011:	//1、3、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin
									
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								if(press_out3_up == 0 && press_out3_down == 1)
									state = jump_state(4-1);
								else
									state = jump_state(3-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(1-1);
								end
							endcase
							end
						4'b1100:	//1、2楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(2-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(2-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(1-1);
								end
							2'b10:	//正在下行
								begin
								if(press_out2_down == 0 && press_out2_up == 1)
									state = jump_state(1-1);
								else
									state = jump_state(2-1);
								end
							endcase
							end
						4'b1101:	//1、2、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin

									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(4-1);
								end
							2'b10:	//正在下行
								begin
								if(press_out2_down == 0 && press_out2_up == 1)
									state = jump_state(1-1);
								else
									state = jump_state(2-1);
								end
							endcase
							end
						4'b1110:	//1、2、3楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin

									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(1-1);
								end
							2'b10:	//正在下行
								begin
								if(press_out3_down == 0 && press_out3_up == 1)
								begin
									if(press_out2_down == 0 && press_out2_up == 1)
										state = jump_state(1-1);
									else
										state = jump_state(2-1);
								end
								else
									state = jump_state(3-1);
								end
							endcase
							end
						4'b1111:	//1、2、3、4楼请求
							begin
							case(pointer)
							2'b00:	//停着
								begin
								case(now_floor)
								2'b00:	//在1楼
									begin
									state = jump_state(1-1);
									end
								2'b01:	//在2楼
									begin
									state = jump_state(2-1);
									end
								2'b10:	//在3楼
									begin
									state = jump_state(3-1);
									end
								2'b11:	//在4楼
									begin
									state = jump_state(4-1);
									end
								endcase
								end
							2'b01:	//正在上行
								begin
								state = jump_state(1-1);
								end
							2'b10:	//正在下行
								begin
								state = jump_state(4-4);
								end
							endcase
							end
						
						endcase
					end

				end
			5'b00001://请求1 当前1
				begin
					if(press_out1_up == 1)
						pointer <= 2'b01;
					state <= 5'b00000;
					now_floor <= 2'b00;
					direction <= 2'b00;
				end
			5'b00010://请求1 当前2
				begin
					if(press_in2 == 1 ||
						(press_out2_down == 1 && pointer == 2'b10) ||
						(press_out2_up == 1 && pointer == 2'b01))	//如果2楼有请求（分为内请求和外请求）
						state <= 5'b00110;
					else
					begin
						state <= 5'b00001;
						now_floor <= 2'b00;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b00011://请求1 当前3	
				begin
					if(press_in3 == 1 ||
						(press_out3_down == 1 && pointer == 2'b10) ||
						(press_out3_up == 1 && pointer == 2'b01))	//如果3楼有请求
						state <= 5'b01011;
					else
					begin
						state <= 5'b00010;
						now_floor <= 2'b01;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b00100://请求1 当前4
				begin
					if(press_in4 == 1 || press_out4_down == 1)	//如果4楼有请求
						state <= 5'b10000;
					else
					begin
						state <= 5'b00011;
						now_floor <= 2'b10;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b00101://请求2 当前1
				begin
					if(press_in1 == 1 || press_out1_up == 1)	//如果1楼有请求
						state <= 5'b00001;
					else
					begin
						state <= 5'b00110;
						now_floor <= 2'b01;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b00110://请求2 当前2
				begin
					if(press_out2_up == 0 && press_out2_down == 1 && (request_total == 4 ||
						(press_out3_up == 0 && press_out3_down == 1 && request_total == 6)))
						pointer <= 2'b10;
					if(press_out2_up == 1 && press_out2_down == 0 && (request_total == 4 ||
						(press_out3_up == 1 && press_out3_down == 0 && request_total == 6)))
						pointer <= 2'b01;
					state <= 5'b00000;
					direction <= 2'b00;
					now_floor <= 2'b01;
				end
			5'b00111://请求2 当前3
				begin
					if(press_in3 == 1 ||
						(press_out3_down == 1 && pointer == 2'b10) ||
						(press_out3_up == 1 && pointer == 2'b01))	//如果3楼有请求
						state <= 5'b01011;
					else
					begin
						state <= 5'b00110;
						now_floor <= 2'b01;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b01000://请求2 当前4
				begin
					if(press_in4 == 1 || press_out4_down == 1)	//如果4楼有请求
						state <= 5'b10000;
					else
					begin
						state <= 5'b00111;
						now_floor <= 2'b10;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b01001://请求3 当前1
				begin
					if(press_in1 == 1 || press_out1_up == 1)	//如果1楼有请求
						state <= 5'b00001;
					else
					begin
						state <= 5'b01010;
						now_floor <= 2'b01;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b01010://请求3 当前2
				begin
					if(press_in2 == 1 ||
						(press_out2_down == 1 && pointer == 2'b10) ||
						(press_out2_up == 1 && pointer == 2'b01))	//如果2楼有请求（分为内请求和外请求）
						state <= 5'b00110;
					else
					begin
						state <= 5'b01011;
						now_floor <= 2'b10;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b01011://请求3 当前3
				begin
					if(press_out3_up == 0 && press_out3_down == 1 && (request_total == 2 ||
						(request_total == 6 && press_out2_up == 0 && press_out2_down == 1)))
						pointer <= 2'b10;
					if(press_out3_up == 1 && press_out3_down == 0 && (request_total == 2 ||
						(request_total == 6 && press_out2_up == 1 && press_out2_down == 0)))
						pointer <= 2'b01;
					state <= 5'b00000;
					now_floor <= 2'b10;
					direction <= 2'b00;
				end
			5'b01100://请求3 当前4
				begin
					if(press_in4 == 1 || press_out4_down == 1)	//如果4楼有请求
						state <= 5'b10000;
					else
					begin
						state <= 5'b01011;
						now_floor <= 2'b10;
						direction <= 2'b10;
						pointer <= 2'b10;
					end
				end
			5'b01101://请求4 当前1
				begin
					if(press_in1 == 1 || press_out1_up == 1)	//如果1楼有请求
						state <= 5'b00001;
					else
					begin
						state <= 5'b01110;
						now_floor <= 2'b01;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b01110://请求4 当前2
				begin
					if(press_in2 == 1 ||
						(press_out2_down == 1 && pointer == 2'b10) ||
						(press_out2_up == 1 && pointer == 2'b01))	//如果2楼有请求（分为内请求和外请求）
						state <= 5'b00110;
					else
					begin
						state <= 5'b01111;
						now_floor <= 2'b10;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b01111://请求4 当前3
				begin
					if(press_in3 == 1 ||
						(press_out3_down == 1 && pointer == 2'b10) ||
						(press_out3_up == 1 && pointer == 2'b01))	//如果3楼有请求
						state <= 5'b01011;
					else
					begin
						state <= 5'b10000;
						now_floor <= 2'b11;
						direction <= 2'b01;
						pointer <= 2'b01;
					end
				end
			5'b10000://请求4 当前4
				begin
					if(press_out4_down == 1)
						pointer <= 2'b10;
					state <= 5'b00000;
					now_floor <= 2'b11;
					direction <= 2'b00;
				end
			endcase
		end
		else n <= n + 1;
		
	end
	
endmodule
