/*
date: 2023.11.11
editor: Vincent Wang
title: Programmable Sequence Detector
description:

Prompt
Given a stream of input bits, pulse a 1 on the output (seen) whenever a specified 5-bit target sequence is detected on the input (din). The target sequence is specified by init and is updated whenever the reset-low signal (resetn) is deasserted.

The target sequence is always a 5-bit value, so left-padded 0's are also considered part of the sequence (a sequence specified as b11 would actually be b00011).

When resetn goes active, all previously seen bits on the input are no longer considered when searching for the target sequence.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
init - Target sequence to detect. Updated whenever resetn is asserted
din - Input bits
seen - 1 if the sequence specified by init was detected, 0 otherwise
Output signals during reset
seen - 0 when resetn is active

module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);

endmodule
*/

/*
Hint

*/

module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);

	parameter IDLE = 3'd0,
			  S1   = 3'd1,
			  S2   = 3'd2,
			  S3   = 3'd3,
			  S4   = 3'd4,
			  S5   = 3'd5;

	reg [2:0] state_cur, state_nxt;
	reg [4:0] init_reg, init_reg_nxt, init_gold;
	reg 	  init_flag, init_flag_nxt;
	
	always @(posedge clk) begin
		if(~resetn) begin 
			init_gold <= 'd0;
			init_reg  <= 'd0;
			init_flag <= 'd0;
		end
		else begin
			init_gold  <= ~init_flag ? init: init_gold;
			init_flag <= init_flag_nxt;
			init_reg  <= init_reg_nxt;
		end
	end
	
	// state transition logic
	always @(*) begin
		state_nxt    = state_cur;
		init_reg_nxt = init_reg;
		init_flag_nxt = resetn;
		case(state_cur)
			IDLE   : begin
				if(din == init[4] && init_flag_nxt && ~init_flag) begin
					init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else if(din == init_gold[4] && init_flag) begin
					init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S1     : begin
				// 10
				// 10
				if(din == init_gold[3]) begin
					init_reg_nxt[3] = din;
					state_nxt = S2;
				end
				// 01
				// 00
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S2     : begin
				// 101
				// 101
				if(din == init_gold[2]) begin
					init_reg_nxt[2] = din;
					state_nxt = S3;
				end
				// 001
				// 000
				else if({init_reg[3],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[3], din};
					state_nxt = S2;
				end
				// 100
				// 101
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S3     : begin
				// 1011
				// 1011
				if(din == init_gold[1]) begin
					init_reg_nxt[1] = din;
					state_nxt = S4;
				end
				// 1110
				// 1111
				else if({init_reg[3:2],din} == init_gold[4:2]) begin
					//init_reg_nxt[4:2] = {init_reg[4:3], din};
					state_nxt = S3;
				end
				// 1011
				// 1010
				else if({init_reg[2],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[2], din};
					state_nxt = S2;
				end
				// 1000
				// 1001
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S4     : begin
				// 11111
				// 11111
				if(din == init_gold[0]) begin
					init_reg_nxt[0] = din;
					state_nxt = S5;
				end
				// 00001
				// 00000
				else if({init_reg[3:1],din} == init_gold[4:1]) begin
					// init_reg_nxt[1] = din;
					state_nxt = S4;
				end
				// 01011
				// 01010
				else if({init_reg[2:1],din} == init_gold[4:2]) begin
					// init_reg_nxt[4:2] = {init_reg[4:3], din};
					state_nxt = S3;
				end
				// 11010
				// 11011
				else if({init_reg[1],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[2], din};
					state_nxt = S2;
				end
				// 10000
				// 10001
				else if(din == init_gold[4]) begin
					// init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S5     : begin
				if(din == init_gold[4]) begin
					init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			default: state_nxt = IDLE;
		endcase
	end
	
	// state register with synchronous reset
	always @(posedge clk) begin
		if(~resetn) begin
			state_cur <= IDLE;
		end
		else begin
			state_cur <= state_nxt;
		end
	end
	
	// output logic
	assign seen = (state_cur == S5);
endmodule

/* error
module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);

	parameter IDLE = 3'd0,
			  S1   = 3'd1,
			  S2   = 3'd2,
			  S3   = 3'd3,
			  S4   = 3'd4,
			  S5   = 3'd5;

	reg [2:0] state_cur, state_nxt;
	reg [4:0] init_reg, init_reg_nxt, init_gold;
	reg 	  init_flag;
	
	always @(posedge clk) begin
		if(~resetn) begin 
			init_gold <= 'd0;
			init_reg  <= 'd0;
			init_flag <= 'd0;
		end
		else begin
			init_gold  <= ~init_flag ? init: init_gold;
			init_flag <= 'd1;
			init_reg  <= init_reg_nxt;
		end
	end
	
	// state transition logic
	always @(*) begin
		state_nxt    = state_cur;
		init_reg_nxt = init_reg;
		case(state_cur)
			IDLE   : begin
				if(din == init_gold[4] && init_flag) begin
					init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S1     : begin
				// 10
				// 10
				if(din == init_gold[3]) begin
					init_reg_nxt[3] = din;
					state_nxt = S2;
				end
				// 01
				// 00
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S2     : begin
				// 101
				// 101
				if(din == init_gold[2]) begin
					init_reg_nxt[2] = din;
					state_nxt = S3;
				end
				// 001
				// 000
				else if({init_reg[3],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[3], din};
					state_nxt = S2;
				end
				// 100
				// 101
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S3     : begin
				// 1011
				// 1011
				if(din == init_gold[1]) begin
					init_reg_nxt[1] = din;
					state_nxt = S4;
				end
				// 1110
				// 1111
				else if({init_reg[3:2],din} == init_gold[4:2]) begin
					//init_reg_nxt[4:2] = {init_reg[4:3], din};
					state_nxt = S3;
				end
				// 1011
				// 1010
				else if({init_reg[2],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[2], din};
					state_nxt = S2;
				end
				// 1000
				// 1001
				else if(din == init_gold[4]) begin
					//init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S4     : begin
				// 11111
				// 11111
				if(din == init_gold[0]) begin
					init_reg_nxt[0] = din;
					state_nxt = S5;
				end
				// 00001
				// 00000
				else if({init_reg[3:1],din} == init_gold[4:1]) begin
					// init_reg_nxt[1] = din;
					state_nxt = S4;
				end
				// 01011
				// 01010
				else if({init_reg[2:1],din} == init_gold[4:2]) begin
					// init_reg_nxt[4:2] = {init_reg[4:3], din};
					state_nxt = S3;
				end
				// 11010
				// 11011
				else if({init_reg[1],din} == init_gold[4:3]) begin
					//init_reg_nxt[4:3] = {init_reg[2], din};
					state_nxt = S2;
				end
				// 10000
				// 10001
				else if(din == init_gold[4]) begin
					// init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			S5     : begin
				if(din == init_gold[4]) begin
					init_reg_nxt[4] = din;
					state_nxt = S1;
				end
				else begin
					state_nxt = IDLE;
				end
			end
			default: state_nxt = IDLE;
		endcase
	end
	
	// state register with synchronous reset
	always @(posedge clk) begin
		if(~resetn) begin
			state_cur <= IDLE;
		end
		else begin
			state_cur <= state_nxt;
		end
	end
	
	// output logic
	assign seen = (state_cur == S5);
endmodule
*/
/*
//ref

module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);

    logic [4:0] cur, len, target;
    logic reset_seen;

    always @(posedge clk) begin
        if (!resetn) begin
            reset_seen <= 1;
            cur <= 0;
            len <= 0;
        end else begin
            cur <= {cur[3:0], din};
            len <= (len < 5) ? len + 1 : len;
        end
    end

    assign target = (resetn && reset_seen && len == 0) ? init : target;
    assign seen = reset_seen && (cur == target) && (len == 5);

endmodule

*/
