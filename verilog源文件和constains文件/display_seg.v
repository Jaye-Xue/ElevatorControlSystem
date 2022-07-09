`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/21 09:59:55
// Design Name: 
// Module Name: display_seg
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


module display_seg(
	input wire clk,
	output reg[10:0] display_floor = 11'b1110_1001111,
	input wire[1:0] now_floor,
	input wire[1:0] direction,
	input wire door_state,
	input wire[1:0] pointer
    );
	
	reg [19:0] count = 0; 
	reg[2:0] select = 0;
    parameter T1MS=50000;   //1ms
	
	always @(posedge clk)
	begin
		case(select)
		0:
			begin
				case(now_floor)
				2'b00:	//在1楼
					begin
					display_floor <= 11'b1110_1001111;
					end
				2'b01:	//在2楼
					begin
					display_floor <= 11'b1110_0010010;
					end
				2'b10:	//在3楼
					begin
					display_floor <= 11'b1110_0000110;
					end
				2'b11:	//在4楼
					begin
					display_floor <= 11'b1110_1001100;
					end
				endcase
			end
		1:
			begin
				case(pointer)
				2'b00:
					begin
					display_floor <= 11'b1111_1111111;
					end
				2'b01:
					begin
					display_floor <= 11'b1101_0011101;
					end
				2'b10:
					begin
					display_floor <= 11'b1101_1100011;
					end
				endcase
			end
		2:
			begin
				if(door_state == 0)	//关门显示C(close)
				begin
					display_floor <= 11'b1011_0110001;
				end
				else				//开门显示O(open)
				begin
					display_floor <= 11'b1011_0000001;
				end
			end
		3:
			begin
				case(direction)
				2'b00:	//电梯静止
					begin
					display_floor <= 11'b0111_1111110;
					end
				2'b01:	//电梯上行
					begin
					display_floor <= 11'b0111_0111111;
					end
				2'b10:	//电梯下行
					begin
					display_floor <= 11'b0111_1110111;
					end
				endcase
			end
		endcase

		
	end
	
	
	always@(posedge clk)
	begin
		count <= count + 1;
		if(count == T1MS)
			begin
			count <= 0;
			select <= select + 1;
			if(select == 4)
				select <= 0;
			end
	end
	
	
endmodule
