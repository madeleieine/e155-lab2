/*
Testbench for counter.sv
1 bit input, 1 bit output, output flips after 2^17 cycles of the input.
3 September 2025
Madeleine Kan
mkan@g.hmc.edu
*/
module counter_testbench();
	logic clk, reset, clk_div;
	counter dut(clk, reset, clk_div);
	always
		begin
			clk=1; #5; 
			clk=0; #5;
		end
	initial begin
		reset=0; #5; 
		reset=1;
		#7
		assert(clk_div == 1'b0) else $display("Error: inputs = %b", clk, " outputs = %b(0 expected)", clk_div);
		#655365; // 5*2^17 + 5
		assert(clk_div == 1'b1) else $display("Error: inputs = %b", clk, " outputs = %b(1 expected)", clk_div);
		$display("tests completed!");
		$stop;
	end
endmodule