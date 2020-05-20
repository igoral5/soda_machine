`include "soda_machine_types.sv"
import soda_machine_types::*;


module soda_machine(
	input logic clk,
	input logic reset,
	input insert_type insert,
	output logic pour_water,
	output logic change1,
	output logic change2,
	output logic change22);

	typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_type;
	(* syn_encoding = "default" *) state_type state, nextstate;
	
	always_ff @(posedge clk, posedge reset)
	if (reset)
		state <= S0;
	else
		state <= nextstate;
	
	always_comb
		case (state)
			S0:
				case (insert)
					I1:
						nextstate = S1;
					I2:
						nextstate = S2;
					I5:
						nextstate = S0;
				endcase
			S1: 
				case (insert)
					I1:
						nextstate = S2;
					I2:
						nextstate = S3;
					I5:
						nextstate = S0;
				endcase
			S2:
				case (insert)
					I1:
						nextstate = S3;
					I2: 
						nextstate = S4;
					I5:
						nextstate = S0;
				endcase
			S3: 
				if (insert == I1)
					nextstate = S4;
				else
					nextstate = S0;
			S4:
				nextstate = S0;
		endcase
		
	assign pour_water = (state == S4) | (insert == I5) | (state == S3) & (insert == I2);
	
	assign change1 = (state == S1) & (insert == I5) | (state == S3) & (insert == I5) | (state == S4) & (insert == I2);
							
	assign change2 = (state == S2) & (insert == I5) | (state == S3) & (insert == I5);
	
	assign change22 = (state == S4) & (insert == I5);
	
endmodule
	