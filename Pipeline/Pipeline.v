`timescale 1 ps/10 fs  // time-unit = 1 ps, precision = 1 fs

module Pipeline;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	reg clk;
	integer num_pulse = 0;
	wire en_IF_ID, en_ID_EX, en_EX_MEM, en_MEM_WB;
	wire [3:0] en_FF;
	wire rs_IF_ID, rs_ID_EX, rs_EX_MEM, rs_MEM_WB;
	wire [3:0] rs_FF;
	wire en_pc, rs_pc;
	wire [1:0] pc_sel;

	wire [31:0] pc_next;

	// 2 bien trung gian cho 2 ngo vao reset cua flipflop IF_ID vaf ID_EX
	wire rs_IF_ID_br, rs_IF_ID_fw;
	wire rs_ID_EX_br, rs_ID_EX_fw;

	wire tmp, tmp1, tmp2;


	//IF
	//###Datapath
	wire [31:0] out_mux_pc, out_pc, out_IF_pc_4, out_imem;
	//###Value FF
	

	//ID
	//###Datapath
	wire [2:0] out_ctrl_imm_sel, out_ctrl_dataOutAddj;
	wire out_ctrl_brUn, out_ctrl_a_sel, out_ctrl_b_sel, out_ctrl_memRW, out_ctrl_regWEn;
	wire [3:0] out_ctrl_alu_sel;  
	wire [1:0] out_ctrl_wb_sel, out_ctrl_dataIn;

	wire [31:0] data_rs1, data_rs2;

	//###Value FF
	wire [31:0] out_IF_ID_FF_pc, out_IF_ID_FF_inst;


	//EX
	//###Datapath
	wire [31:0] out_mux_fw_A, out_mux_fw_B, out_mux_A, out_mux_B, out_imm_gen, out_alu, out_EX_pc_4, data_last_load;
	wire [1:0] mux_fw_A_sel, mux_fw_B_sel;
	wire brlt, breq;

	//###Value FF
	wire [31:0] out_ID_EX_FF_pc, out_ID_EX_FF_rs1, out_ID_EX_FF_rs2, out_ID_EX_FF_inst;

	wire [2:0] out_ID_EX_FF_imm_sel, out_ID_EX_FF_dataOutAddj;
	wire out_ID_EX_FF_brUn, out_ID_EX_FF_a_sel, out_ID_EX_FF_b_sel, out_ID_EX_FF_memRW, out_ID_EX_FF_regWEn;
	wire [3:0] out_ID_EX_FF_alu_sel;  
	wire [1:0] out_ID_EX_FF_wb_sel, out_ID_EX_FF_dataIn; 
	

	//MEM
	//###Datapath
	wire [31:0] out_MEM_pc_4, out_dataR, out_mux_wb;

	//###Value FF
	wire [31:0] out_EX_MEM_pc, out_EX_MEM_alu, out_EX_MEM_rs2, out_EX_MEM_inst;

	wire [2:0] out_EX_MEM_FF_dataOutAddj;
	wire out_EX_MEM_FF_memRW, out_EX_MEM_FF_regWEn; 
	wire [1:0] out_EX_MEM_FF_wb_sel, out_EX_MEM_FF_dataIn;
	

	//WB
	//###Datapath

	//###Value FF
	wire [31:0] out_MEM_WB_muxWB, out_MEM_WB_inst;

	wire out_MEM_WB_FF_regWEn;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	localparam period = 100;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	initial 
	begin
		clk=0;
	end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Note: Ngo reset IF_ID và reset ID_EX co 2 ngo vao cho 1 chan reset cua 2 bo flipflop => Can dung bo OR de and 2 gia tri lai truoc khi dua vao 2 ngo vao reset cua bo flipflop IF_ID và ID_EX

	// Branch Selection
	branch_Decision branch_decision_block (.clk(clk), .pc_ID(out_IF_ID_FF_pc), .inst_ID(out_IF_ID_FF_inst), .pc_EX(out_ID_EX_FF_pc), .inst_EX(out_ID_EX_FF_inst), .Brlt_EX(brlt), .Breq_EX(breq), .var_ALU(out_alu), 
					       .pc_sel(pc_sel), .pc_next(pc_next), .rs_IF_ID(rs_IF_ID_br), .rs_ID_EX(rs_ID_EX_br));

	

	//Block connect
	//IF
	mux4 muxPC_block (.in1(out_IF_pc_4), .in2(out_EX_pc_4), .in3(pc_next), .in4(out_alu), .out(out_mux_pc), .sel(pc_sel));

	PC pc_block(.clk(clk), .reset(rs_pc), .enable(en_pc), .in(out_mux_pc), .out(out_pc));

	PC_Plus_4 pc_plus_4_IF_block(.in(out_pc), .out(out_IF_pc_4));

	IMEM imem_block (.PC(out_pc), .inst(out_imem));



	//IF_ID
	IF_ID ff_IF_IF (.clk(clk), .reset(rs_IF_ID), .enable(en_IF_ID), 
			.if_pc(out_pc), .if_inst(out_imem), 
			.id_pc(out_IF_ID_FF_pc), .id_inst(out_IF_ID_FF_inst));



	//ID
	ROMControl control_block (.inst_30(out_IF_ID_FF_inst[30]), .inst_14_12(out_IF_ID_FF_inst[14:12]), .inst_6_2(out_IF_ID_FF_inst[6:2]), .inst_1_0(out_IF_ID_FF_inst[1:0]), .brEq(tmp1), .brLT(tmp2), 
				  .pc_sel(tmp), .imm_sel(out_ctrl_imm_sel), .brUn(out_ctrl_brUn), .a_sel(out_ctrl_a_sel), .b_sel(out_ctrl_b_sel), .alu_sel(out_ctrl_alu_sel), 
				  .memRW(out_ctrl_memRW), .regWEn(out_ctrl_regWEn), .wb_sel(out_ctrl_wb_sel), .dataIn(out_ctrl_dataIn), .dataOutAddj(out_ctrl_dataOutAddj));	

	register reg_block (.clk(clk), .RegWEn(out_MEM_WB_FF_regWEn), 
			    .AddrA(out_IF_ID_FF_inst[19:15]), .AddrB(out_IF_ID_FF_inst[24:20]), .AddrD(out_MEM_WB_inst[11:7]), 
			    .DataD(out_MEM_WB_muxWB), .DataA(data_rs1), .DataB(data_rs2));



	//ID_EX
	ID_EX ff_ID_EX (.clk(clk), .reset(rs_ID_EX), .enable(en_ID_EX), 
			.id_pc(out_IF_ID_FF_pc), .id_rs1(data_rs1), .id_rs2(data_rs2), .id_inst(out_IF_ID_FF_inst), 
			.id_MemRW(out_ctrl_memRW), .id_regWEn(out_ctrl_regWEn), .id_WBSel(out_ctrl_wb_sel), .id_ImmSel(out_ctrl_imm_sel), .id_AluSel(out_ctrl_alu_sel), .id_brun(out_ctrl_brUn), 
			.id_ASel(out_ctrl_a_sel), .id_BSel(out_ctrl_b_sel), .id_mem_ctrl_datain(out_ctrl_dataIn), .id_mem_ctrl_dataOutAddj(out_ctrl_dataOutAddj),
			.ex_pc(out_ID_EX_FF_pc), .ex_rs1(out_ID_EX_FF_rs1), .ex_rs2(out_ID_EX_FF_rs2), .ex_inst(out_ID_EX_FF_inst), 
			.ex_MemRW(out_ID_EX_FF_memRW), .ex_regWEn(out_ID_EX_FF_regWEn), .ex_WBSel(out_ID_EX_FF_wb_sel), .ex_ImmSel(out_ID_EX_FF_imm_sel), .ex_AluSel(out_ID_EX_FF_alu_sel), 
			.ex_brun(out_ID_EX_FF_brUn), .ex_ASel(out_ID_EX_FF_a_sel), .ex_BSel(out_ID_EX_FF_b_sel), .ex_mem_ctrl_datain(out_ID_EX_FF_dataIn), .ex_mem_ctrl_dataOutAddj(out_ID_EX_FF_dataOutAddj));




	//EX
	Forwarding forward_Control_block (.inst_t(out_ID_EX_FF_inst), .inst_t_1(out_EX_MEM_inst), .inst_t_2(out_MEM_WB_inst), .data_WB(out_MEM_WB_muxWB),
					  .enableFF(en_FF), .resetFF(rs_FF), .enablePC(en_pc), .A_sel(mux_fw_A_sel), .B_sel(mux_fw_B_sel), .data_last_load(data_last_load));

	assign en_IF_ID = en_FF[3];
	assign en_ID_EX = en_FF[2];
	assign en_EX_MEM = en_FF[1];
	assign en_MEM_WB = en_FF[0];

	assign rs_IF_ID_fw = rs_FF[3];
	assign rs_ID_EX_fw = rs_FF[2];
	assign rs_EX_MEM = rs_FF[1];
	assign rs_MEM_WB = rs_FF[0];

	//OR 2 gia tri trung gian lai de dua vao ngo reset cua 2 flipflip IF_ID vaf ID_EX
	assign rs_IF_ID = rs_IF_ID_fw | rs_IF_ID_br;
	assign rs_ID_EX = rs_ID_EX_fw | rs_ID_EX_br; 

	PC_Plus_4 pc_plus_4_EX_block(.in(out_ID_EX_FF_pc), .out(out_EX_pc_4));

	Imm_Gen imm_gen_block (.sel(out_ID_EX_FF_imm_sel), .in(out_ID_EX_FF_inst), .out(out_imm_gen));

	mux4 muxA_fw_block (.in1(out_ID_EX_FF_rs1), .in2(out_EX_MEM_alu), .in3(out_MEM_WB_muxWB), .in4(data_last_load), .out(out_mux_fw_A), .sel(mux_fw_A_sel));

	mux2 muxA_block (.in1(out_ID_EX_FF_pc), .in2(out_mux_fw_A), .out(out_mux_A), .sel(out_ID_EX_FF_a_sel));

	mux4 muxB_fw_block (.in1(out_ID_EX_FF_rs2), .in2(out_EX_MEM_alu), .in3(out_MEM_WB_muxWB), .in4(data_last_load), .out(out_mux_fw_B), .sel(mux_fw_B_sel));

	mux2 muxB_block (.in1(out_imm_gen), .in2(out_mux_fw_B), .out(out_mux_B), .sel(out_ID_EX_FF_b_sel));

	riscV_ALU alu_block (.sel(out_ID_EX_FF_alu_sel), .inA(out_mux_A), .inB(out_mux_B), .out(out_alu));

	branch branch_Comp_block (.BrUn(out_ID_EX_FF_brUn), .BrEq(breq), .BrLT(brlt), .In1(out_mux_fw_A), .In2(out_mux_fw_B));



	
	//EX_MEM
	EX_MEM ff_EX_MEM (.clk(clk), .reset(rs_EX_MEM), .enable(en_EX_MEM), 
			  .ex_alu(out_alu), .ex_pc(out_ID_EX_FF_pc), .ex_rs2(out_mux_fw_B), .ex_inst(out_ID_EX_FF_inst),
			  .ex_MemRW(out_ID_EX_FF_memRW), .ex_regWEn(out_ID_EX_FF_regWEn), .ex_WBSel(out_ID_EX_FF_wb_sel), 
			  .ex_mem_ctrl_datain(out_ID_EX_FF_dataIn), .ex_mem_ctrl_dataOutAddj(out_ID_EX_FF_dataOutAddj),
			  .mem_alu(out_EX_MEM_alu), .mem_pc(out_EX_MEM_pc), .mem_rs2(out_EX_MEM_rs2), .mem_inst(out_EX_MEM_inst),
			  .mem_MemRW(out_EX_MEM_FF_memRW), .mem_regWEn(out_EX_MEM_FF_regWEn), .mem_WBSel(out_EX_MEM_FF_wb_sel), 
			  .mem_ctrl_datain(out_EX_MEM_FF_dataIn), .mem_ctrl_dataOutAddj(out_EX_MEM_FF_dataOutAddj));





	//MEM
	PC_Plus_4 pc_plus_4_MEM_block (.in(out_EX_MEM_pc), .out(out_MEM_pc_4));

	DMEM dmem_block (.clk(clk), .MemRW(out_EX_MEM_FF_memRW) ,.Addr(out_EX_MEM_alu), .DataIn(out_EX_MEM_FF_dataIn), .DataOut(out_EX_MEM_FF_dataOutAddj), .DataW(out_EX_MEM_rs2), .DataR(out_dataR));

	mux4 muxWB_block (.in1(out_dataR), .in2(out_EX_MEM_alu), .in3(out_MEM_pc_4), .in4(32'b0), .out(out_mux_wb), .sel(out_EX_MEM_FF_wb_sel));





	//MEM_WB
	MEM_WB ff_MEM_WB (.clk(clk), .reset(rs_MEM_WB), .enable(en_MEM_WB),
			 .mem_rd(out_mux_wb), .mem_inst(out_EX_MEM_inst), 
			 .mem_regWEn(out_EX_MEM_FF_regWEn),
			 .wb_rd(out_MEM_WB_muxWB), .wb_inst(out_MEM_WB_inst),
			 .wb_regWEn(out_MEM_WB_FF_regWEn));

	//WB

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

	always 
	#period 
	begin
		num_pulse = num_pulse + 1;
		clk=~clk;
	end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

endmodule
