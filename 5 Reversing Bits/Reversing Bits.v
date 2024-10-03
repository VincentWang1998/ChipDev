/*
date: 2023.10.18
editor: Vincent Wang
title: Reversing Bits
description:

Prompt
Reverse the bits of an input value's binary representation.

Input and Output Signals
din - Input value
dout - Bitwise reversed value


module model #(parameter
  DATA_WIDTH=32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH=32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);
	genvar i;
	generate
		for (i=0;i < DATA_WIDTH;i = i + 1) begin: inverse
			assign dout[i] = din[DATA_WIDTH-1-i];
		end
	endgenerate
endmodule


/*
//ref

module model #(parameter
  DATA_WIDTH=32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);
	assign dout = {<<{din}};
endmodule


*/

/*
//ref2

module model #(parameter
  DATA_WIDTH=32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

    int i;
    logic [DATA_WIDTH-1:0] reversed;

    always @* begin
        for (i=0; i<DATA_WIDTH; i++) begin
            reversed[i] = din[DATA_WIDTH-1 - i];
        end
    end

    assign dout = reversed;

endmodule

*/