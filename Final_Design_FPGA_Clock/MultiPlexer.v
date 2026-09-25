
//select the correct output for hours/minutes/seconds
module Multiplexer (input [24:0] clock, stopwatch, count_DT, none, input [1:0] mode, output reg [24:0] out);

	always @(*) begin
		case(mode)
			2'b00: out = clock;
			2'b01: out = stopwatch;
			2'b10: out = count_DT;
			2'b11: out = none;
		endcase
	end
endmodule