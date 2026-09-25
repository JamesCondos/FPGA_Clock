module RisingEdge(input clk, input in, output out);
	reg previous = 0; 
	wire next_previous;

	always @(posedge clk)
		previous <= next_previous;

	assign next_previous = in;

	assign out = (!previous && in);
endmodule