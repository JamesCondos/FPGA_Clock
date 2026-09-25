//convert a number into its tenths and ones
module NumConv (input [6:0] in, output [3:0] tens, ones);

	assign tens = in / 10;
	assign ones = in % 10;
endmodule
 