module IMEM(PC, inst);

parameter INST_SIZE = 32;
parameter PC_SIZE = 32;
parameter MEM_WIDTH = 8;
parameter MEM_DEPTH = 1<<18;

input [PC_SIZE-1:0] PC;
output reg [INST_SIZE-1:0] inst;

reg [MEM_WIDTH -1:0] IMEM [0:MEM_DEPTH-1];



// load instruction memory
initial begin
$readmemh("test_scripts.txt",IMEM);
end

always @(PC) begin
	inst <= {IMEM[PC],IMEM[PC+1],IMEM[PC+2],IMEM[PC+3]};
end
endmodule
