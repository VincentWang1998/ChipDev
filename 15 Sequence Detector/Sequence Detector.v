/*
date: 2023.10.24
editor: Vincent Wang
title: Sequence Detector
description:

Prompt
Given a stream of input bits, pulse a 1 on the output (dout) whenever a b1010 sequence is detected on the input (din).

When the reset-low signal (resetn) goes active, all previously seen bits on the input are no longer considered when searching for b1010.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input bits
dout - 1 if a b1010 was detected, 0 otherwise
Output signals during reset
dout - 0 when resetn is active

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

module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);
	parameter IDLE = 3'd0,
			  S1   = 3'd1,
			  S10  = 3'd2,
			  S101 = 3'd3,
			  S1010= 3'd4;
			  
	reg [2:0] curr_state, next_state;
	
	// state transition logic
	always @(*) begin
		next_state = curr_state;
		case(curr_state)
			IDLE   : next_state = din ? S1   : IDLE;
			S1     : next_state = din ? S1   : S10;
			S10    : next_state = din ? S101 : IDLE;
			S101   : next_state = din ? S1   : S1010;
			S1010  : next_state = din ? S101 : IDLE;
			default: next_state = IDLE;
		endcase
	end
	
	// state flip-flops with synchronous reset
	always @(posedge clk) begin
		if(~resetn) begin
			curr_state <= IDLE;
		end
		else begin
			curr_state <= next_state;
		end
	end
	
	// output logic
	assign dout = (curr_state == S1010);
endmodule

/*
//ref

reg [3:0] seq_det;

always @ (posedge clk)
begin
  if(!resetn)
    seq_det <= 'd0;
  else
    seq_det <= {seq_det[2:0], din};
end

assign dout = (seq_det == 4'b1010);

*/
