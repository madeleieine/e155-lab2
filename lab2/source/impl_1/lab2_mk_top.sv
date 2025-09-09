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
	output logic [6:0] seg0, seg1,
	output logic anode0, anode1
);
	logic clk_div;
	logic [3:0] s_in;
	logic [6:0] seg_out;
	// Internal high-speed oscillator
	HSOSC #(.CLKHF_DIV(2'b01)) // 24MHz from clk divider
	 hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	
	// Counter, changes ~2.8Hz
	counter count(clk, clk_div);
	
	// Control seven-segment display common anodes
	assign anode0 = ~clk_div;
	assign anode1 = clk_div;
	
	// Mux input 
	mux mux0(s0, s1, clk_div, s_in);
	// Feed input to seven_segment_display
	seven_segment_display display0(s_in, seg_out);
	// Demux output
	demux demux0(seg_out, clk_div, seg0, seg1);
	
	// Assign LED output
	assign led = s0 + s1;
	
endmodule