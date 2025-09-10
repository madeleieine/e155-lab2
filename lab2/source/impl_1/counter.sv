/*
counter.sv

Takes in clk, clock signal
Outputs clk_new, a new clock signal that rises every 2^N clk cycles
Madeleine Kan
mkan@hmc.edu
3 September, 2025
*/

module counter #(parameter N = 17)
	 (input logic clk, reset,
	 output logic clk_div);
	 
	logic [N:0] counter;
	always_ff @(posedge clk) begin
		if (reset == 1'b1) begin // active low
			counter <= 1'b0;
		end
		else begin
			counter <= counter + 1'b1;
		end
	end
	assign clk_div = counter[N]
endmodule
