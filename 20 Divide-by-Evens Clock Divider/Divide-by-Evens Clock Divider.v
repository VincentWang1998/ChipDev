/*
date: 2024.09.12
editor: Vincent Wang
title: Programmable Sequence Detector
*/


// Prompt
/*
Given an input clock signal, generate three output clock signals with 2x, 4x, and 6x the period of the input clock.

When resetn is active, then all clocks are reset to 0. When resetn becomes inactive again, all clocks should undergo their posedge transition and start an entirely new clock period. Specifically this means that if resetn became active in the middle of an output clock's period, when resetn becomes inactive the output clock should start an entirely new period instead of continuing from where the interrupted period left off.

Input and Output Signals
clk - Clock signal
resetn - Synchronous reset-low signal
div2 - Output clock with 2x the period of clk
div4 - Output clock with 4x the period of clk
div6 - Output clock with 6x the period of clk
Output signals during reset
div2 - 0 when resetn is active
div4 - 0 when resetn is active
div6 - 0 when resetn is active
*/

// template
/*
module model (
  input clk,
  input resetn,
  output logic div2,
  output logic div4,
  output logic div6
);

endmodule
*/

/*
                    0
counter 0 1 2 3 4 5 6 7
div2    0 1 2 3 4 5 6 7
div4    0   2   4   6 
div6    0     3     6
*/

module model (
  input clk,
  input resetn,
  output logic div2,
  output logic div4,
  output logic div6
);
    logic [2:0] cnt, cnt_next;
    always_ff @(posedge clk) begin
        if(~resetn) begin
            cnt <= 'd0;
        end else begin
            cnt <= cnt_next;
        end 
    end

    always_ff @(posedge clk) begin
        if(~resetn) begin
            div2 <= 1'b0;
            div4 <= 1'b0;
            div6 <= 1'b0;
        end else begin
            div2 <= ~div2;
            case (cnt)
                'd0: begin
                    div4 <= ~div4;
                    div6 <= ~div6;
                end
                'd2: begin
                    div4 <= ~div4;
                end
                'd3: begin
                    div6 <= ~div6;
                end
                'd4: begin
                    div4 <= ~div4;
                end
            endcase
        end
    end
    
    always_comb begin
        cnt_next = cnt + 1'd1;
        if (cnt == 'd5)
            cnt_next = 'd0;
    end
endmodule


// Example Solution:
/*
module model (
  input clk,
  input resetn,
  output logic div2,
  output logic div4,
  output logic div6
);

    logic cnt2;
    logic [1:0] cnt4;
    logic [3:0] cnt6;

    always @(posedge clk) begin
        if (!resetn) begin
            cnt2 <= 0;
            cnt4 <= 0;
            cnt6 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
            cnt4 <= cnt4 + 1;
            cnt6 <= (cnt6 + 1) % 6;
        end
    end

    assign div2 = (cnt2 == 1);
    assign div4 = (cnt4 == 1) || (cnt4 == 2);
    assign div6 = (cnt6 == 1) || (cnt6 == 2) || (cnt6 == 3);

endmodule
*/