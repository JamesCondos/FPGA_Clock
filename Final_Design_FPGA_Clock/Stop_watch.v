module Stop_watch(input clk, input [2:0] KEY, output [6:0] hundredths, output [6:0] minutes, seconds);

	localparam HDRTH_BW = $clog2(HDRTH);
	localparam MAX_SEC_MIN = 59;
	localparam MAX_HUNDRED = 99;
	localparam HDRTH = 500_000;
	
	wire increment_mind, increment_secs, increment_hund;
	wire [HDRTH_BW-1:0] tick;
	
	//set conditions for incrmenting hours/seconds/hundredths of stopwatch
	assign  increment_min = (tick == (HDRTH-1) && hundredths == MAX_HUNDRED && seconds == MAX_SEC_MIN);
	assign  increment_secs = (tick == (HDRTH-1) && hundredths == MAX_HUNDRED);
	assign  increment_hund = (tick == (HDRTH-1));
	
	wire state;
	reg stop;
	reg next_stop;
	
	
	initial begin
		stop = 1;
	end
	
	
	RisingEdge state_count (.clk(clk), .in(!KEY[0]), .out(state));
	
	
	//start and stop the states
	always @(posedge clk)
		stop <= next_stop;
		
	always @(*)
		if (!state)
			next_stop = stop;
		else
			next_stop = !stop;

	
	//increment hundredths
	Counter #(.MAX(MAX_HUNDRED), .WIDTH(7)) 
	count_hundreds (.clk(clk), .enable(increment_hund),.plus(1'b0), .minus(1'b0), .cnt(hundredths), .stop(!KEY[2]));
		
	//increment seconds
	Counter #(.MAX(MAX_SEC_MIN), .WIDTH(6))
	count_seconds (.clk(clk), .enable(increment_secs), .cnt(seconds), .stop(!KEY[2]));
	
	//set the clock
	Counter #(.MAX(HDRTH-1), .WIDTH(HDRTH_BW)) 
	seperate_time (.clk(clk), .enable(!stop), .plus(1'b0), .minus(1'b0), .cnt(tick), .stop(!KEY[2]));
		
	//increment minutes
	Counter #(.MAX(MAX_SEC_MIN), .WIDTH(6)) 
	count_minutes (.clk(clk), .enable(increment_min),.plus(1'b0), .minus(1'b0), .cnt(minutes), .stop(!KEY[2]));
			
	
	
	
endmodule