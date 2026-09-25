module ButtonControl(input clk, input [2:0] KEY, output [1:0] mode_state, output plus, minus);
	
	wire [1:0] edit_state;
	
	localparam DELAY = 25_000_000;
	localparam PERIOD = 5_000_000;

	localparam EDIT_SECS = 2'b01, EDIT_MINS = 2'b10, EDIT_HRS = 2'b11, EDIT_NONE = 2'b00;
	
	//check what edit state we are in for clock
	Edit mode(.clk(clk), .KEY(!KEY[2]), .out(edit_state));
	
	
	//sets a fast advance for long press
	FastAdvance #(.LONG(DELAY), .PERIOD(PERIOD)) plus_button(.clk(clk), .in(!KEY[1]), .out(plus));
	
	FastAdvance #(.LONG(DELAY), .PERIOD(PERIOD)) minus_button(.clk(clk), .in(!KEY[0]), .out(minus));
	
	
	//if we change our edit state, set that as the output
	assign mode_state = edit_state;
	
	
endmodule

