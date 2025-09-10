/*
lab1_top.sv

Drives give LEDs and two 7-segment displays based on inputs from
eight switches. 7-segment displays count up from 0-F in hex based
on the binary value encoded by the state of the switches: the first four
correspond to the first 7-segment display, and the second four switches to
the second 7-segment display. The five LEDs represent the sum of the values 
encoded by the two sets of four switches.

Madeleine Kan
mkan@hmc.edu
7 September, 2025
*/
`timescale 1ns/1ns
module lab2_mk_top(
	input logic [3:0] s0, s1,
	output logic [4:0] led,
	output logic [6:0] seg,
	output logic anode0, anode1
);
	logic clk, clk_div, anode0_int, anode1_int;
	logic [4:0] led_int;
	logic [6:0] seg_int;

	// Internal high-speed oscillator
	HSOSC #(.CLKHF_DIV(2'b01)) // 24MHz from clk divider
	 hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	
	// Counter, changes ~91Hz
	counter count(clk, clk_div);
	led_driver driver(clk_div, s0, s1, led_int, seg_int, anode0_int, anode1_int);
	
	always_ff @(posedge clk) begin
		anode0 <= anode0_int;
		anode1 <= anode1_int;
		led <= led_int;
		seg <= seg_int;
	end
	
		
endmodule