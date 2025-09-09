
/*
lab1_top.sv

Drives give LEDs and two 7-segment displays based on inputs from
eight switches. 7-segment displays count up from 0-F in hex based
on the binary value encoded by the state of the switches: the first four
correspond to the first 7-segment display, and the second four switches to
the second 7-segment display. The five LEDs represent the sum of the values 
encoded by the two sets of four switches. Which set of switches (s0 or s1)
are read and which 7-seg display (seg0 or seg1) depends on if clk is 0 or 1

Madeleine Kan
mkan@hmc.edu
9 September, 2025
*/
`timescale 1ns/1ns
module led_driver(
	input logic clk,
	input logic [3:0] s0, s1,
	output logic [4:0] led,
	output logic [6:0] seg0, seg1,
	output logic anode0, anode1
);
	logic [3:0] s_in;
	logic [6:0] seg_out;
	
	// Assign LED output
	assign led = s0 + s1;
	
	// Mux input
	mux mux0(s0, s1, clk, s_in); 
	// Feed input to seven_segment_display
	seven_segment_display display0(s_in, seg_out);

	// Control seven-segment display common anodes
	assign anode0 = ~clk;
	assign anode1 = clk;
	
	// drive seven-segment displays
	assign seg0 = seg_out;
	assign seg1 = seg_out;
	
	
	
endmodule