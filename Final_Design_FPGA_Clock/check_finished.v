module check_done #(parameter PERIOD=1, WIDTH=1) (input clk, input [4:0] hours, input [5:0] minutes, input [5:0] seconds, output out);
	
	localparam MAX_SEC = 59;
	
	//current states
	reg [5:0] prev_sec = MAX_SEC;
	wire [5:0] next_prev_sec; 
	
	wire result;

	assign result = ((hours==0)  && ((seconds==0) && (minutes==0)) && (prev_sec==1));
	
	always @(posedge clk)
		prev_sec <= next_prev_sec;

	assign next_prev_sec = seconds;


	assign out = result; 
	
endmodule