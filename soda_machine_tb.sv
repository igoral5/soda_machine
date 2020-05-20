`include "soda_machine_types.sv"
import soda_machine_types::*;

module soda_machine_tb;

	insert_type insert;
	
	logic [5:0] testvectors[10000:0];
	
	int vectornum, errors;
	
	logic clk, reset, pour_water, change1, change2, change22;
	logic pour_water_expected, change1_expected, change2_expected, change22_expected;
	
	soda_machine dut(
		.clk(clk),
		.reset(reset),
		.insert(insert),
		.pour_water(pour_water),
		.change1(change1),
		.change2(change2),
		.change22(change22)
	);
	
	always
		#5 clk = ~clk;
	
	initial begin
		$readmemb("../../soda_machine.tv", testvectors);
		vectornum = 0;
		errors = 0;
		clk = 1;
		reset = 1; #13; reset = 0;
	end
	
	always @(posedge clk) begin
		#1; {insert, pour_water_expected, change1_expected, change2_expected, change22_expected} = testvectors[vectornum];
	end
	
	always @(negedge clk)
		if (~reset) begin
			if ((pour_water !== pour_water_expected) || (change1 !== change1_expected) || (change2 !== change2_expected) ||
				(change22 !== change22_expected)) begin
				$error("%3d test insert=%b\noutputs pour_water=%b (%b expected), change1=%b (%b expected), change2=%b (%b expected), change22=%b (%b expected)", 
					vectornum + 1, insert, pour_water, pour_water_expected, change1, change1_expected, change2, change2_expected, change22, change22_expected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 6'bx) begin
				$display("Result: %3d tests completed with %3d errors", vectornum, errors);
				$stop;
			end
		end

endmodule
