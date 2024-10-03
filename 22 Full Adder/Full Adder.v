/*
date: 2024.09.19
editor: Vincent Wang
title: Full Adder
*/


// Prompt
/*
Design a Full Adder (FA)—the most important building block for digital computation.

A FA is a fully combinational circuit that adds three single-bit inputs a, b, and cin (carry-in).  Inputs a and b are the two operands whereas cin represents the overflow bit carried forward from a previous addition stage.

The FA circuit has two single-bit outputs, sum and cout—the later represents the overflow bit to be used as a carry-in to a subsequent addition stage.

Input and Output Signals
a - First operand input bit
b - Second operand input bit
cin - Carry-in input bit from a previous adder stage
sum - Sum output bit
cout - Carry-out (overflow) output bit to be propagated to the next addition stage
*/


// Example
/*
The outputs sum and cout are initially 0 because a = b = cin = 0.  Next, a = b = 1, and cin = 0, which adds up to 2, represented as {cout, sum} = 2'b10.  Finally, when a = b = cin = 1, the result becomes 3, that is, the FA produces outputs {cout, sum} = 2'b11.
*/

// template
/*
module model (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);

endmodule
*/

module model (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);
	assign {cout, sum} = a + b + cin;
endmodule

// Example Solution:
/*
module model (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);
    assign sum = a^b^cin;
    assign cout = a&b || a&cin || b&cin;
endmodule
*/