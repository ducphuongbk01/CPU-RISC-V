module ID_EX (
	input clk,
	input reset,
	input enable,
	// Datapath
	input [31:0] id_pc,
	input [31:0] id_rs1,
	input [31:0] id_rs2,
	input [31:0] id_inst,

	output reg [31:0] ex_pc,
	output reg [31:0] ex_rs1,
	output reg [31:0] ex_rs2,
	output reg [31:0] ex_inst,
	// Control block contain for mem and wb instruction
	input id_MemRW,
	input id_regWEn,
	input [1:0] id_WBSel,
	input [2:0] id_ImmSel,
	input [3:0] id_AluSel,
	input id_brun,
	input id_ASel,
	input id_BSel,
	input [1:0] id_mem_ctrl_datain,
	input [2:0] id_mem_ctrl_dataOutAddj,

	output reg ex_MemRW,
	output reg ex_regWEn,
	output reg [1:0] ex_WBSel,
	output reg [2:0] ex_ImmSel,
	output reg [3:0] ex_AluSel,
	output reg ex_brun,
	output reg ex_ASel,
	output reg ex_BSel,
	output reg [1:0] ex_mem_ctrl_datain,
	output reg [2:0] ex_mem_ctrl_dataOutAddj
);

always @(posedge clk) begin
	if (reset != 1'b1) begin
		if (enable) begin
			ex_pc <= id_pc;
			ex_rs1 <= id_rs1;
			ex_rs2 <= id_rs2;
			ex_inst <= id_inst;
			ex_MemRW <= id_MemRW;
			ex_regWEn <= id_regWEn;
			ex_WBSel <= id_WBSel;
			ex_ImmSel <= id_ImmSel;
			ex_AluSel <= id_AluSel;
			ex_brun <= id_brun;
			ex_ASel <= id_ASel;
			ex_BSel <= id_BSel;
			ex_mem_ctrl_datain <= id_mem_ctrl_datain;
			ex_mem_ctrl_dataOutAddj <= id_mem_ctrl_dataOutAddj;
		end
	end
	else begin
			ex_pc <= 32'd0;
			ex_rs1 <= 32'd0;
			ex_rs2 <= 32'd0;
			ex_inst <= 32'd0;
			ex_MemRW <= 1'b0;
			ex_regWEn <= 1'b0;
			ex_WBSel <= 2'b0;
			ex_ImmSel <= 3'b0;
			ex_AluSel <= 4'b0;
			ex_brun <= 1'b0;
			ex_ASel <= 1'b0;
			ex_BSel <= 1'b0;
			ex_mem_ctrl_datain <= 2'b0;
			ex_mem_ctrl_dataOutAddj <= 3'b0;
	end
end
endmodule
