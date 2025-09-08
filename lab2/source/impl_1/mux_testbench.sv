/*
Testbench for mux.sv
3-bit input, 1-bit output
7 September 2025
Madeleine Kan
mkan@g.hmc.edu
*/
`timescale 1ns/1ns

module mux_testbench();
	logic [3:0] in0, in1;
	logic en;
	logic [3:0] out;
	logic [31:0] errors, vectornum;
	logic [8:0] tv;
	mux dut(in0, in1, en, out);
	initial
		begin
			errors=0;
			vectornum=0;
		for(tv=9'b000000000; tv<=9'b111111111; tv = tv+1) begin
			#1;
			vectornum = vectornum + 1;
			in1 = tv[8:5];
			in0 = tv[4:1];
			en = tv[0];
			$display("enable bit = %b", en);
			$display("output  = %b", out);
			if(en) begin
				assert(out == in1) else begin
					$display("Error: inputs = %b", tv);
					$display(" outputs = %b(%b expected)", out, in1);
					errors = errors + 1;
				end
			end
			else begin
				assert(out == in0) else begin
					$display("Error: inputs = %b", tv);
					$display(" outputs = %b(%b expected)", out, in0);
					errors = errors + 1;
				end
			end		
		end
		$display("%d tests completed with %d errors", vectornum, errors);
		$stop;
	end
endmodule