
//check if we have held the button for a single pulse
module Hold_OneSec (input clk, input in, output out);
		
	localparam N = 50_000_000;
	localparam BW = $clog2(N);
	
	reg [BW-1:0] cnt = 0;
	reg [BW - 1: 0] next_cnt;
	
	always @(posedge clk)
		cnt <= next_cnt;
	
	always @(*)
		if (in)
			next_cnt = (cnt == (N-1)) ? 1'b0 : (cnt + 1);
		else
			next_cnt = 0;
			
	assign out = (cnt == (N-1));
	
endmodule