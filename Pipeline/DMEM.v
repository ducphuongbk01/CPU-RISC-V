module DMEM(clk, MemRW ,Addr, DataIn, DataOut, DataW, DataR);

parameter DATA_SIZE = 32;
parameter ADDRESS_SIZE = 32;

input [ADDRESS_SIZE-1:0] Addr;
input [DATA_SIZE-1:0] DataW;
input MemRW;
input clk;
input [1:0] DataIn;
input [2:0] DataOut;

output reg [DATA_SIZE-1:0] DataR;

parameter READ =0;
parameter WRITE =1;
parameter DMEM_DEPTH = 1<<18;

reg [DATA_SIZE-1:0] DMEM [0:DMEM_DEPTH-1];
reg a;

initial begin
$readmemh("initial_DMEM.txt",DMEM);
end


always @(negedge clk) begin
	if (MemRW == WRITE) begin
		case (DataIn)
			2'b00: DMEM[Addr] = DataW;
			2'b01: DMEM[Addr] = {{24{DataW[7]}}, DataW[7:0]};
			2'b10: DMEM[Addr] = {{16{DataW[15]}}, DataW[15:0]};
		endcase
	end
end

always @(*) begin
	if (MemRW == READ) begin
		case (DataOut)
			3'b000: DataR = DMEM[Addr];
			3'b001: DataR = {{24{DMEM[Addr][7]}}, DMEM[Addr][7:0]};
			3'b010: DataR = {{16{DMEM[Addr][15]}}, DMEM[Addr][15:0]};
			3'b101: DataR = {{24{1'b0}}, DMEM[Addr][7:0]};
			3'b110: DataR = {{16{1'b0}}, DMEM[Addr][15:0]};
		endcase
	end
end
endmodule
