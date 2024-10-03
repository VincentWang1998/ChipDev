/*
date: 2023.10.19
editor: Vincent Wang
title: Gray Code to Binary
description:

Prompt
Given a value, output its index in the standard Gray code sequence. This is known as converting a Gray code value to binary.

Each input value's binary representation is an element in the Gray code sequence, and your circuit should output the index of the Gray code sequence the input value corresponds to.

In the standard encoding the least significant bit follows a repetitive pattern of 2 on, 2 off ( ... 11001100 ... ); the next digit a pattern of 4 on, 4 off ( ... 1111000011110000 ... ); the nth least significant bit a pattern of 2n on 2n off.

Input and Output Signals
gray - Input signal, interpreted as an element of the Gray code sequence
bin - Index of the Gray code sequence the input corresponds to

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] gray,
  output logic [DATA_WIDTH-1:0] bin
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] gray,
  output logic [DATA_WIDTH-1:0] bin
);
	//assign bin[DATA_WIDTH-1] = gray[DATA_WIDTH-1];
	genvar i;
	generate 
		for (i = DATA_WIDTH-1; i >= 0; i = i - 1) begin
			assign bin[i] = ^(gray[DATA_WIDTH-1:i]);
		end
	endgenerate
endmodule

/*
//ref

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] gray,
  output logic [DATA_WIDTH-1:0] bin
);

    int i;
    logic [DATA_WIDTH-1:0] temp;

    always @(*) begin
        for(i=0; i<DATA_WIDTH; i++) begin
            temp[i] = ^(gray >> i);
        end
    end

    assign bin = temp;

endmodule

*/
