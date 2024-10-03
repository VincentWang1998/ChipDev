/*
date: 2023.11.06
editor: Vincent Wang
title: Palindrome Detector
description:

Prompt
Given an input (din), output (dout) a 1 if its binary representation is a palindrome and a 0 otherwise.

A palindrome binary representation means that the binary representation has the same sequence of bits whether you read it from left to right or right to left. Leading 0s are considered part of the input binary representation.

Input and Output Signals
din - Input value
dout - 1 if the binary representation is a palindrome, 0 otherwise

module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

endmodule
*/

/*
Hint

*/

//  5bits: 11011
//  8bits: 10100101
//  9bits: 101010101
module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);
generate
	if(DATA_WIDTH == 1) begin
		// one-bit data is always palindrome
		assign dout = 1'b1;
	end
	else begin
		integer i,j; // i:MSB, j=LSB
		reg [(DATA_WIDTH>>1)-1:0] is_palindrome_flag; // The number of bits in 'is_palindrome_flag' is half the number of bits in 'din'.
		always @(*) begin
			j = 0; //LSB
			for(i = (DATA_WIDTH - 1); j < (DATA_WIDTH >> 1); i = i - 1) begin
				is_palindrome_flag[j] = (din[i] == din[j]) ? 1'b1 : 1'b0;
				j = j + 1;
			end
		end
		assign dout = (&is_palindrome_flag); // if is_palindrome_flag = 'b11...11 then dout = 1;
	end
endgenerate
endmodule


module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

    int i;
    logic is_palindrome;

    always @* begin
        is_palindrome = 1;
        for (i=0; i<DATA_WIDTH/2; i++) begin
            is_palindrome = (din[i] == din[DATA_WIDTH-1-i]) && is_palindrome;
        end
    end

    assign dout = is_palindrome;

endmodule
/*
//ref
module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

    int i;
    logic is_palindrome;

    always @* begin
        is_palindrome = 1;
        for (i=0; i<DATA_WIDTH/2; i++) begin
            is_palindrome = (din[i] == din[DATA_WIDTH-1-i]) && is_palindrome;
        end
    end

    assign dout = is_palindrome;

endmodule

*/
