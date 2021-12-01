module mux2(in1, in2, out, sel);

parameter DATA_SIZE = 32;

input [DATA_SIZE-1:0] in1;
input [DATA_SIZE-1:0] in2;

input sel;

output [DATA_SIZE-1:0] out;

assign out = (sel)?in1:in2;
	
endmodule
