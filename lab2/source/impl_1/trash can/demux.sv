/*
demux.sv

Synchronous enabled mux with 2 outputs
Intentionally leaves one output undriven
All inputs and outputs are 7 bits wide

Madeleine Kan
mkan@hmc.edu
7 September, 2025
*/
`timescale 1ns/1ns
module demux(
	input logic [6:0] in,
	input logic en,
	output logic [6:0] out0, out1
);
	always @(en) begin
		if (en) out1 <= in;
		else out0 <= in;
	end
endmodule