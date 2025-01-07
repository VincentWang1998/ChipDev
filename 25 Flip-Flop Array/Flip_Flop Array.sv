// 25. Flip-Flop Array

/*
Prompt
Design a simple 1-read/write (1RW) register file (RF) by using a multidimentional array of flip-flops in Verilog.

The RF should have 8 entries with each entry being an 8-bit digital word.  The input word din is written to one of the 8 entries of the RF by using the 3-bit port addr and asserting signal wr.  An entry is retrieved from the RF by selecting the address and asserting the rd signal.  If one tries to read from an address that has never been written to, then dout and error should both output zero.

This is a simple RF so it should support only one operation per clock cycle, either a read or write.  If both rd and wr ports are set to logic level high in a cycle, then error is asserted, and dout is set to zero in order to indicate the operation has failed.

Input and Output Signals
din - Input data port
addr - Address input to the flip-flop array
wr - Write-enable input signal
rd - Read-enable input signal
clk - Clock signal
resetn - Synchronous, active-low, reset signal
dout - Output data port
error - Error signal - Invalid operation

Output signals during reset
dout - 0
error - 0
*/

// example
/*
At cycle 1, all entries are reset to zero.  In the subsequent cycles, data are written to addresses 1, 2, 3.  At cycle 5, both inputs wr and rd are one, which is not allowed — Output error is asserted to indicate that.  Output dout is always zero as not data has been read yet.
*/

// template
/*
module model (
    input [7:0] din,
    input [2:0] addr,
    input wr,
    input rd,
    input clk,
    input resetn,
    output logic [7:0] dout,
    output logic error
);

endmodule
*/

/**/
/**/
/**/
/**/

module model (
    input [7:0] din,
    input [2:0] addr,
    input wr,
    input rd,
    input clk,
    input resetn,
    output logic [7:0] dout,
    output logic error
);
	logic [7:0] register_file [0:7];
	
	always @(posedge clk) begin
		if (!resetn) begin
			dout  <= 'd0;
			error <= 'd0;
			for (int i = 0; i <= 7; i++) begin
				register_file[i] <= 'd0;
			end
		end else begin
			error <= (wr & rd) ? 1'b1 : 1'b0;
			
			if (wr & ~rd) begin
				register_file[addr] <= din;
				dout <= 'd0;
			end
			else if (rd & ~wr) begin
				dout <= register_file[addr];
			end
			else begin
				dout <= 'd0;
			end
		end
	end
	
endmodule


// ref solution
/*
module model (
    input [7:0] din,
    input [2:0] addr,
    input wr,
    input rd,
    input clk,
    input resetn,
    output logic [7:0] dout,
    output logic error
);

    reg [7:0] mem [7:0];
    reg [7:0] dout_int;
    reg error_int;

    always @(posedge clk) begin
        if (!resetn) begin
            // If reset mode, all entries are set to zero
            mem[0] <= 0;
            mem[1] <= 0;
            mem[2] <= 0;
            mem[3] <= 0;
            mem[4] <= 0;
            mem[5] <= 0;
            mem[6] <= 0;
            mem[7] <= 0;
            dout_int <= 0;
            error_int <= 0;
        end
        else begin
            if (!wr & !rd) begin  // NOP
                dout_int <= 0;
                error_int <= 0;
            end
            else if (wr & !rd) begin  // Write
                mem[addr] <= din;
                dout_int <= 0;
                error_int <= 0;
            end
            else if (!wr & rd) begin  // Read
                dout_int <= mem[addr];
                error_int <= 0;
            end
            else begin  // Not allowed
                dout_int <= 0;
                error_int <= 1;
            end
        end
    end

    assign dout = dout_int;
    assign error = error_int;

endmodule
*/