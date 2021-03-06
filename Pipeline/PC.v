module PC(clk, reset, enable, in, out);
input enable, reset, clk;
input [31:0] in;
output reg [31:0] out;

always @(posedge clk)
begin
	if (enable == 1'b1)
	begin
		if ((in === 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz) || (in === 32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx))
			out <= 32'h0000_0000;
		else
			out <= in;
	end
end

always @(reset)
begin
	if (reset == 1'b1)
		out <= 32'h0000_0000;
	else
		out <= in;
end
endmodule
