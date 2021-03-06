module MEM_WB (
	input clk,
	input reset,
	input enable,
	// Datapath
	input [31:0] mem_rd,
	input [31:0] mem_inst,

	output reg [31:0] wb_rd,
	output reg [31:0] wb_inst,
	// Control block contain for wb instrctuion
	input mem_regWEn,

	output reg wb_regWEn
);
always @(posedge clk) begin
	if (reset != 1'b1) begin
		if (enable) begin
			wb_rd <= mem_rd;
			wb_inst <= mem_inst;
			wb_regWEn <= mem_regWEn;
		end
	end
	else begin
		wb_rd <= 32'b0;
		wb_inst <= 32'b0;
		wb_regWEn <= 1'b0;
	end
end
endmodule
