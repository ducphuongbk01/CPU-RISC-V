module ROMControl(inst_30, inst_14_12, inst_6_2, brEq, brLT, 
		pc_sel, imm_sel, brUn, a_sel, b_sel, alu_sel, memRW, regWEn, wb_sel, dataIn, dataOutAddj);
	input inst_30;
	input [2:0] inst_14_12;
	input [4:0] inst_6_2;
	input brEq, brLT;
	output reg pc_sel, brUn, a_sel, b_sel, memRW, regWEn;
	output reg [1:0] wb_sel, dataIn;
	output reg [2:0] imm_sel, dataOutAddj;
	output reg [3:0] alu_sel;
	reg [8:0] addr;
	reg [19:0] data;

	always @(inst_30 or inst_14_12 or inst_6_2 or brEq or brLT)
	begin
		addr = {inst_30, inst_14_12, inst_6_2};
		case(inst_6_2)
		12: //R Type
			begin
			case(addr)
			//ADD
				12: data = 20'b 0_xxx_x_0_0_0000_0_1_01_xx_xxx;

			//SUB
				268: data = 20'b 0_xxx_x_0_0_0001_0_1_01_xx_xxx;

			//SLL
				44: data = 20'b 0_xxx_x_0_0_0010_0_1_01_xx_xxx;

			//SLT
				76: data = 20'b 0_xxx_x_0_0_0101_0_1_01_xx_xxx;

			//SLTU
				108: data = 20'b 0_xxx_x_0_0_0110_0_1_01_xx_xxx;

			//XOR
				140: data = 20'b 0_xxx_x_0_0_1001_0_1_01_xx_xxx;

			//SRL
				172: data = 20'b 0_xxx_x_0_0_0011_0_1_01_xx_xxx;

			//SRA
				428: data = 20'b 0_xxx_x_0_0_0100_0_1_01_xx_xxx;

			//OR
				204: data = 20'b 0_xxx_x_0_0_1000_0_1_01_xx_xxx;

			//AND
				236: data = 20'b 0_xxx_x_0_0_0111_0_1_01_xx_xxx;

				default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
			endcase
			end
		4: //I Type 1
			begin
			case(inst_14_12)
			//ADDI
				0: data = 20'b 0_000_x_0_1_0000_0_1_01_xx_xxx;

			//SLTI
				2: data = 20'b 0_000_x_0_1_0101_0_1_01_xx_xxx;

			//SLTIU
				3: data = 20'b 0_001_x_0_1_0110_0_1_01_xx_xxx;

			//XORI
				4: data = 20'b 0_000_x_0_1_1001_0_1_01_xx_xxx;

			//ORI
				6: data = 20'b 0_000_x_0_1_1000_0_1_01_xx_xxx;

			//ANDI
				7: data = 20'b 0_000_x_0_1_0111_0_1_01_xx_xxx;


				1: 
				begin
			//SLLI
				if (inst_30==0)
					data = 20'b 0_010_x_0_1_0010_0_1_01_xx_xxx;
				else
					data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
				end


				5: 
				begin
			//SRLI
				if (inst_30==0)
					data = 20'b 0_010_x_0_1_0011_0_1_01_xx_xxx;
			//SRAI
				else
					data = 20'b 0_010_x_0_1_0100_0_1_01_xx_xxx;
				end

				default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
			endcase
			end

		0: //I Type 2
			begin
			case(inst_14_12)
			//LB
				0: data = 20'b 0_000_x_0_1_0000_0_1_00_xx_001;

			//LH
				2: data = 20'b 0_000_x_0_1_0000_0_1_00_xx_010;

			//LW
				3: data = 20'b 0_000_x_0_1_0000_0_1_00_xx_000;

			//LBU
				4: data = 20'b 0_000_x_0_1_0000_0_1_00_xx_101;
 
			//LHU
				6: data = 20'b 0_000_x_0_1_0000_0_1_00_xx_110;

				default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
			endcase
			end

		8: //S Type
			begin
			case(inst_14_12)
			//SB
				0: data = 20'b 0_011_x_0_1_0000_1_0_xx_01_xxx;

			//SH
				1: data = 20'b 0_011_x_0_1_0000_1_0_xx_10_xxx;

			//SW
				2: data = 20'b 0_011_x_0_1_0000_1_0_xx_00_xxx;

				default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
			endcase
			end

		24: //B Type
			begin
			case(inst_14_12)
			//BEQ
				0: 
				begin
				if (brEq==1)
					data = 20'b 1_100_0_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_0_1_1_0000_0_0_xx_xx_xxx;
				end

			//BNE
				1:
				begin
				if (brEq==0)
					data = 20'b 1_100_0_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_0_1_1_0000_0_0_xx_xx_xxx;
				end

			//BLT
				4: 
				begin
				if (brLT==1)
					data = 20'b 1_100_0_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_0_1_1_0000_0_0_xx_xx_xxx;
				end

			//BGE
				5: 
				begin
				if (brEq==1)
					data = 20'b 1_100_0_1_1_0000_0_0_xx_xx_xxx;
				else if((brEq==0) && (brLT==0))
					data = 20'b 1_100_0_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_0_1_1_0000_0_0_xx_xx_xxx;
				end

			//BLTU
				6: 
				begin
				if (brLT==1)
					data = 20'b 1_100_1_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_1_1_1_0000_0_0_xx_xx_xxx;
				end

			//BGEU
				7: 
				begin
				if (brEq==1)
					data = 20'b 1_100_1_1_1_0000_0_0_xx_xx_xxx;
				else if((brEq==0) && (brLT==0))
					data = 20'b 1_100_1_1_1_0000_0_0_xx_xx_xxx;
				else
					data = 20'b 0_100_1_1_1_0000_0_0_xx_xx_xxx;
				end

				default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
			endcase
			end

		//U Type
		//LUI
		13: data = 20'b 0_101_x_x_1_1010_0_1_01_xx_000;

		//AUIPC
		5: data = 20'b 0_101_x_1_1_0000_0_1_01_xx_000;


		//J Type
		//JAL
		27: data = 20'b 1_110_x_1_1_0000_0_1_10_xx_xxx;

		//JALR
		25: data = 20'b 1_000_x_0_1_0000_0_1_10_xx_xxx;

		default: data = 20'b x_xxx_x_x_x_xxxx_x_x_xx_xx_xxx;
		endcase
		
		pc_sel = data[19]; 
		brUn = data[15]; 
		a_sel = data[14]; 
		b_sel = data[13]; 
		memRW = data[8]; 
		regWEn = data[7];
		wb_sel = data[6:5]; 
		dataIn = data[4:3];
		imm_sel = data[18:16]; 
		dataOutAddj = data[2:0];
		alu_sel = data[12:9];
	end
endmodule

