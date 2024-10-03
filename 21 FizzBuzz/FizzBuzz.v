/*
date: 2024.09.13
editor: Vincent Wang
title: FizzBuzz
*/


// Prompt
/*
Design a circuit that counts incrementally for a maximum number of cycles, MAX_CYCLES.   At all cycles, the circuit should determine whether or not the counter value is evenly divisible by parameters FIZZ, BUZZ, or both.  

The counter value should monotonically increase when the reset signal (resetn) is de-asserted. The counter sequence is expected to start from 0 and be MAX_CYCLES long, restarting from 0 when MAX_CYCLES is reached (e.g. for MAX_CYCLES = 100:  0, 1, 2, 3, ..., 99, 0, 1, ...).

As the circuit counts, output fizz should be asserted if the current counter value is evenly divisible by FIZZ.  buzz should output 1 when the current counter value is divisible by BUZZ.  Finally, output fizzbuzz should be 1 when counter is evenly divisible by both FIZZ and BUZZ. 

Input and Output Signals
clk - Clock signal
resetn - Synchronous, active low, reset signal
fizz - Output Fizz
buzz - Output Buzz
fizzbuzz - Output FizzBuzz

Output signals during reset
fizz - 1
buzz - 1
fizzbuzz - 1
*/


// Example
/*
Assume FIZZ = 2,  BUZZ = 3,  MAX_CYCLES = 8 in this example.

We need to define a counter (accumulator) that can count from zero to MAX_CYCLES = 8.  We only begin counting when resetn goes high as reset is active-low and gets de-asserted in order to start.

Once your counter is working properly (i.e., counter value goes 0, 1, 2, 3, ..., MAX_CYCLES-1, 0, 1, 2, ...), the next step is to test whether the counter value is evenly divisible by FIZZ, BUZZ, or both.  To do that, we can use modulo operation in a combination logic block or assign statement.  The respective outputs, fizz, buzz, and fizzbuzz are de-/asserted dependending on the test results.

In this example, the expected results are the following, assuming the circuit reset correctly:
counter = 0:   fizz = 1, buzz = 1, fizzbuzz = 1
counter = 1:   fizz = 0, buzz = 0, fizzbuzz = 0
counter = 2:   fizz = 1, buzz = 0, fizzbuzz = 0
counter = 3:   fizz = 0, buzz = 1, fizzbuzz = 0
counter = 4:   fizz = 1, buzz = 0, fizzbuzz = 0
counter = 5:   fizz = 0, buzz = 0, fizzbuzz = 0
counter = 6:   fizz = 1, buzz = 1, fizzbuzz = 1
counter = 7:   fizz = 0, buzz = 0, fizzbuzz = 0
counter = 0:   fizz = 1, buzz = 1, fizzbuzz = 1

*/

// template
/*
module model #(parameter
    FIZZ=3,
    BUZZ=5,
    MAX_CYCLES=100
) (
    input clk,
    input resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);

endmodule
*/

module model #(parameter
    FIZZ=3,
    BUZZ=5,
    MAX_CYCLES=100
) (
    input clk,
    input resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);
	parameter FIZZBUZZ = (BUZZ >= FIZZ) ? ((BUZZ % FIZZ == 0) ? BUZZ : BUZZ*FIZZ)
	                                    : ((FIZZ % BUZZ == 0) ? FIZZ : BUZZ*FIZZ);
	logic [$clog2(MAX_CYCLES)-1:0] cnt         , cnt_nxt         ;
	logic [$clog2(      FIZZ)-1:0] cnt_fizz    , cnt_fizz_nxt    ;
	logic [$clog2(      BUZZ)-1:0] cnt_buzz    , cnt_buzz_nxt    ;
	logic [$clog2(  FIZZBUZZ)-1:0] cnt_fizzbuzz, cnt_fizzbuzz_nxt;
	
	always_ff @(posedge clk) begin
		if (~resetn) begin
			fizz     <= 1'b1;
			buzz     <= 1'b1;
			fizzbuzz <= 1'b1;
		end else begin
			fizz     <= (cnt_fizz_nxt     == 'd0) ? 1'b1 : 1'b0;
			buzz     <= (cnt_buzz_nxt     == 'd0) ? 1'b1 : 1'b0;
			fizzbuzz <= (cnt_fizzbuzz_nxt == 'd0) ? 1'b1 : 1'b0;
		end
	end
	
	always_ff @(posedge clk) begin
		if (~resetn) begin
			cnt          <= 'd0;
			cnt_fizz     <= 'd0;
			cnt_buzz     <= 'd0;
			cnt_fizzbuzz <= 'd0;
		end else begin
			cnt          <= cnt_nxt         ;
			cnt_fizz     <= cnt_fizz_nxt    ;
			cnt_buzz     <= cnt_buzz_nxt    ;
			cnt_fizzbuzz <= cnt_fizzbuzz_nxt;
		end
	end
	
	always_comb begin
		if ( (cnt == (MAX_CYCLES-1)) ) begin
			cnt_nxt = 0;
		end else begin
			cnt_nxt = cnt + 1;
		end
		
		if ( (cnt == (MAX_CYCLES-1)) || (cnt_fizz == (FIZZ-1)) ) begin
			cnt_fizz_nxt = 0;
		end else begin
			cnt_fizz_nxt = cnt_fizz + 1;
		end
		
		if ( (cnt == (MAX_CYCLES-1)) || (cnt_buzz == (BUZZ-1)) ) begin
			cnt_buzz_nxt = 0;
		end else begin
			cnt_buzz_nxt = cnt_buzz + 1;
		end
		
		if ( (cnt == (MAX_CYCLES-1)) || (cnt_fizzbuzz == (FIZZBUZZ-1)) ) begin
			cnt_fizzbuzz_nxt = 0;
		end else begin
			cnt_fizzbuzz_nxt = cnt_fizzbuzz + 1;
		end
	end
endmodule

// Example Solution:
/*
module model #(parameter
    FIZZ=3,
    BUZZ=5,
    MAX_CYCLES=100
) (
    input clk,
    input resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);
    logic [$clog2(MAX_CYCLES)-1:0] counter;
    logic [$clog2(FIZZ)-1:0] fizz_cnt;
    logic [$clog2(BUZZ)-1:0] buzz_cnt;

    always @(posedge clk) begin
        if (!resetn || counter >= MAX_CYCLES-1) begin
            counter <= 0;
            fizz_cnt <= 0;
            buzz_cnt <= 0;
        end else begin
            counter <= counter + 1;
            fizz_cnt <= (fizz_cnt == FIZZ-1) ? 0 : fizz_cnt + 1;
            buzz_cnt <= (buzz_cnt == BUZZ-1) ? 0 : buzz_cnt + 1;
        end
    end

    assign fizz = (fizz_cnt == 0);
    assign buzz = (buzz_cnt == 0);
    assign fizzbuzz = (fizz_cnt == 0) && (buzz_cnt == 0);

endmodule
*/