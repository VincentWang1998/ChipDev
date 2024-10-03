/*
date: 2023.10.18
editor: Vincent Wang
title: Rounding Division
description:

Prompt
Divide an input number by a power of two and round the result to the nearest integer. The power of two is calculated using 2DIV_LOG2 where DIV_LOG2 is a module parameter. Remainders of 0.5 or greater should be rounded up to the nearest integer. If the output were to overflow, then the result should be saturated instead.

Input and Output Signals
din - Input number
dout - Rounded result


module model #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

	reg [OUT_WIDTH-1:0]  ratio_num;
	reg [DIV_LOG2-1:0]   remainder_num;
	
	always @(*) begin
		ratio_num     = din[IN_WIDTH-1:DIV_LOG2];
		remainder_num = din[DIV_LOG2-1:0];
	end
	
	// if MSB of remainder_num == 1 then dout = ratio_num + 1
	// use "~(&ratio_num)" to avoid overflow
	assign dout = (remainder_num[DIV_LOG2-1] && ~(&ratio_num)) ? ratio_num + 1'd1 : ratio_num;
	
	// This will be wrong
	// assign dout = (remainder_num[DIV_LOG2-1]) ? ratio_num + 1'd1 : ratio_num;
endmodule

/*
//ref


*/
