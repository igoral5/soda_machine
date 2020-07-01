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
	
	insert_type insert_sync0, insert_sync1;
	logic pour_water_out, change1_out, change2_out, change22_out;
	
	always_ff @(posedge clk, posedge reset)
	if (reset) begin
		state <= S0;
		insert_sync0 <= I0;
		insert_sync1 <= I0;
		pour_water <= 0;
		change1 <= 0;
		change2 <= 0;
		change22 <= 0;
	end else begin
		state <= nextstate;
		insert_sync0 <= insert;
		insert_sync1 <= insert_sync0;
		pour_water <= pour_water_out;
		change1 <= change1_out;
		change2 <= change2_out;
		change22 <= change22_out;
	end
	
	always_comb
	case (state)
		S0:
			case (insert_sync1)
				I1:
					nextstate = S1;
				I2:
					nextstate = S2;
				default:
					nextstate = S0;
			endcase
		S1: 
			case (insert_sync1)
				I1:
					nextstate = S2;
				I2:
					nextstate = S3;
				I5:
					nextstate = S0;
				default:
					nextstate = S1;
			endcase
		S2:
			case (insert_sync1)
				I1:
					nextstate = S3;
				I2: 
					nextstate = S4;
				I5:
					nextstate = S0;
				default:
					nextstate = S2;
			endcase
		S3:
			case (insert_sync1)
				I0:
					nextstate = S3;
				I1:
					nextstate = S4;
				default:
					nextstate = S0;
			endcase
		S4:
			if (insert_sync1 == I0)
				nextstate = S4;
			else
				nextstate = S0;
	endcase
		
	assign pour_water_out = (state == S4) | (insert_sync1 == I5) | (state == S3) & (insert_sync1 == I2);
	
	assign change1_out = (state == S1) & (insert_sync1 == I5) | (state == S3) & (insert_sync1 == I5) | (state == S4) & (insert_sync1 == I2);
							
	assign change2_out = (state == S2) & (insert_sync1 == I5) | (state == S3) & (insert_sync1 == I5);
	
	assign change22_out = (state == S4) & (insert_sync1 == I5);
	
endmodule
	