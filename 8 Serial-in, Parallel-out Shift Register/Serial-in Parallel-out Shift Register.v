/*
date: 2023.10.19
editor: Vincent Wang
title: Serial-in, Parallel-out Shift Register
description:

Prompt
Build a circuit that reads a sequence of bits (one bit per clock cycle) from the input (din), and shifts the bits into the least significant bit of the output (dout). Assume all bits of the output are 0 to begin with.

Once the number of input bits received is larger than DATA_WIDTH, only the DATA_WIDTH most recent bits are kept in the output.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input signal
dout - Output signal
Output signals during reset
dout - 0 when resetn is active

module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input din,
  output logic [DATA_WIDTH-1:0] dout
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input din,
  output logic [DATA_WIDTH-1:0] dout
);
	reg [DATA_WIDTH-1:0] buffer;
	
	integer i;
	assign dout = buffer;
	
	always @(posedge clk) begin
		if(~resetn) begin
			buffer <= 'd0;
		end
		else begin
			//buffer <= {buffer[DATA_WIDTH-2:1], din};
			buffer[0] <= din;
			for(i = 1; i < DATA_WIDTH; i = i + 1) begin
				buffer[i] <= buffer[i-1];
			end
		end
	end
endmodule

/*
//ref

module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input din,
  output logic [DATA_WIDTH-1:0] dout
);

    logic [DATA_WIDTH-1:0] temp;

    always @ (posedge clk) begin
        if (!resetn) begin
            temp <= 0;
        end else begin
            temp <= (temp << 1) + din;
        end
    end

    assign dout = temp;

endmodule

*/
