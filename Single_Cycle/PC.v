module PC(reset, clk, in, out);
input reset, clk;
input [31:0] in;
output reg [31:0] out;

always @(posedge clk)
begin
	if ((in === 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz) || (in === 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx))
		out = 32'h0000_0000;
	else
		out = in;
end

always @(posedge reset) out = 32'h0000_0000;

endmodule
