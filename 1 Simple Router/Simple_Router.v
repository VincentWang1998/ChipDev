/*
date: 2023.10.18
editor: Vincent Wang
title: Simple Router
description:

Prompt
Build a router circuit which forwards data from the input (din) to one of four outputs (dout0, dout1, dout2, or dout3), specified by the address input (addr).

The address is a two bit value whose decimal representation determines which output value to use. Append to dout the decimal representation of addr to get the output signal name dout{address decimal value}. For example, if addr=b11 then the decimal representation of addr is 3, so the output signal name is dout3.

The input has an enable signal (din_en), which allows the input to be forwarded to an output when enabled. If an output is not currently being driven to, then it should be set to 0.

Input and Output Signals
din - Input data.
din_en - Enable signal for din. Forwards data from input to an output if 1, does not forward data otherwise.
addr - Two bit destination address. For example addr = b11 = 3 indicates din should be forwarded to output value 3 (dout3).
dout0 - Output 0. Corresponds to addr = b00.
dout1 - Output 1. Corresponds to addr = b01.
dout2 - Output 2. Corresponds to addr = b10.
dout3 - Output 3. Corresponds to addr = b11.


module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  input  din_en,
  input  [1:0] addr,
  output logic [DATA_WIDTH-1:0] dout0,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);

endmodule
*/

/*
Hint

*/

module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  input  din_en,
  input  [1:0] addr,
  output logic [DATA_WIDTH-1:0] dout0,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);
	assign dout0 = (din_en & ~addr[1] & ~addr[0]) ? din : 'd0; // if din_en & addr==2'b00 then assign din
	assign dout1 = (din_en & ~addr[1] &  addr[0]) ? din : 'd0; // if din_en & addr==2'b01 then assign din
	assign dout2 = (din_en &  addr[1] & ~addr[0]) ? din : 'd0; // if din_en & addr==2'b10 then assign din
	assign dout3 = (din_en &  addr[1] &  addr[0]) ? din : 'd0; // if din_en & addr==2'b11 then assign din
	
endmodule

/*
//ref


module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  input  din_en,
  input  [1:0] addr,
  output logic [DATA_WIDTH-1:0] dout0,
  output logic [DATA_WIDTH-1:0] dout1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);

    assign dout0 = (din_en && addr == 0) ? din : 0;
    assign dout1 = (din_en && addr == 1) ? din : 0;
    assign dout2 = (din_en && addr == 2) ? din : 0;
    assign dout3 = (din_en && addr == 3) ? din : 0;

endmodule

*/
