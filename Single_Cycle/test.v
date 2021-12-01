module tb_mux2();

parameter DATA_SIZE = 32;

reg [DATA_SIZE-1:0] in1;
reg [DATA_SIZE-1:0] in2;
reg sel;

wire [DATA_SIZE-1:0] out;

localparam delay = 20;

mux2 inst1 (
in1,
in2,
out,
sel
);

initial begin
	// All test value goes here
	// Select in1
	in1 = 32'hF486_BCED;
	in2 = 32'h1234_5678;
	sel = 0;
	
	#delay;
	//Select in2
	in1 = 32'hF486_BCED;
	in2 = 32'h1234_5678;
	sel = 1;

	in1 = sel;	
end
endmodule