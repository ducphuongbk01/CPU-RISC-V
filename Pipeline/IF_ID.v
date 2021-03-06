module IF_ID (
	input clk,
	input reset,
	input enable,
	// Datapath
	input [31:0] if_pc,
	input [31:0] if_inst,

	output reg [31:0] id_pc,
	output reg [31:0] id_inst	
);
always @(posedge clk) begin
	if (reset != 1'b1) begin
		if (enable) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	else begin
		id_pc <= 32'b0;
		id_inst <= 32'b0;
	end
end
endmodule
