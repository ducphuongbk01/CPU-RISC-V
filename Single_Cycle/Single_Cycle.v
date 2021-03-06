`timescale 1 ps/10 fs  // time-unit = 1 ps, precision = 1 fs

module Single_Cycle;
	reg clk=0;
	integer num_pulse = 0;
	reg reset=0;
	wire [31:0] out_mux_pc, out_pc, out_imem, out_pc_4, out_data_A, out_data_B, out_mux_A, out_mux_B, out_alu, out_dmem, out_mux_wb, out_imm_gen;
	wire out_breq, out_brlt; 
	wire [1:0] out_ctrl_datain, out_ctrl_wb_sel;
	wire [2:0] out_ctrl_imm_sel, out_ctrl_dataout;
	wire [3:0] out_ctrl_alu_sel;
	wire out_ctrl_pc_sel, out_ctrl_regwen_sel, out_ctrl_brun, out_ctrl_asel, out_ctrl_bsel, out_ctrl_memrw;
	reg initial_value = 32'h0000_0000;

	localparam period = 400;
	
	initial 
	begin
		clk=0;
	end

//PC
	PC pc_block(.reset(reset), .clk(clk), .in(out_mux_pc), .out(out_pc));
//DMEM
	DMEM dmem_block (.clk(clk), .MemRW(out_ctrl_memrw) ,.Addr(out_alu), .DataIn(out_ctrl_datain), .DataOut(out_ctrl_dataout), .DataW(out_data_B), .DataR(out_dmem));
//Register
	register reg_block (.clk(clk), .RegWEn(out_ctrl_regwen_sel), .AddrA(out_imem[19:15]), .AddrB(out_imem[24:20]), .AddrD(out_imem[11:7]), .DataD(out_mux_wb), .DataA(out_data_A), .DataB(out_data_B));
//ALU
	riscV_ALU ALU(.sel(out_ctrl_alu_sel), .inA(out_mux_A), .inB(out_mux_B), .out(out_alu));
//IMEM
	IMEM imem_block (.PC(out_pc), .inst(out_imem));
//Control
	ROMControl ctrl(.inst_30(out_imem[30]), .inst_14_12(out_imem[14:12]), .inst_6_2(out_imem[6:2]), .brEq(out_breq), .brLT(out_brlt), 
			.pc_sel(out_ctrl_pc_sel), .imm_sel(out_ctrl_imm_sel), .brUn(out_ctrl_brun), .a_sel(out_ctrl_asel), .b_sel(out_ctrl_bsel), .alu_sel(out_ctrl_alu_sel), 
			.memRW(out_ctrl_memrw), .regWEn(out_ctrl_regwen_sel), .wb_sel(out_ctrl_wb_sel), .dataIn(out_ctrl_datain), .dataOutAddj(out_ctrl_dataout));
//Imm Gen
	Imm_Gen gen(.sel(out_ctrl_imm_sel), .in(out_imem), .out(out_imm_gen));
//Branch
	branch br(.BrUn(out_ctrl_brun), .BrEq(out_breq), .BrLT(out_brlt), .In1(out_data_A), .In2(out_data_B));
//Mux A
	mux2 mux_A(.in1(out_pc), .in2(out_data_A), .out(out_mux_A), .sel(out_ctrl_asel));
//Mux B
	mux2 mux_B(.in1(out_imm_gen), .in2(out_data_B), .out(out_mux_B), .sel(out_ctrl_bsel));

//Mux WB
	mux4 mux_wb(.in1(out_dmem), .in2(out_alu), .in3(out_pc_4), .in4(32'h0000_0000), .out(out_mux_wb), .sel(out_ctrl_wb_sel));
//PC + 4
	PC_Plus_4 PC_4(.in(out_pc), .out(out_pc_4));	
//Mux PC	
	mux2 mux_PC(.in1(out_alu), .in2(out_pc_4), .out(out_mux_pc), .sel(out_ctrl_pc_sel));


	always 
	#period 
	begin
		clk=~clk;
		num_pulse = num_pulse + 1;
	end

endmodule
