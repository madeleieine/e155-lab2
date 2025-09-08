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
	always @(en) begin
		if (en) out <= in1;
		else out <= in0;
	end
endmodule