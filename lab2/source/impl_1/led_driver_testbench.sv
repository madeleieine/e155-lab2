/*
Testbench for mux.sv
3-bit input, 1-bit output
7 September 2025
Madeleine Kan
mkan@g.hmc.edu
*/
`timescale 1ns/1ns

module led_driver_testbench();
	logic clk;
	logic [3:0] s0, s1, s_exp;
	logic [4:0] led, led_exp;
	logic [6:0] seg, seg_exp;
	logic anode0, anode1, anode0_exp, anode1_exp;
	logic [31:0] errors, vectornum;
	logic [6:0] tv;
	led_driver dut(clk, s0, s1, led, seg, anode0, anode1);
	
	initial
		begin
			errors=0;
			vectornum=0;
			for(tv=9'b000000000; tv<=9'b111111111; tv = tv+1'b1) begin
				clk = tv[0];
				#1
				s1 = tv[8:5];
				s0 = tv[4:1];
				assign led_exp = s0+s1;
				assign anode0_exp = ~clk;
				assign anode1_exp = clk;   
				assign s_exp = clk?s1:s0;
				#1
				case(s_exp)
					//				  abcdefg
					4'b0000: seg_exp = 7'b0000001; // 0
					4'b0001: seg_exp = 7'b1001111; // 1
					4'b0010: seg_exp = 7'b0010010; // 2
					4'b0011: seg_exp = 7'b0000110; // 3
					4'b0100: seg_exp = 7'b1001100; // 4
					4'b0101: seg_exp = 7'b0100100; // 5
					4'b0110: seg_exp = 7'b0100000; // 6
					4'b0111: seg_exp = 7'b0001111; // 7
					4'b1000: seg_exp = 7'b0000000; // 8
					4'b1001: seg_exp = 7'b0001100; // 9
					4'b1010: seg_exp = 7'b0001000; // a
					4'b1011: seg_exp = 7'b1100000; // b
					4'b1100: seg_exp = 7'b0110001; // c
					4'b1101: seg_exp = 7'b1000010; // d
					4'b1110: seg_exp = 7'b0110000; // e
					4'b1111: seg_exp = 7'b0111000; // f
					default: seg_exp = 7'b1111111; // none
				endcase
				#5;
				assert({led, seg, anode0, anode1} === {led_exp, seg_exp, anode0_exp, anode1_exp}) else begin
					$display("Error: clk = %b, s0 = %b, s1 = %b", clk, s0, s1);
					$display(" outputs: (led, seg, anode0, anode1) = %b(%b expected)", {led, seg, anode0, anode1}, {led_exp, seg_exp, anode0_exp, anode1_exp});
					errors = errors + 1;
				end
				if (tv == 7'b1111111) begin
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