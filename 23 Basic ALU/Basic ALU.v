/*
date: 2024.09.20
editor: Vincent Wang
title: Basic ALU (Introduction to Verilog)
*/


// Prompt
/*
Design a simple Arithmetic Logic Unit (ALU) which performs a set of operations on two input operands a and b. The outputs of each operation are sent to the corresponding output signal - a_plus_b, a_minus_b, not_a, a_and_b, a_or_b, and a_xor_b.

The ALU is an important part of many modern computing systems. Conventional ALUs receive two operands from an external control unit, as well as an opcode which determines the type of calculation to perform. For this question, we've simplified the behavior such that the ALU produces all outputs at once.

Input and Output Signals
a - First operand input
b - Second operand input
a_plus_b - Output a plus b
a_minus_b - Output a minus b
not_a - Output not a (ones complement)
a_and_b - Output a bitwise-and b
a_or_b - Output a bitwise-or b
a_xor_b - Output a exclusive-or b
*/


// Example
/*

*/

// template
/*
module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] a,
  input  [DATA_WIDTH-1:0] b,
  output logic [DATA_WIDTH-1:0] a_plus_b,
  output logic [DATA_WIDTH-1:0] a_minus_b,
  output logic [DATA_WIDTH-1:0] not_a,
  output logic [DATA_WIDTH-1:0] a_and_b,
  output logic [DATA_WIDTH-1:0] a_or_b,
  output logic [DATA_WIDTH-1:0] a_xor_b
);

endmodule
*/

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] a,
  input  [DATA_WIDTH-1:0] b,
  output logic [DATA_WIDTH-1:0] a_plus_b,
  output logic [DATA_WIDTH-1:0] a_minus_b,
  output logic [DATA_WIDTH-1:0] not_a,
  output logic [DATA_WIDTH-1:0] a_and_b,
  output logic [DATA_WIDTH-1:0] a_or_b,
  output logic [DATA_WIDTH-1:0] a_xor_b
);
	assign a_plus_b  = a + b;
	assign a_minus_b = a - b;
	assign not_a     = ~a   ;
	assign a_and_b   = a & b;
	assign a_or_b    = a | b;
	assign a_xor_b   = a ^ b;
endmodule

// Example Solution:
/*
module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] a,
  input  [DATA_WIDTH-1:0] b,
  output logic [DATA_WIDTH-1:0] a_plus_b,
  output logic [DATA_WIDTH-1:0] a_minus_b,
  output logic [DATA_WIDTH-1:0] not_a,
  output logic [DATA_WIDTH-1:0] a_and_b,
  output logic [DATA_WIDTH-1:0] a_or_b,
  output logic [DATA_WIDTH-1:0] a_xor_b
);

    assign a_plus_b = a + b;
    assign a_minus_b = a - b;
    assign not_a = ~a;
    assign a_and_b = a & b;
    assign a_or_b = a | b;
    assign a_xor_b = a ^ b;

endmodule
*/