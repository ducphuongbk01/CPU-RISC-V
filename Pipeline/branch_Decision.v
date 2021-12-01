module branch_Decision(clk, pc_ID, inst_ID, pc_EX, inst_EX, Brlt_EX, Breq_EX, var_ALU, pc_sel, pc_next, rs_IF_ID, rs_ID_EX);
	input [31:0] pc_ID, inst_ID, pc_EX, inst_EX, var_ALU;
	input Brlt_EX, Breq_EX;
	input clk;
	output reg [31:0] pc_next;
	output reg rs_IF_ID, rs_ID_EX;
	output reg [1:0] pc_sel;

	parameter SIZE_PC = 1<<18;	
	parameter SIZE_BHT = (1<<8)-1;

	reg [1:0] pc_sel_ID; 
	reg pc_sel_EX, exist_pc, out_BHT, pc_sel_ID_t_1;
	reg [1:0] pc_sel_tmp;

	reg [31:0] PC_lookup [0:SIZE_PC][0:1];
	reg [7:0] Patience_lookup [0:SIZE_PC];
	reg [1:0] BHT [0:SIZE_BHT];

	reg [1:0] BHT_check;
	reg [7:0] Patience_check;

	integer i;

	initial
	begin
		pc_sel_ID = 2'b00;
		pc_sel_EX = 1'b0; 
		exist_pc = 1'b0; 
		out_BHT = 1'b0;
		pc_sel_ID_t_1 = 1'b0;
		pc_sel_tmp = 2'b00;
		for (i=0; i<=SIZE_PC; i=i+1)
		begin
			Patience_lookup[i] = 8'b0;
			PC_lookup[i][0] = 32'b0;
			PC_lookup[i][1] = 32'b0;
		end
		for (i=0; i<=SIZE_BHT; i=i+1)
		begin
			BHT[i] = 2'b00;
		end
	end

	
	always @(pc_ID, inst_ID, pc_EX, inst_EX, Brlt_EX, Breq_EX, var_ALU, pc_sel_ID, 
		 pc_sel_EX, exist_pc, out_BHT, pc_sel_ID_t_1, pc_sel_tmp)
	begin
		//ID
		//Branch
		if ((inst_ID[6:2]==5'b11000) || (inst_ID[6:2]==5'b11011) || (inst_ID[6:2]==5'b11001))
		begin
			pc_next = PC_lookup[pc_ID[9:2]][1];
			if (PC_lookup[pc_ID[9:2]][0] === pc_ID[31:10])
				exist_pc = 1'b1;
			else
				exist_pc = 1'b0;
			
			if (BHT[Patience_lookup[pc_ID]] == 2'b00)
				out_BHT = 1'b0;
			else if (BHT[Patience_lookup[pc_ID]] == 2'b01)
				out_BHT = 1'b0;
			else if (BHT[Patience_lookup[pc_ID]] == 2'b10)
				out_BHT = 1'b1;
			else
				out_BHT = 1'b1;

			if (exist_pc && out_BHT)
				pc_sel_ID = 2'b10;
			else
				pc_sel_ID = 2'b00;
		end
		//NOT Branch
		else
			pc_sel_ID = 2'b00;

		
		//EX
		//Branch
		if ((inst_EX[6:2]==5'b11000) || (inst_EX[6:2]==5'b11011) || (inst_EX[6:2]==5'b11001))
		begin
			//BRANCH
			if(inst_EX[6:2]==5'b11000)
			begin
				case(inst_EX[14:12])
					0:
					begin
						if(Breq_EX == 1'b1)
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
					1:
					begin
						if(Breq_EX == 1'b0)
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
					4:
					begin
						if(Brlt_EX == 1'b1)
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
					5:
					begin
						if(Breq_EX == 1'b1)
							pc_sel_EX = 1'b1;
						else if ((Breq_EX == 1'b0) && (Brlt_EX == 1'b0))
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
					6:
					begin
						if(Brlt_EX == 1'b1)
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
					7:
					begin
						if(Breq_EX == 1'b1)
							pc_sel_EX = 1'b1;
						else if ((Breq_EX == 1'b0) && (Brlt_EX == 1'b0))
							pc_sel_EX = 1'b1;
						else
							pc_sel_EX = 1'b0;
					end
				endcase
			end
			
			//JUMP
			else
				pc_sel_EX = 1'b1;

			//Update
			if ((pc_sel_EX == 1'b1) && (pc_sel_ID_t_1 == 1'b1))
			begin
				rs_IF_ID = 1'b0;
				rs_ID_EX = 1'b0;
				pc_sel_tmp = pc_sel_ID;
			end
			else if ((pc_sel_EX == 1'b1) && (pc_sel_ID_t_1 == 1'b0))
			begin
				rs_IF_ID = 1'b1;
				rs_ID_EX = 1'b1;
				pc_sel_tmp = 2'b11;
				PC_lookup[pc_EX[9:2]][0] = pc_EX[31:10];
				PC_lookup[pc_EX[9:2]][1] = var_ALU;
			end
			else if ((pc_sel_EX == 1'b0) && (pc_sel_ID_t_1 == 1'b1))
			begin
				rs_IF_ID = 1'b1;
				rs_ID_EX = 1'b1;
				pc_sel_tmp = 2'b01;
			end
			else if ((pc_sel_EX == 1'b0) && (pc_sel_ID_t_1 == 1'b0))
			begin
				rs_IF_ID = 1'b0;
				rs_ID_EX = 1'b0;
				pc_sel_tmp = pc_sel_ID;
			end


			//END
			pc_sel = pc_sel_tmp;
		end

		//No Branch
		else
		begin
			pc_sel_ID_t_1 = 1'b0;
			pc_sel = 2'b00;
			rs_IF_ID = 1'b0;
			rs_ID_EX = 1'b0;
		end
	end

	always @(posedge clk)
	begin
		if ((inst_EX[6:2]==5'b11000) || (inst_EX[6:2]==5'b11011) || (inst_EX[6:2]==5'b11001))
		begin
			BHT_check = BHT[Patience_lookup[pc_EX]];
			Patience_check = Patience_lookup[pc_EX];

			//Update Patience Lookup table and PC Lookup table
			if ((pc_sel_EX == 1'b1) && (pc_sel_ID_t_1 == 1'b0))
				Patience_lookup[pc_EX] = Patience_lookup[pc_EX]*2+1;
			else if ((pc_sel_EX == 1'b0) && (pc_sel_ID_t_1 == 1'b1))
				Patience_lookup[pc_EX] = Patience_lookup[pc_EX]*2+0;

			//FSM --> Update BHT table
			if ((pc_sel_EX == 1'b0) && (BHT[Patience_lookup[pc_EX]] == 2'b00))
				BHT[Patience_lookup[pc_EX]] = 2'b00;
			else if ((pc_sel_EX == 1'b1) && (BHT[Patience_lookup[pc_EX]] == 2'b11))
				BHT[Patience_lookup[pc_EX]] = 2'b11;
			else if ((pc_sel_EX == 1'b1) && (BHT[Patience_lookup[pc_EX]] == 2'b00))
				BHT[Patience_lookup[pc_EX]] = 2'b01;
			else if ((pc_sel_EX == 1'b0) && (BHT[Patience_lookup[pc_EX]] == 2'b01))
				BHT[Patience_lookup[pc_EX]] = 2'b00;
			else if ((pc_sel_EX == 1'b1) && (BHT[Patience_lookup[pc_EX]] == 2'b01))
				BHT[Patience_lookup[pc_EX]] = 2'b11;
			else if ((pc_sel_EX == 1'b0) && (BHT[Patience_lookup[pc_EX]] == 2'b11))
				BHT[Patience_lookup[pc_EX]] = 2'b10;
			else if ((pc_sel_EX == 1'b1) && (BHT[Patience_lookup[pc_EX]] == 2'b10))
				BHT[Patience_lookup[pc_EX]] = 2'b11;
			else if ((pc_sel_EX == 1'b0) && (BHT[Patience_lookup[pc_EX]] == 2'b10))
				BHT[Patience_lookup[pc_EX]] = 2'b00;

			BHT_check = BHT[Patience_lookup[pc_EX]];
			Patience_check = Patience_lookup[pc_EX];
		end

		// Update last state
		if ((pc_sel_tmp == 2'b10) || (pc_sel_tmp == 2'b11))
			pc_sel_ID_t_1 = 1'b1;
		else
			pc_sel_ID_t_1 = 1'b0;
	end
endmodule
