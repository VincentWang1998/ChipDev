/*
date: 2023.10.20
editor: Vincent Wang
title: One-Hot Detector
description:

Prompt
One-hot values have a single bit that is a 1 with all other bits being 0. Output a 1 if the input (din) is a one-hot value, and output a 0 otherwise.

Input and Output Signals
din - Input value
onehot - 1 if the input is a one-hot value and 0 otherwise

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);

endmodule
*/

/*
Hint

*/
module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);
	// ex1: 0100_1000
	// ex2: 1011_0111
	// ex3: 1011_1000
	
	// ex4: 0001_0000
	// ex5: 1110_1111
	// ex6: 1111_0000
	
	// ex7: 0000_0000
	// ex8: 1111_1111
	// ex9: 0000_0000
	wire [DATA_WIDTH-1:0] temp1, temp2;
	
	assign temp1 = (~din) + 1'b1;
	assign temp2 = temp1 & din;
	assign onehot = (temp2 == din) & (din != 'd0);
	
endmodule

/*
//ref excellent

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);
	assign onehot = (din) && !(din & (din - 1));
endmodule
*/

/*
//ref

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);

    int i;
    logic [DATA_WIDTH-1:0] num_ones;

    always @(*) begin
        num_ones = 0;
        for (i=0; i < DATA_WIDTH; i++) begin
            num_ones += din[i];
        end
    end

    assign onehot = (num_ones == 1);

endmodule

*/
