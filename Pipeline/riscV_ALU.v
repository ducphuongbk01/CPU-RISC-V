module riscV_ALU(sel, inA, inB, out);
	output [31:0] out;
	input [3:0] sel;
	input [31:0] inA, inB;
	reg [31:0] out;
	integer a, b;

	always @(*)
		case(sel)
			0: out = inA+inB;
			1: out = inA-inB;
			2: out = inA<<inB;	
			3: out = inA>>inB;
			4: 
			begin
				a = inA;
				out = a>>>inB;
			end
			5: out = ($signed(inA)<$signed(inB))?32'd 1:32'd 0;
			6:
			begin
				out = (inA<inB)?32'd 1:32'd 0;
			end
			7: out = inA & inB;
			8: out = inA | inB;
			9: out = inA ^ inB;
			10: out = inB;
		endcase
endmodule

