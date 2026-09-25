module mode_FSM (input clk, input in, output [1:0] mode);

	localparam CLOCK_MODE = 2'b00;
	
	localparam STOP_WATCH_MODE = 2'b01;
	
	localparam COUNT_DOWN_TIMER_MODE = 2'b10;
	
	wire check_mode;
	
	RisingEdge check(.clk(clk), .in(in), .out(check_mode));
	
	reg [1:0] state_mode = CLOCK_MODE;
	reg [1:0] next_state;
	
	always @(posedge clk)
	
		state_mode <= next_state;
	
	
	//FSM for changing the specified mode
	always @(*)
		case(state_mode)
			CLOCK_MODE : next_state = check_mode ? STOP_WATCH_MODE : CLOCK_MODE;
			
			STOP_WATCH_MODE : next_state = check_mode ? COUNT_DOWN_TIMER_MODE : STOP_WATCH_MODE;
			
			COUNT_DOWN_TIMER_MODE : next_state = check_mode ? CLOCK_MODE : COUNT_DOWN_TIMER_MODE;
			
		endcase
		
	assign mode = state_mode;
	
endmodule