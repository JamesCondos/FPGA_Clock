module Counter #(parameter MAX = 1, WIDTH = 1, UP = 1) (
	input clk, 
	input enable, 
	input plus, 
	input minus, input stop, 
	output reg [WIDTH - 1:0] cnt
	);
	
	reg [WIDTH-1:0] next_cnt;
	
	initial begin
		if (UP == 1)
			cnt = 0;
		else
			cnt = MAX;
	end
	
	always @(posedge clk)
			cnt <= next_cnt; // sets clock
	
	//counter for adding or subtracting depending on which key is pressed
	
	always @(*)
	
		if (stop)
			next_cnt = 0;
			
		else if (minus && plus)
			next_cnt = cnt;
			
		else if (plus)
			next_cnt = (cnt == MAX) ? 1'd0 : (cnt + 1'd1); //Decrease by 1
			
		else if (minus)
			next_cnt = (cnt == 0) ? MAX : (cnt - 1'd1);
			
		else if (enable) begin
			
				if (UP)
					next_cnt = (cnt == MAX) ? 1'd0 : (cnt + 1'd1);
					
				else
					next_cnt = (cnt == 0) ? MAX : (cnt - 1'd1);
			end
		else
			next_cnt = cnt;
			
				
endmodule
					