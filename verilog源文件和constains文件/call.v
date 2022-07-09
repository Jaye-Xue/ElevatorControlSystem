`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 16:19:34
// Design Name: 
// Module Name: call
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


module call(
	input wire clk,
	output reg call_state = 0,
	input wire press_call
    );
	
	always @(posedge clk)
	begin
		if(press_call)
		begin
			call_state <= ~call_state;
		end
	end
	
endmodule
