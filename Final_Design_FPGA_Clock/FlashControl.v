module FlashControl(input clk, input [1:0] mode, output [3:0] out);

	localparam N = 25_000_000;
	localparam BW = $clog2(N);
	wire [BW-1:0] tick;
	wire [1:0] Edit_state;
	wire light;
	reg new_light;
	
	//check which mode state we are in
	
	always @(*)
		if (mode == 2'b00)
			new_light = 1'b1;
		else
			new_light = light;
			
	
	Flash_LED Flash(.clk(clk), .LED(light));
	DeMUX4 dm4(.in(new_light), .sel(mode), .out(out));
	
endmodule

