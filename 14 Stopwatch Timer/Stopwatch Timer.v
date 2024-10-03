/*
date: 2023.10.20
editor: Vincent Wang
title: Stopwatch Timer
description:

Prompt
Build a module which controls a stopwatch timer.

The timer starts counting when the start button (start) is pressed (pulses) and increases by 1 every clock cycle. When the stop button (stop) is pressed, the timer stops counting. When the reset button (reset) is pressed, the count resets to 0 and the timer stops counting.

If count ever reaches MAX, then it restarts from 0 on the next cycle.

stop's functionality takes priority over start's functionality, and reset's functionality takes priority over both stop and start's functionality.

Input and Output Signals
clk - Clock signal
reset - Synchronous reset signal
start - Start signal
stop - Stop signal
count - Current count
Output signals during reset
count - 0 when reset is active

module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);
	parameter IDLE  = 2'd00,
			  COUNT = 2'd01,
			  STOP  = 2'd10;
			  
	reg [1:0] curr_state, next_state;
	reg [DATA_WIDTH-1:0] count_reg;
	
	always @(*) begin
		next_state = curr_state;
		case(curr_state)
			IDLE: begin
				if(stop) begin
					next_state = STOP;
				end
				else if(start) begin
					next_state = COUNT;
				end
			end
			COUNT: begin
				if(stop) begin
					next_state = STOP;
				end
				else if(start) begin
					next_state = COUNT;
				end
			end
			STOP: begin
				if(stop) begin
					next_state = STOP;
				end
				else if(start) begin
					next_state = COUNT;
				end
			end
			default: next_state = IDLE;
		endcase
	end
	
	always @(posedge clk) begin
		if(reset) begin
			curr_state <= IDLE;
		end
		else begin
			curr_state <= next_state;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			count_reg <= 'd0;
		end
		else begin
			case(curr_state)
				IDLE: begin
					if(start & ~stop) begin
						count_reg = (count_reg == MAX) ? 'd0 : count_reg + 1'b1;
					end
				end
				COUNT: begin
					if(~stop) begin
						count_reg = (count_reg == MAX) ? 'd0 : count_reg + 1'b1;
					end
				end
				STOP: begin
					if(start & ~stop) begin
						count_reg = (count_reg == MAX) ? 'd0 : count_reg + 1'b1;
					end
				end
			endcase
		end
	end
	
	assign count = count_reg;
endmodule

/*
//ref


*/

/*
// error 
module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);
	reg [DATA_WIDTH-1:0] count_reg;
	reg start_flag, stop_flag;
	assign count = count_reg;
	always @(posedge clk) begin
		if(reset) begin
			count_reg <= 'd0;
		end
		else begin
			if(stop || stop_flag) begin
				count_reg <= count_reg;
			end
			else if(start || start_flag) begin
				count_reg <= (count_reg == MAX) ? 'd0 : count_reg + 1'd1; 
			end
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			start_flag <= 'd0;
		end
		else begin
			if(stop) begin
				start_flag <= 1'b0;
			end
			else if(start) begin
				start_flag <= 1'b1;
			end
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			stop_flag <= 'd0;
		end
		else begin
			if(stop) begin
				stop_flag <= 1'b1;
			end
			else if(start) begin
				stop_flag <= 1'b0;
			end
		end
	end
endmodule

*/

/*
//ref

module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);

    logic state;
    logic [DATA_WIDTH-1:0] temp;

    always @(posedge clk) begin
        if (reset) begin
            temp <= 0;
            state <= 0;
        end else if (stop) begin
            state <= 0;
        end else if (start || state) begin
            state <= 1;
            temp <= (temp == MAX) ? 0 : temp + 1;
        end
    end

    assign count = temp;

endmodule

*/