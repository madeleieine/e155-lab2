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
	logic [3:0] out, out_exp;
	logic [31:0] errors, vectornum;
	logic [8:0] tv;
	mux dut(in0, in1, en, out);
	initial
		begin
			errors=0;
			vectornum=0;
			for(tv=9'b000000000; tv<=9'b111111111; tv = tv+1'b1) begin
				en = tv[0];
				#5;
				in1 = tv[8:5];
				in0 = tv[4:1];
				assign out_exp = en? in1 : in0;
				#5;
				assert(out == out_exp) else begin
					$display("Error: inputs = %b", tv);
					$display(" outputs = %b(%b expected)", out, in1);
					errors = errors + 1;
				end
				if (tv == 9'b111111111) begin
					vectornum = vectornum + 1;
					$display("%d tests completed with %d errors", vectornum, errors);
					$stop;
				end
				else begin
					vectornum = vectornum + 1;
				end
			end
			$display("%d tests completed with %d errors", vectornum, errors);
			$stop;
		end
endmodule