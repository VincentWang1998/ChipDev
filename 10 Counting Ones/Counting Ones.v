/*
date: 2023.10.19
editor: Vincent Wang
title: Counting Ones
description:

Prompt
Given an input binary value, output the number of bits that are equal to 1.

Input and Output Signals
din - Input value
dout - Number of 1's in the input value

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);
	
	reg [$clog2(DATA_WIDTH):0] sum;
	integer i;
	assign dout = sum;
	
	always @(*) begin
		sum = 'd0;
		for(i = 0; i < DATA_WIDTH;i=i+1) begin
			sum = sum + din[i];
		end
	end
endmodule

/*
//ref

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

    int i;
    logic [$clog2(DATA_WIDTH):0] temp;

    always @(*) begin
        temp = 0;
        for (i=0; i < DATA_WIDTH; i++) begin
            temp += din[i];
        end
    end

    assign dout = temp;

endmodule

*/
