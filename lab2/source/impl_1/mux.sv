/*
mux.sv

Synchronous enabled mux with 2 inputs
all inputs and outputs are 4 bits wide

Madeleine Kan
mkan@hmc.edu
7 September, 2025
*/

`timescale 1ns/1ns

module mux(
	input logic [3:0] in0, [3:0] in1, 
	input logic en,
	output logic [3:0] out
);
	always_ff @(en) begin
		if (en==1'b1) out <= in0; // was flipped before
		else out <= in1;
	end
endmodule