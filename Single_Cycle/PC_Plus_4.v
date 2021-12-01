module PC_Plus_4(in, out);
	input [31:0] in;
	output [31:0] out;
	reg [31:0] out;
	always @(in)
		out = in + 4;
endmodule
