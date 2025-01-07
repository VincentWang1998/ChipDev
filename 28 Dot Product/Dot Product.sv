// 28. Dot Product

/*
Prompt
In this question, implement a module that produces the dot product (scalar product) of two equal-length, single dimensional vectors, A = [a1, a2, a3] and B = [b1, b2, b3].  The module has one 8-bit port, din, that is used for entering the input sequences of numbers.  It also has two outputs, run, and dout, which return computation status and dot product of the inputs, respectively.

Assume the sequence is read in the following order: a1, a2, a3, b1, b2, b3.  A counter can be used to keep track of the sequence of numbers.  Once the 6th number has been registered, output run is asserted, and output dout returns a scalar 18-b unsigned number corresponding to the dot product of the inputs.  In the next cycles, run is de-asserted whereas dout sustains its previous valid value til the next six numbers of input vectors A and B are entered.  At any rising edge of clk, if resetn is logic low, then zero is written to the module's internal registers.  When resetn transitions back from zero to one, run is asserted and dout is produces zero as A · B = 0.

Input and Output Signals
din - 8-bit unsigned data input word
clk - Clock signal
resetn - Synchronous, active low, reset signal
dout - Output word corresponding to a dot b operation
run - Single-bit output signal to indicate a new dot product operation
Output signals during reset
dout - 0
run - 1
*/

// example
/*
Initially, vectors A = [1, 2, 3] and B = [4, 5, 6].  As run is a combinational output that depends on the module's internal counter, when resetn = 0, run = 1, and dout = 0.  Right after resetn transitions from zero to one, the module's internal starts and the sequence of numbers corresponding to inputs A and B is captured.  After 6 entries, the output dout produces the dot product of the inputs.  Output run is asserted at the same cycle dout switches to indicate a new output is produced.  dout is maintained til the next dot product operation is complete.
*/

// template
/*
module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);

endmodule
*/

/**/
/**/
/**/
/**/



module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);
	logic [7:0] mem [0:5];
	logic [15:0] a1b1, a2b2, a3b3;
	logic [2:0] cnt;
	logic [17:0] dout_reg, dout_next;
	
	always_ff @(posedge clk) begin
		if(~resetn) begin
			for(int i = 0; i <= 5; i++) begin
				mem[i] <= 'd0;
			end
		end else begin
			mem[cnt] <= din;
		end
	end
	
	always_ff @(posedge clk) begin
		if(~resetn) begin
			cnt <= 'd0;
		end else begin
			cnt = (cnt == 'd5) ? 'd0 : cnt + 'd1;
		end
	end
	
	always_ff @(posedge clk) begin
		if(~resetn) begin
			dout_reg <= 'd0;
		end else begin
			dout_reg = dout_next;
		end
	end
	
	always_comb begin
		run  = (cnt == 'd0);
		a1b1 = mem[0]*mem[3];
		a2b2 = mem[1]*mem[4];
		a3b3 = mem[2]*mem[5];
		dout_next = (run) ? a1b1 + a2b2 + a3b3 : dout_reg;
		dout = dout_next;
	end
endmodule

/*
// state machine

module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);
	logic [7:0] a1_reg, a2_reg, a3_reg;
	logic [7:0] b1_reg, b2_reg, b3_reg;
	logic [17:0] dout_reg;
	
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
	
	always_ff @(posedge clk) begin
		if(~resetn) begin
			current_state <= S_RESET;
		end else begin
			current_state <= next_state;
		end
	end
	
	always_comb begin
		next_state = current_state;
		dout = dout_reg;
		case (current_state)
			S_RESET: begin
				next_state = S_A1;
				run  =  1'b1;
				dout = 18'd0;
			end
			S_A1: begin
				next_state = S_A2;
				run  =  1'b0;
			end
			S_A2: begin
				next_state = S_A3;
				run  =  1'b0;
			end
			S_A3: begin
				next_state = S_B1;
				run  =  1'b0;
			end
			S_B1: begin
				next_state = S_B2;
				run  =  1'b0;
			end
			S_B2: begin
				next_state = S_B3;
				run  =  1'b0;
			end
			S_B3: begin
				next_state = S_A1;
				dout = (a1_reg*b1_reg) + (a2_reg*b2_reg) + (a3_reg*b3_reg);
				run  =  1'b1;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(~resetn) begin
			{a1_reg, a2_reg, a3_reg} <= 'd0;
			{b1_reg, b2_reg, b3_reg} <= 'd0;
			dout_reg <= 'd0;
		end else begin
			dout_reg <= dout;
			case (current_state)
				S_RESET: begin
					a1_reg <= (~resetn) ? 'd0 : din;
					a2_reg <= 'd0;
					a3_reg <= 'd0;
					b1_reg <= 'd0;
					b2_reg <= 'd0;
					b3_reg <= 'd0;
				end
				S_A1: begin
					a2_reg <= din;
				end
				S_A2: begin
					a3_reg <= din;
				end
				S_A3: begin
					b1_reg <= din;
				end
				S_B1: begin
					b2_reg <= din;
				end
				S_B2: begin
					b3_reg <= din;
				end
				S_B3: begin
					a1_reg <= din;
				end
			endcase
		end
	end
endmodule
*/


// ref solution
/*
module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);

    // Let's keep track of the required number of bits after each mult and add operation
    // Assuming vector A = [a1, a2, a3], and vector B = [b1, b2, b3]
    // a1 * b1 = 16-b
    // a2 * b2 = 16-b
    // a3 * b3 = 16-b
    // a1b1 + a2b2 + a3b3 = 18-b

    reg [2:0] cnt;
    reg [7:0] mem [5:0];
    reg [15:0] a1b1, a2b2, a3b3;

    // A 3-bit counter is used to track the number of inputs
    always_ff @(posedge clk) begin
        if (!resetn || cnt == 5) begin
            cnt <= 0;
        end else begin 
            cnt <= cnt + 1;
        end
    end

    // Internal memory
    always_ff @(posedge clk) begin
        if (!resetn) begin
            mem[0] <= 0;
            mem[1] <= 0;
            mem[2] <= 0;
            mem[3] <= 0;
            mem[4] <= 0;
            mem[5] <= 0;
        end else begin
            mem[cnt] <= din;
        end
    end

    // Combinational logic
    assign run = (cnt == 0);
    assign a1b1 = (run) ? mem[0] * mem[3] : a1b1;
    assign a2b2 = (run) ? mem[1] * mem[4] : a2b2;
    assign a3b3 = (run) ? mem[2] * mem[5] : a3b3;
    assign dout = a1b1 + a2b2 + a3b3;

endmodule
*/

