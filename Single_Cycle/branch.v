module branch(BrUn, BrEq, BrLT, In1, In2);

parameter DATA_SIZE = 32;

input BrUn;
input [DATA_SIZE-1:0] In1;
input [DATA_SIZE-1:0] In2;

output reg BrEq, BrLT;

parameter COMPARE_UNSIGNED = 1;
parameter COMARE_SIGNED = 0;

always @(In1 or In2 or BrUn) begin
	case (BrUn)
		COMPARE_UNSIGNED:
			if (In1 == In2) begin
				BrEq = 1;
				BrLT = 0;
			end
			else if (In1 < In2) begin
				BrEq = 0;
				BrLT = 1;
			end
			else begin
				BrEq = 0;
				BrLT = 0;
			end
		COMARE_SIGNED:
			if ($signed(In1) == $signed(In2)) begin
				BrEq = 1;
				BrLT = 0;
			end
			else if ($signed(In1) < $signed(In2)) begin
				BrEq = 0;
				BrLT = 1;
			end
			else begin
				BrEq = 0;
				BrLT = 0;
			end
	endcase
end
endmodule
