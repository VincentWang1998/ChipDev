/*
date: 2023.10.18
editor: Vincent Wang
title: Gray Code Counter
description:

Prompt
Build a circuit that generates a Gray code sequence starting from 0 on the output (dout).

Gray code is an ordering of binary numbers such that two successive values only have one bit difference between them. For example, a Gray code sequence for a two bit value could be:

b00
b01
b11
b10

The Gray code sequence should use the standard encoding. In the standard encoding the least significant bit follows a repetitive pattern of 2 on, 2 off ( ... 11001100 ... ); the next digit a pattern of 4 on, 4 off ( ... 1111000011110000 ... ); the nth least significant bit a pattern of 2n on 2n off.

When the reset-low signal (resetn) goes to 0, the Gray code sequence should restart from 0.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
out - Gray code counter value
Output signals during reset
out - 0 when resetn is active


module model #(parameter
  DATA_WIDTH = 4
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 4
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);
	reg [DATA_WIDTH-1:0] bin;
	reg [DATA_WIDTH-1:0] gray;
	integer i;
	assign out = gray;
	
	always @(posedge clk) begin
		if(~resetn) begin
			bin  <= 'd0;
		end
		else begin
			bin <= bin + 1'b1;
		end
	end
	
	always @(*) begin
		gray[DATA_WIDTH-1] = bin[DATA_WIDTH-1];
		for(i=DATA_WIDTH-2;i >= 0;i = i - 1) begin
			gray[i] = bin[i] ^ bin[i+1];
		end
	end
endmodule


/*
//ref

module model #(parameter
  DATA_WIDTH = 4
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);

    logic [DATA_WIDTH-1:0] q, temp;

    always @ (posedge clk) begin
        if (!resetn) begin
            temp <= 0;
            q <= 1;
        end else begin
            q <= q + 1;

            for (int i = 0; i < DATA_WIDTH-1; i=i+1) begin
                temp[i] <= q[i+1] ^ q[i];
            end

            temp[DATA_WIDTH-1] <= q[DATA_WIDTH-1];
        end
    end

    assign out = temp;

endmodule

*/
