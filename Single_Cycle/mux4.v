module mux4(in1, in2, in3, in4, out, sel);
parameter DATA_SIZE = 32;

input [DATA_SIZE-1:0] in1;
input [DATA_SIZE-1:0] in2;
input [DATA_SIZE-1:0] in3;
input [DATA_SIZE-1:0] in4;

output reg [DATA_SIZE-1:0] out;

input [1:0] sel;

always @(*) begin
	case (sel)
		2'b00: begin out = in1; end
		2'b01: begin out = in2; end
		2'b10: begin out = in3; end
		2'b11: begin out = in4; end
	endcase
end
endmodule
