//`timescale 1ns/1ns

module Clock(input clk, input [2:0] KEY, input [2:0] SW, output [6:0] hours, minutes, seconds, output [3:0] light);

	localparam DELAY = 25_000_000;
	localparam PERIOD = 5_000_000;
	localparam BW = $clog2(DELAY);
	localparam NON_EDIT = 2'b00, EDIT_SEC = 2'b01, EDIT_MIN = 2'b10, EDIT_HRS = 2'b11;
	
	wire plus, minus;
	wire [BW - 1:0] tick;
	wire [1:0] Edit_state;
	
	//button control
	ButtonControl Button_Control_v1(.clk(clk), .KEY(KEY), .mode_state(Edit_state), 
									.plus(plus), .minus(minus));
	
	//contorls flasshing for edit mode
	FlashControl flash_v1(.clk(clk), .mode(Edit_state), .out(light));
	
	
	//sets time for the clock
	Time time_v1(.clk(clk), .plus(plus), .minus(minus), .hours(hours), .mins(minutes), .secs(seconds), .mode(Edit_state));
			
				
endmodule



