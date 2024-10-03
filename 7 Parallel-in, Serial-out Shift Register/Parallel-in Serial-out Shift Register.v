/*
date: 2023.10.19
editor: Vincent Wang
title: Parallel-in, Serial-out Shift Register
description:

Prompt
Build a circuit that takes the multi-bit input (din) and shifts the input value’s least significant bit (rightmost bit) to the single-bit output (dout) one bit at a time.

The circuit should begin shifting the input’s least significant bit when the the input enable signal (din_en) goes high. In other words, the input enable signal going high indicates that this circuit should start shifting the current input signal from it’s least significant bit, regardless of which bits the circuit has already shifted.

If all the input’s bits have been shifted to the output so that there are no more bits to shift, the output must output 0.

When reset (resetn) is active, the input value that is being shifted is treated as 0. Even when reset goes back to being inactive, the input value will still be treated as 0, unless the input enable signal makes the circuit begin shifting from the input again.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input signal
din_en - Enable signal for input data
dout - Output signal
Output signals during reset
dout - 0 when resetn is active


module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout
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
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout
);

	reg [DATA_WIDTH-1:0] din_reg;
	
	always @(posedge clk) begin
		if(~resetn) begin
			din_reg <= 'd0;
		end
		else begin
			if(din_en) begin
				din_reg <= din;
			end
			else begin
				din_reg <= din_reg >> 1;
			end
		end
	end
	assign dout = din_reg[0];
endmodule


/*
//ref

module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout
);

    logic [DATA_WIDTH-1:0] temp;

    always @(posedge clk) begin
        if (!resetn) begin
            temp <= 0;
        end else if (din_en) begin
            temp <= din;
        end else begin
            temp <= temp >> 1;
        end
     end

    assign dout = temp[0];

endmodule

*/
