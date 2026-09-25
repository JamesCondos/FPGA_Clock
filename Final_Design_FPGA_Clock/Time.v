module Time(input clk, plus, minus, output [5:0] mins, secs, output [4:0] hours, input [1:0] mode);

	localparam N = 50_000_000;
	localparam BW = $clog2(N);
	
	localparam NON_EDIT = 2'b00;
	localparam EDIT_SEC = 2'b01; 
	localparam EDIT_MIN = 2'b10;
	localparam EDIT_HRS = 2'b11;
	localparam MIN_SEC_END = 59;
	localparam HRS_END = 23;
	
	wire [BW - 1:0] tick;
	wire hours_edit, seconds_edit, minutes_edit, none_edit,increment_hours ,increment_mins;
	
	//set parameters for editing hours etc
	assign hours_edit = (mode == EDIT_HRS);
	assign seconds_edit = (mode == EDIT_SEC);
	assign minutes_edit = (mode == EDIT_MIN);
	assign none_edit = (mode == NON_EDIT);
	
	assign increment_hours = (mins == MIN_SEC_END && secs == MIN_SEC_END && tick == (N-1));
	assign increment_mins = (tick == (N-1) && secs == MIN_SEC_END);
	
	
	
	//set tick and timer
	Counter #(.MAX(N-1), .WIDTH(BW), .UP(1))
		seperate_time (.clk(clk), .enable(none_edit), 
		.plus(1'b0), .minus(1'b0), .cnt(tick), .stop(1'b0));
		
	//increment seconds and add or minus to it
	Counter #(.MAX(MIN_SEC_END), .WIDTH(6), .UP(1))
		count_seconds (.clk(clk), .enable(tick == (N-1)), .minus(minus && seconds_edit),
		.plus(plus && seconds_edit), .cnt(secs), .stop(1'b0));
		
	//increment minutes
	Counter #(.MAX(MIN_SEC_END), .WIDTH(6), .UP(1))
		count_minutes (.clk(clk), .enable(increment_mins), .minus(minus && minutes_edit),
		.plus(plus && minutes_edit), .cnt(mins), .stop(1'b0));
	
	//increment hours
	Counter #(.MAX(HRS_END), .WIDTH(5), .UP(1))	
		count_hours (.clk(clk), .enable(increment_hours), .minus(minus && hours_edit),
		.plus(plus && hours_edit), .cnt(hours));
		
endmodule
