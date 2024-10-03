/*
date: 2023.10.24
editor: Vincent Wang
title: Divisible by 5
description:

Prompt
Design a module that determines whether an input value is evenly divisible by five.

The input value is of unknown length and is left-shifted one bit at a time into the module via the input (din). The module should output a 1 on the output (dout) if the current cumulative value is evenly divisible by five and a 0 otherwise.

When resetn is asserted, all previous bits seen on the input are no longer considered. The 0 seen during reset should not be included when calculating the next value.

This problem is tricky, so it may help to think in terms of modulus and remainder states.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
din - Input bit
dout - 1 if the current value is divisible by 5, 0 otherwise.
Output signals during reset
dout - 0 when resetn is active

module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

endmodule
*/

/*
Hint

*/


// non-FSM solution 1
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);
	/* reference from "16. Division by 3"
		mod_flag[2]: mod 3 = 2
		mod_flag[1]: mod 3 = 1
		mod_flag[0]: mod 3 = 0
	*/
	reg [4:0] mod_flag;
	assign dout = mod_flag[0];
	
	always @(posedge clk) begin
		if(~resetn) begin
			mod_flag <= 5'b00000;
		end
		else begin
			if(mod_flag == 5'b00000) begin
				mod_flag <= (din) ? 5'b00010 : 5'b00001;
			end
			else if(mod_flag == 5'b00001) begin
				mod_flag <= (din) ? 5'b00010 : 5'b00001;
			end
			else if(mod_flag == 5'b00010) begin
				mod_flag <= (din) ? 5'b01000 : 5'b00100;
			end
			else if(mod_flag == 5'b00100) begin
				mod_flag <= (din) ? 5'b00001 : 5'b10000;
			end
			else if(mod_flag == 5'b01000) begin
				mod_flag <= (din) ? 5'b00100 : 5'b00010;
			end
			else if(mod_flag == 5'b10000) begin
				mod_flag <= (din) ? 5'b10000 : 5'b01000;
			end
		end
	end
endmodule

/*
//ref

//FSM solution
module model (
  input clk,
  input resetn,
  input din,
  output logic dout
);

    parameter MODR=0, MOD0=1, MOD1=2, MOD2=3, MOD3=4, MOD4=5, MOD5=6;
    logic [2:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= MODR;
        end else begin
            case (state)
                MODR: state <= (din ? MOD1 : MOD0);
                MOD0: state <= (din ? MOD1 : MOD0);
                MOD1: state <= (din ? MOD3 : MOD2);
                MOD2: state <= (din ? MOD0 : MOD4);
                MOD3: state <= (din ? MOD2 : MOD1);
                MOD4: state <= (din ? MOD4 : MOD3);
            endcase
        end
    end

    assign dout = (state == MOD0);

endmodule

*/

/*
//ref

module model (
input clk,
input resetn,
input din,
output logic dout
);

logic [31:0] number;
logic onecycle;

always @ (posedge clk) begin
	if (!resetn) begin
		onecycle <= 0;
		number <= 0;
	end

	else begin
		number <= {number[30:0], din};
		onecycle <= 1;
	end
end

assign dout = (onecycle && number % 5 == 0);

endmodule

*/
