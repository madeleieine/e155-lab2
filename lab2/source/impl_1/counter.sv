/*
counter.sv

Takes in clk, clock signal
Outputs clk_new, a new clock signal that rises every 2^(N-1) clk cycles
Madeleine Kan
mkan@hmc.edu
3 September, 2025
*/

module counter #(parameter N = 18)
	 (input logic clk,
	 output logic clk_div);
	 
	logic [N:0] counter;
	always_ff @(posedge clk)
		counter <= counter + 1'b1;
	assign clk_div = counter[N];
endmodule