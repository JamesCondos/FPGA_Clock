module check_values #(parameter MAX = 1, WIDTH = 1) (input clk, input [WIDTH-1:0] in, output out);

	reg [WIDTH - 1:0] previous = 0;
	wire [WIDTH - 1:0] next_previous;
	
	always @(posedge clk)
		previous <= next_previous;
		
	assign next_previous = in;
	
	
	assign out = ((previous == MAX) && (in ==0));
endmodule