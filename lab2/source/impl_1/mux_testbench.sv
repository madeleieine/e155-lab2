/*
Testbench for mux.sv
3-bit input, 1-bit output
7 September 2025
Madeleine Kan
mkan@g.hmc.edu
*/
module mux_testbench();
	logic in0, in1, en;
	logic out, out_exp;
	logic [31:0] vectornum, errors;
	logic [3:0] testvectors[10000:0];
	mux dut(in0, in1, en, out_exp);
	always
		begin
			clk=1; #5; 
			clk=0; #5;
		end
	initial
		begin
			$readmemb("C:/Users/mkan/Documents/e155-lab1/fpga/radiant_project/source/impl_1/seg_exp.tv", testvectors);
			vectornum=0; 
			errors=0;
			reset=1; #5; 
			reset=0;
		end
	always @(posedge clk)
		begin
			#1;
			{in0, in1, en} = testvectors[vectornum];
		end
	always @(negedge clk)
		if (~reset) begin
			if (seg !== seg_exp) begin
				$display("Error: inputs = %b %b %b", {in0, in1, en});
				$display(" outputs = %b(%b expected)", out, out_exp);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 11'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				$stop;
			end
		end
endmodule