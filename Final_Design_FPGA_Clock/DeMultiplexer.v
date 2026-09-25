module DeMUX4(input in, input [1:0] sel, output reg [3:0] out);
	
	//this is for selecting the selth selection
	always @(*) begin
		case (sel)
			2'b00: out = {3'b000, in};
			2'b01: out = {2'b00, in, 1'b0};
			2'b10: out = {1'b0, in, 2'b00};
			2'b11: out = {in, 3'b000};		
		endcase
	end
endmodule