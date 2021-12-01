module Imm_Gen(sel, in, out);
	input [2:0] sel;
	input [31:0] in;
	output [31:0] out;
	reg [31:0] out;
	integer tmp1;
	always @(sel or in)
		case(sel)
			0:
			begin
				tmp1 = in & 32'h fff00000;
				out = tmp1>>>20;
			end
			1:
			begin
				tmp1 = in & 32'h fff00000;
				out = tmp1>>20;
			end
			2:
			begin
				tmp1 = in & 32'h 01f00000;
				out = tmp1>>20;
			end
			3:
			begin
				tmp1 = {in[31:25], in[11:7], 20'h 00000};
				out = tmp1>>>20;
			end
			4:
			begin
				tmp1 = {in[31], in[7], in[30:25], in[11:8], 20'h 00000};
				out = tmp1>>>19;
			end
			5:
			begin
				tmp1 = {in[31:12], 12'h 000};
				out = tmp1;
			end
			6:
			begin
				tmp1 = {in[31], in[19:12], in[20], in[30:21], 12'h 000};
				out = tmp1>>>11;
			end
			default: out = in;

		endcase
endmodule

