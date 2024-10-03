/*
date: 2023.10.19
editor: Vincent Wang
title: Trailing Zeroes
description:

Prompt
Find the number of trailing 0s in the binary representation of the input (din). If the input value is all 0s, the number of trailing 0s is the data width (DATA_WIDTH)

Input and Output Signals
din - Input value
dout - Number of trailing 0s

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
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
  output logic [$clog2(DATA_WIDTH):0] dout
);
	wire [DATA_WIDTH-1:0] temp1, temp2;
	integer i;
	/*
	example:
		din:     10010100
		temp1:	 01101100
		temp2:   00000011 (3)
		
	example:
		din:     10010111
		temp1:	 01101001
		temp2:   00000000 (0)
		
	example:
		din:     10010110
		temp1:	 01101110
		temp2:   00000001 (1)
	*/
	assign temp1 = ~din + 1'b1;
	assign temp2 = ~(din | temp1);
	
	always @(*) begin
		dout = 'd0;
		for (i = 0;i < DATA_WIDTH; i = i + 1) begin
			dout = dout + temp2[i];
		end
	end
endmodule

/*
//ref

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

    logic [DATA_WIDTH-1:0] din_adj;
    logic [$clog2(DATA_WIDTH):0] idx;

    always_comb begin
				idx = 0;
				din_adj = din & (~din+1);
				for (int i=0; i<DATA_WIDTH; i++) begin
						idx += (din_adj[i]) ? i : 0;
				end
    end

    assign dout = (din_adj == 0 ? DATA_WIDTH : din_adj == 1 ? 0 : idx);

endmodule

*/

/*
//ref2

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);
	
	always @(*) begin
		dout = 0;
		for (int i = 0; i < DATA_WIDTH; i++) begin
			if (din[i])
				break;
			dout += 1;
		end
	end
endmodule
*/