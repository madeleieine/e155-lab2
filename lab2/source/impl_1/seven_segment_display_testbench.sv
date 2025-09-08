/*
Testbench for seven_segment_display.sv
4-bit input, 7-bit output
3 September 2025
Madeleine Kan
mkan@g.hmc.edu
*/
module seven_segment_display_testbench();
	logic clk, reset;
	logic [3:0] s;
	logic [6:0] seg, seg_exp;
	logic [31:0] vectornum, errors;
	logic [10:0] testvectors[10000:0];
	seven_segment_display dut(s, seg);
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
			{s, seg_exp} = testvectors[vectornum];
		end
	always @(negedge clk)
		if (~reset) begin
			if (seg !== seg_exp) begin
				$display("Error: inputs = %b", {seg});
				$display(" outputs = %b(%b expected)", seg, seg_exp);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 11'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				$stop;
			end
		end
endmodule