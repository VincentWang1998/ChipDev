/*
date: 2023.10.24
editor: Vincent Wang
title: Divisible by 3
description:

Prompt
Design a circuit that determines whether an input value is evenly divisible by three.

The input value is of unknown length and is left-shifted one bit at a time into the circuit via the input (din). The circuit should output a 1 on the output (dout) if the current cumulative value is evenly divisible by three, and a 0 otherwise.

When resetn is asserted, all previous bits seen on the input are no longer considered. The 0 seen during reset should not be included when calculating the next value.

This problem is tricky, so it may help to think in terms of modulus and remainder states.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input bit
dout - 1 if the current value is divisible by 3, 0 otherwise.
Output signals during reset
dout - 0 when resetn is asserted

module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

endmodule
*/

/*
Hint

*/

//  3:  0011
//  6:  0110
//  9:  1001
// 12:  1100
// 15:  1111
// 18: 10010
// 21: 10101
// 24: 11000
// 27: 11011
// 30: 11110
// 33:100001

// FSM solution
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);
	parameter START = 2'd0,
			  MOD0  = 2'd1,
			  MOD1  = 2'd2,
			  MOD2  = 2'd3;
	reg [1:0] curr_state, next_state;
	
	// state transition logic
	always @(*) begin
		next_state = curr_state;
		case(curr_state)
			START   : next_state = din ? MOD1 : MOD0;
			MOD0    : next_state = din ? MOD1 : MOD0;
			MOD1    : next_state = din ? MOD0 : MOD2;
			MOD2    : next_state = din ? MOD2 : MOD1;
			default: next_state = START;
		endcase
	end
	
	// state flip-flops with synchronous reset
	always @(posedge clk) begin
		if(~resetn) begin
			curr_state <= START;
		end
		else begin
			curr_state <= next_state;
		end
	end
	
	// output logic
	assign dout = (curr_state == MOD0);
endmodule

// non-FSM solution1
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);
	reg mod0_flag, mod1_flag, mod2_flag;
	assign dout = mod0_flag;
	
	always @(posedge clk) begin
		if(~resetn) begin
			mod0_flag <= 1'b0;
			mod1_flag <= 1'b0;
			mod2_flag <= 1'b0;
		end
		else begin
			if(~mod0_flag & ~mod1_flag & ~mod2_flag) begin
				mod0_flag <= ~din;
				mod1_flag <= din;
			end
			else if(mod0_flag & ~mod1_flag & ~mod2_flag) begin
				mod0_flag <= ~din;
				mod1_flag <= din;
			end
			else if(~mod0_flag & mod1_flag & ~mod2_flag) begin
				mod0_flag <= din;
				mod1_flag <= 1'b0;
				mod2_flag <= ~din;
			end
			else if(~mod0_flag & ~mod1_flag & mod2_flag) begin
				mod1_flag <= ~din;
				mod2_flag <= din;
			end
		end
	end
endmodule

// non-FSM solution 2
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);
	/* reference from solution 1
		mod_flag[2]: mod 3 = 2
		mod_flag[1]: mod 3 = 1
		mod_flag[0]: mod 3 = 0
	*/
	reg [2:0] mod_flag;
	assign dout = mod_flag[0];
	
	always @(posedge clk) begin
		if(~resetn) begin
			mod_flag <= 3'b000;
		end
		else begin
			if(mod_flag == 3'b000) begin
				mod_flag <= (din) ? 3'b010 : 3'b001;
			end
			else if(mod_flag == 3'b001) begin
				mod_flag <= (din) ? 3'b010 : 3'b001;
			end
			else if(mod_flag == 3'b010) begin
				mod_flag <= (din) ? 3'b001 : 3'b100;
			end
			else if(mod_flag == 3'b100) begin
				mod_flag <= (din) ? 3'b100 : 3'b010;
			end
		end
	end
endmodule

/*
//ref

//Non-FSM solution
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

reg [2:0] curr_mod;
reg [2:0] prev_mod;

assign curr_mod = ((prev_mod << 1) + din) % 3;

always_ff @(posedge clk) begin
  if (!resetn) begin
    dout     <= 0;
    prev_mod <= 0;
  end else begin
    dout     <= (curr_mod == 0);
    prev_mod <= curr_mod;
  end
end

endmodule

*/
