// 29. Binary to Thermometer Decoder

/*
Prompt
Thermometer (a.k.a. unary) coding is frequently used in digital systems applications to represent a natural number.  In a thermometer code, a N-bit binary number is represented by a (2 ** N)-bit digital word, which has m zeros followed by (N - m) ones or vice-versa.

In this question, implement a binary to thermometer decoder circuit using Verilog.  The input, din, is an 8-bit unsigned binary word, and the output dout is the thermometer code representation of the input at any time. The output is 256-bit long;  dout has m zeros followed by (256 - m) ones.

Input and Output Signals
din - Binary, unsigned input word
dout - Thermometer output word
*/

// example
/*
The example below shows a sequence of 8-bit binary inputs and their respectives thermometer codes.  Note that when din = 8'b0000_0000, the thermometer representation has a single one at the least significant bit (LSB) position (select dout and change the radix from Hex to Bin in order to better visualize it).


*/

// template
/*
module model (
    input [7:0] din,
    output reg [255:0] dout
);

endmodule
*/

/**/
/**/
/**/
/**/

/*
input num (8-bit) -> output binery (256-bit)
0   -> 00..0001
1   -> 00..0011
2   -> 00..0111
254 -> 01..1111
255 -> 11..1111
*/

module model (
    input [7:0] din,
    output reg [255:0] dout
);
	reg [0:255] bit_enable;
	integer i;
	always @(*) begin
		for (i = 0; i < 256; i++) begin
			if (i <= din)
				bit_enable[i] = 1'b1;
			else
				bit_enable[i] = 1'b0;
		end
	end
	
	always @(*) begin
		for (i = 0; i < 256; i++) begin
			dout[i] = bit_enable[i];
		end
	end
endmodule

/*
typedef enum int {
		S_RESET
	   ,S_A1    // a1 received
	   ,S_A2
	   ,S_A3
	   ,S_B1
	   ,S_B2
	   ,S_B3    // b3 received and output dot product and assert run
	} state_t;
	state_t current_state, next_state;
*/

// ref solution
/*
module model (
    input [7:0] din,
    output reg [255:0] dout
);

    parameter DIN_WIDTH = 8;

    reg [2**DIN_WIDTH-1:0] temp [2**DIN_WIDTH-1:0];

    // Calculates the thermometer code given a binary input
    genvar i;
    generate
        for (i = 0; i < 2**DIN_WIDTH; i++) begin
            assign temp[i] = (din == i) ? {{2**DIN_WIDTH-1-i{1'b0}}, {i+1{1'b1}}} : {2**DIN_WIDTH{1'b0}};
        end
    endgenerate

    // Output mux
    assign dout = temp[din];

endmodule
*/

