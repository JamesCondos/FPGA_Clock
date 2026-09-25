module Display(input clk, input [6:0] hours, input [6:0] minutes, seconds, input [3:0] flag, output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	wire [3:0] hours_tens;
	wire [3:0] hours_ones;
	
	wire [3:0] mins_tens;
	wire [3:0] mins_ones;
	
	wire [3:0] secs_tens;
	wire [3:0] secs_ones;
	
	//convert values into tens the ones
	NumConv Convert_Hours(.in(hours), .tens(hours_tens), .ones(hours_ones));
	NumConv Convert_Mins(.in(minutes), .tens(mins_tens), .ones(mins_ones));
	NumConv Convert_Secs(.in(seconds), .tens(secs_tens), .ones(secs_ones));
	
	//display depending on whether flag is 0 or 1 (ie flashing or not)
	SSeg hours1(.digit(hours_tens), .sseg(HEX5), .blank(flag[3]), .enable(1'b1));
	SSeg hours2(.digit(hours_ones), .sseg(HEX4), .blank(flag[3]), .enable(1'b1));
	
	SSeg mins1(.digit(mins_tens), .sseg(HEX3), .blank(flag[2]), .enable(1'b1));
	SSeg mins2(.digit(mins_ones), .sseg(HEX2), .blank(flag[2]), .enable(1'b1));
	
	SSeg secs1(.digit(secs_tens), .sseg(HEX1), .blank(flag[1]), .enable(1'b1));
	SSeg secs2(.digit(secs_ones), .sseg(HEX0), .blank(flag[1]), .enable(1'b1));
	
endmodule
	