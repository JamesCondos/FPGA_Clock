module Flash_LED(input clk, output reg LED);

	localparam DELAY = 25_000_000;
	localparam DUTY_CYCLE = 20_000_000;
	localparam PERIOD = 5_000_000;
	localparam BW = $clog2(DELAY);
	
	wire [BW-1:0] tick;
	
	
	//counter to check for 80% duty cycle
	Counter #(.MAX(DELAY-1), .WIDTH(BW)) p(.clk(clk), .enable(1'b1), .cnt(tick));
	
	always @(*)
		if (tick > DUTY_CYCLE) //when LED = 1, display is off
			LED = 1'b1;
		else
			LED = 0;
			
	
endmodule