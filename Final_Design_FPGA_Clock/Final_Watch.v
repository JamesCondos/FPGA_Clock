
									
module Final_watch(input CLOCK_50, input [3:0] KEY, input [1:0] SW,
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, output [9:0] LEDR);
	
	localparam CLOCK_MODE = 2'b00;
	localparam STOP_WATCH_MODE = 2'b01;
	localparam COUNT_DOWN_TIMER_MODE = 2'b10;
	
	wire [6:0] hours_clock;
	wire [6:0] minutes_clock;
	wire [6:0] seconds_clock;
	
	wire [6:0] minutes_SW;
	wire [6:0] seconds_SW ;
	wire [6:0] hundredths_SW ;
	
	wire [6:0] hours_CDT ;
	wire [6:0] minutes_CDT ;
	wire [6:0] seconds_CDT ;
	
	wire [3:0] light_clock ;
	wire [3:0] light_display ;
	
	wire [6:0] seg_12 ;
	wire [6:0] seg_34 ;
	wire [6:0] seg_56;
	
	wire [3:0] k0 ;
	wire [3:0] k1 ;
	wire [3:0] k2 ;
	
	wire [1:0] mode_state;
	
	//change the LEDR depending on the specified mode
	assign LEDR[9] = (mode_state == CLOCK_MODE);
	assign LEDR[8] = (mode_state == STOP_WATCH_MODE);
	assign LEDR[7] = (mode_state == COUNT_DOWN_TIMER_MODE);
	
	//change the mode for the LEDS on the board
	mode_FSM finite_SM(.clk(CLOCK_50), .in(!KEY[3]), .mode(mode_state));
	
	//clock module
	Clock clock_v1(.clk(CLOCK_50), .KEY(~{k2[0], k1[0], k0[0]}), .hours(hours_clock),
		.minutes(minutes_clock), .seconds(seconds_clock), .light(light_clock));
	
	//stopwatch module
	Stop_watch stopwatch_v1(.clk(CLOCK_50), .KEY(~{k2[1], k1[1], k0[1]}), .hundredths(hundredths_SW),
		.minutes(minutes_SW), .seconds(seconds_SW));
	
	//Countdown timer module
	Count_down_timer count_down_time_v1(.clk(CLOCK_50), .KEY(~{k2[2], k1[2], k0[2]}), .hours(hours_CDT), 
		.minutes(minutes_CDT), .seconds(seconds_CDT), .LEDR(LEDR[0]));
		
	//change the otuput depending on what mode we are currently in	
	Multiplexer multiplexer_v1 (.clock({hours_clock, minutes_clock, seconds_clock, light_clock}),
										 .stopwatch({minutes_SW, seconds_SW, hundredths_SW, 4'b0000}),
										 .count_DT({hours_CDT, minutes_CDT, seconds_CDT, 4'b0000}),
										 .none(25'b0),
										 .mode(mode_state),
										 .out({seg_12, seg_34, seg_56, light_display}));
										 
										 
	//display depending on mode chosen in the multiplxer								 	
	Display display(.clk(CLOCK_50), .hours(seg_12), .minutes(seg_34), .seconds(seg_56), 
		.flag(light_display), .HEX5(HEX5) , .HEX4(HEX4) , .HEX3(HEX3) , .HEX2(HEX2) , .HEX1(HEX1), .HEX0(HEX0));
	
	
	//chanfe what each key does depending on the mode chosen
	DeMUX4 demultiplexer1(.in(!KEY[0]), .sel(mode_state), .out(k0));
	DeMUX4 demultiplexer2(.in(!KEY[1]), .sel(mode_state), .out(k1));
	DeMUX4 demultiplexer3(.in(!KEY[2]), .sel(mode_state), .out(k2));							 
endmodule



									