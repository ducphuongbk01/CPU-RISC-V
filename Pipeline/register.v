module register(clk, RegWEn, AddrA, AddrB, AddrD, DataD, DataA, DataB);

parameter DATA_SIZE = 32;
parameter NUM_REG = 32;
parameter ADDRESS_SIZE = 5;

parameter READ_ONLY = 0;
parameter READ_WRITE = 1;

input clk;
input RegWEn;
input [ADDRESS_SIZE-1:0] AddrA;
input [ADDRESS_SIZE-1:0] AddrB;
input [ADDRESS_SIZE-1:0] AddrD;
input [DATA_SIZE-1:0] DataD;

output reg [DATA_SIZE-1:0] DataA;
output reg [DATA_SIZE-1:0] DataB;



// Register
reg [DATA_SIZE-1:0] register [0:NUM_REG-1];

initial begin
$readmemh("initial_registervalue.txt",register);
end


always @(negedge clk) begin
	if (RegWEn == READ_WRITE)
		begin
			// Write
			register[AddrD] = DataD;
		end
	register[0] = 32'h0000_0000;
end

// Read
assign DataA = register[AddrA];
assign DataB = register[AddrB];


endmodule
