/*
counter.sv

Takes in clk, clock signal
Outputs clk_new, a new clock signal that rises every 2^23 clk cycles
Madeleine Kan
mkan@hmc.edu
3 September, 2025
*/

module counter
	 (input logic clk,
	 output logic clk_div);
	 
	logic [23:0] counter;
	always_ff @(posedge clk)
		counter <= counter + 24'b1;
	assign clk_div = counter[23];
endmodule