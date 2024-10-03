/*
date: 2023.10.18
editor: Vincent Wang
title: Edge Detector
description:

Prompt
Build a circuit that pulses dout one cycle after the rising edge of din. A pulse is defined as writing a single-cycle 1 as shown in the examples below. When resetn is asserted, the value of din should be treated as 0.

Bonus - can you enhance your design to pulse dout on the same cycle as the rising edge? Note that this enhancement will not pass our test suite, but is still a useful exercise.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input signal
dout - Output signal
Output signals during reset
dout - 0 when resetn is active


module model (
  input clk,
  input resetn,
  input din,
  output dout
);

endmodule
*/

/*
Hint

*/

module model (
  input clk,
  input resetn,
  input din,
  output dout
);
	reg [1:0] edge_detector;
	
	always @(posedge clk) begin
		if(~resetn) begin
			edge_detector <= 'd0;
		end
		else begin
			edge_detector <= {edge_detector[0], din};
		end
	end
	
	assign dout = (edge_detector == 2'b01) ? 1'b1 : 1'b0;
endmodule


/*
//ref

module model (
  input clk,
  input resetn,
  input din,
  output dout
);

    parameter S00=0, S01=1, S10=2, S11=3;
    logic [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S00;
        end else begin
            case (state)
                S00 : state <= (din ? S01 : S00);
                S01 : state <= (din ? S11 : S10);
                S10 : state <= (din ? S01 : S00);
                S11 : state <= (din ? S11 : S10);
            endcase
        end
    end

    assign dout = (state == S01);

endmodule

*/
