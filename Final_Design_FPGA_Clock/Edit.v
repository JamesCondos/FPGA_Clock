module Edit(input clk, input [1:0] KEY, output [1:0] out);
	
	//assign out = LEDR;
	localparam N = 50_000_000;
	localparam BW = $clog2(N);
	
	localparam EDIT_SECS = 2'b01, EDIT_MINS = 2'b10, EDIT_HRS = 2'b11, EDIT_NONE = 2'b00;
	
	wire [BW - 1:0] tick;
	
	wire press;
	
	wire risingedge;
	
	reg [2:0] state = EDIT_NONE, next_state;
	
	Hold_OneSec Holding(.clk(clk), .in(KEY), .out(press));
	
	RisingEdge Rising(.clk(clk), .in(KEY), .out(risingedge));
	
	always @(posedge clk)
		state <= next_state;
	
	
	//FSM for changing specified modes
	always @(*)
		case(state)
			EDIT_NONE: next_state = press ? EDIT_SECS: EDIT_NONE;
			
			EDIT_SECS: next_state = risingedge ? EDIT_MINS: EDIT_SECS;
			
			EDIT_MINS: next_state = risingedge ? EDIT_HRS: EDIT_MINS;
			
			EDIT_HRS: next_state = risingedge ? EDIT_NONE : EDIT_HRS;
			
		endcase 
		
		assign out = state;
	
	
endmodule