module FastAdvance
	#(parameter LONG = 3, PERIOD = 5) (
		input clk,
		input in,
		output out);
				
	localparam BWL = $clog2(LONG+1);
	localparam BWP = $clog2(PERIOD);
	
	reg [BWL - 1:0] cl = 0;
	reg [BWP -1:0] cp = 0;
	reg [BWP -1:0] next_cp = 0;
	reg [BWL - 1:0] next_cl = 0;
	
	
	always @(posedge clk)
	
		{cl, cp} <= {next_cl, next_cp}; //sate goes to next state
	
	
	//if no key inputed, dont do anything
	always @(*)
	
		if (!in) begin
			next_cl = 0;
			next_cp = 0;
			
		end 
		
		else if (in) begin
			
			//add until reached a LONG value
			if (cl < (LONG)) begin
				next_cl = (cl + 1'b1);
				next_cp = 0;
			end
			
			//once reach a LONG value, continue cycling the specified period value that constiute long press		
			else if (cl == (LONG)) begin
				next_cl = LONG;
				next_cp = (cp == (PERIOD-1)) ? 1'b0 : (cp+1'b1);
			end
			
			else begin
				next_cl = 0;
				next_cp = 0;
			end
			
		end
		
		
	assign out = (((cl == (LONG)) && (cp == 0)) || (cl == 1));
		
		
endmodule