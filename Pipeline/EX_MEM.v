module EX_MEM (
	input clk,
	input reset,
	input enable,
	// Datpath
	input [31:0] ex_alu,
	input [31:0] ex_pc,
	input [31:0] ex_rs2,
	input [31:0] ex_inst,


	output reg [31:0] mem_alu,
	output reg [31:0] mem_pc,
	output reg [31:0] mem_rs2,
	output reg [31:0] mem_inst,

	input ex_MemRW,
	input ex_regWEn,
	input [1:0] ex_WBSel,
	input [1:0] ex_mem_ctrl_datain,
	input [2:0] ex_mem_ctrl_dataOutAddj,

	output reg mem_MemRW,
	output reg mem_regWEn,
	output reg [1:0] mem_WBSel ,
	output reg [1:0] mem_ctrl_datain,
	output reg [2:0] mem_ctrl_dataOutAddj
);
always @(posedge clk) begin
	if (reset != 1'b1) begin
		if (enable) begin
			mem_alu <= ex_alu;
			mem_pc <= ex_pc;
			mem_rs2 <= ex_rs2;
			mem_inst <= ex_inst;
			mem_MemRW <= ex_MemRW;
			mem_regWEn <= ex_regWEn;
			mem_WBSel <= ex_WBSel;
			mem_ctrl_datain <= ex_mem_ctrl_datain;
			mem_ctrl_dataOutAddj <= ex_mem_ctrl_dataOutAddj;
		end
	end
	else begin
		mem_alu <= 32'b0;
		mem_pc <= 32'b0;
		mem_rs2 <= 32'b0;
		mem_inst <= 32'b0;
		mem_MemRW <= 1'b0;
		mem_regWEn <= 1'b0;
		mem_WBSel <= 2'b0;
		mem_ctrl_datain <= 2'b0;
		mem_ctrl_dataOutAddj <= 3'b0;
	end
end
endmodule