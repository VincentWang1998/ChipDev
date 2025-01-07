// 26. Multi-Bit FIFO

/*
Prompt
Design a multi-bit First In First Out (FIFO) circuit.  The FIFO includes two entries of size DATA_WIDTH and requires zero output latency. 

Upon assertion of resetn (active-low), the FIFO is reset to zero and the empty signal is set to logic high to indicate the FIFO is empty.  Once resetn is unpressed, the operation starts.  The FIFO has a two-entry bank of flip-flops that can be written to by using inputs din (data in) and wr (write-enable).  If wr is set to logic low, the input din does not get written to the FIFO.

As the FIFO is being written to, its output port dout should imediatelly reflect the first-in data, i.e., there should be no latency between inputs and outputs.  Once all entries are written to, the FIFO should output full = 1 in order to indicate it is full.  Writing to a full FIFO is a valid operation and the output full must be set to one.

Important
There are at least three possible states in this design:  (1) Empty;  (2) Intermediate;  (3) Full.  Whenever the FIFO is reset, it transitions to state (1).  As the entries are updated, the state switches from (1) to (2), and finally from (2) to (3), once completely filled.  Use a mux to direct the intermediate stages of the FIFO to the output port dout to achieve a low latency design.


Input and Output Signals
clk - Clock signal
resetn - Active-low, reset signal
din - FIFO input data
wr - Active-high, write signal
dout - FIFO output data
full - Full FIFO indicator
empty - Empty FIFO indicator
Output signals during reset
dout - 0
full - 0
empty - 1
*/

// example
/*
Initially, resetn = 0 and the FIFO entries are reset.  Output dout is set to zero, and empty is set to one to indicate the FIFO is empty.  Reset signal is deasserted and the operation starts.  The second cycle has wr = 0, therefore din is not registered.  The subsquent cycle has wr = 1 thus din = 25'h105c5cc.  Output dout immediately shows the first-in data, with no latency between inputs and outputs.  Write-enable signal is asserted a few cycles later to capture another input, completely filling the FIFO.  Output full is then set to logic one.  Subsequent operations occur in a full FIFO.
*/

// template
/*
module model #(parameter
    DATA_WIDTH=8
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input wr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);

endmodule
*/

/**/
/**/
/**/
/**/

module model #(parameter
    DATA_WIDTH=8
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input wr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);
	parameter NUM_ENTRY = 2;
	logic [DATA_WIDTH-1:0] mem [0:NUM_ENTRY-1];
	logic [$clog2(NUM_ENTRY)-1:0] wr_ptr;
	logic [$clog2(NUM_ENTRY)-1:0] rd_ptr;
	
	typedef enum int {
		S_EMPTY
	   ,S_INTM
	   ,S_FULL
	} state_t;
	
	state_t current_state, next_state;
	
	always @(posedge clk) begin
		if (~resetn) begin
			for (int i = 0; i < NUM_ENTRY; i++) begin
				mem[i] <= 'd0;
			end
		end else begin
			if (wr)
				mem[wr_ptr] <= din; 
		end
	end

	always @(posedge clk) begin
		if (~resetn) begin
			wr_ptr <= 'd0;
		end else begin
			if (wr)
				wr_ptr <= wr_ptr + 'd1; 
		end
	end
	
	always @(posedge clk) begin
		if (~resetn) begin
			rd_ptr <= 'd0;
		end else begin
			if (wr && (current_state == S_FULL))
				rd_ptr <= rd_ptr + 'd1; 
		end
	end
	
	always @(posedge clk) begin
		if (~resetn) begin
			current_state <= 'd0;
		end else begin
			current_state <= next_state;
		end
	end
	
	always @(*) begin
		next_state = current_state;
		case (current_state)
			S_EMPTY: begin
				empty = 'd1;
				full  = 'd0;
				dout  = 'd0;
				next_state = (wr) ? S_INTM : S_EMPTY;
			end
			S_INTM: begin
				empty = 'd0;
				full  = 'd0;
				dout  = mem[0];
				next_state = (wr && (&wr_ptr)) ? S_FULL : S_INTM;
			end
			S_FULL: begin
				empty = 'd0;
				full  = 'd1;
				dout  = mem[rd_ptr];
				next_state = S_FULL;
			end
		endcase
	end
endmodule


// ref solution
/*
module model #(parameter
    DATA_WIDTH=8
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input wr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);

//    Solution by Matt Johnson - thank you!


    localparam FIFO_DEPTH = 2;

    logic [DATA_WIDTH-1:0] fifo [FIFO_DEPTH-1:0];
    logic [$clog2(FIFO_DEPTH):0] wr_count;

    always @(posedge clk)
    begin
        if (!resetn)
        begin
            wr_count <= '0;
            fifo[0]  <= '0;
        end
        else if (wr)
        begin
            fifo[0] <= din;
            for (int i=1; i < FIFO_DEPTH; i++) begin
                fifo[i] <= fifo[i-1];
            end
            if (wr_count != FIFO_DEPTH)
                wr_count <= wr_count + 1;
        end
    end

    assign empty = (wr_count == 0);
    assign full  = (wr_count == FIFO_DEPTH);
    assign dout  = empty ? '0 : fifo[wr_count-1];

endmodule
*/