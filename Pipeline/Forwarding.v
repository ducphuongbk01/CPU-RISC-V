module Forwarding(inst_t, inst_t_1, inst_t_2, data_WB, enableFF, resetFF, enablePC, A_sel, B_sel, data_last_load);
input [31:0] inst_t, inst_t_1, inst_t_2, data_WB;
output reg [3:0] enableFF, resetFF;
output reg enablePC;
output reg [1:0] A_sel, B_sel;
output reg [31:0] data_last_load;

reg [1:0] double_load_check;
reg [31:0] data_double_load;
reg [2:0] chech_state;

initial
begin
	double_load_check= 2'b00;
	data_double_load = 32'b0;
end

always @(*)
	begin
		if(inst_t[1:0] === 2'b11)
		begin
			if (((double_load_check === 2'b01) || (double_load_check === 2'b10)) && (inst_t_1[1:0] !== 2'b11) && (inst_t_2[6:0] === 7'b0000011)) 
			begin
				chech_state = 3'b001;
				data_last_load = data_double_load;
				
				enableFF = 4'b1111;
				resetFF = 4'b0000; 
				enablePC = 1'b1; 
				
				if(double_load_check === 2'b01)
				begin
					A_sel = 2'b10;
					B_sel = 2'b11;
				end
				else
				begin
					A_sel = 2'b11;
					B_sel = 2'b10;
				end

				double_load_check = 2'b00;
				data_double_load = 32'b0;
			end

			// inst_MEM = NOP and inst_WB = NOP
			else if((inst_t_1[1:0] !== 2'b11) && (inst_t_2[1:0] !== 2'b11))
			begin
				chech_state = 3'b010;
				enableFF = 4'b1111;
				resetFF = 4'b0000; 
				enablePC = 1'b1; 
				A_sel = 2'b00;
				B_sel = 2'b00;
			end
			// inst_MEM = NOP and inst_WB is not NOP
			else if((inst_t_1[1:0] !== 2'b11) && (inst_t_2[1:0] === 2'b11))
			begin
				chech_state = 3'b011;
				enableFF = 4'b1111;
				resetFF = 4'b0000; 
				enablePC = 1'b1;
				if((inst_t[6:2] === 5'b01101) || (inst_t[6:2] === 5'b00101) || (inst_t[6:2] === 5'b11011))
				begin
					A_sel = 2'bxx;
					B_sel = 2'bxx;
				end
				else
				begin
					if(inst_t[19:15] === inst_t_2[11:7])
						A_sel = 2'b10;
					else
						A_sel = 2'b00;

					if((inst_t[6:2] === 5'b01100) || (inst_t[6:2] === 5'b01000) || (inst_t[6:2] === 5'b11000))
					begin
						if(inst_t[24:20] === inst_t_2[11:7])
							B_sel = 2'b10;
						else
							B_sel = 2'b00;
					end
					else
						B_sel = 2'bxx;
				end			
			end
			// inst_MEM is not NOP and inst_WB = NOP
			else if((inst_t_1[1:0] === 2'b11) && (inst_t_2[1:0] !== 2'b11))
			begin
				chech_state = 3'b100;
				if(inst_t_1[6:2] === 5'b00000)
				begin
					enableFF = 4'b0011;
					resetFF = 4'b0010; 
					enablePC = 1'b0;
					A_sel = 2'bxx;
					B_sel = 2'bxx;				
				end
				else
				begin
					enableFF = 4'b1111;
					resetFF = 4'b0000; 
					enablePC = 1'b1;

					if((inst_t[6:2] === 5'b01101) || (inst_t[6:2] === 5'b00101) || (inst_t[6:2] === 5'b11011))
					begin
						A_sel = 2'bxx;
						B_sel = 2'bxx;
					end
					else
					begin
						if(inst_t[19:15] === inst_t_1[11:7])
							A_sel = 2'b01;
						else
							A_sel = 2'b00;

						if((inst_t[6:2] === 5'b01100) || (inst_t[6:2] === 5'b01000) || (inst_t[6:2] === 5'b11000))
						begin
							if(inst_t[24:20] === inst_t_1[11:7])
								B_sel = 2'b01;
							else
								B_sel = 2'b00;
						end
						else
							B_sel = 2'bxx;
					end	
				end		
			end
			// inst_MEM and inst_WB are not NOP
			else if((inst_t_1[1:0] === 2'b11) && (inst_t_2[1:0] === 2'b11))
			begin
				chech_state = 3'b101;
				if(inst_t_1[6:2] === 5'b00000)
				begin
					enableFF = 4'b0011;
					resetFF = 4'b0010; 
					enablePC = 1'b0;
					A_sel = 2'bxx;
					B_sel = 2'bxx;				
				end
				else
				begin
					enableFF = 4'b1111;
					resetFF = 4'b0000; 
					enablePC = 1'b1;

					if((inst_t[6:2] === 5'b01101) || (inst_t[6:2] === 5'b00101) || (inst_t[6:2] === 5'b11011))
					begin
						A_sel = 2'bxx;
						B_sel = 2'bxx;
					end
					else
					begin
						if(inst_t[19:15] === inst_t_1[11:7])
							A_sel = 2'b01;
						else if(inst_t[19:15] === inst_t_2[11:7])
							A_sel = 2'b10;
						else
							A_sel = 2'b00;

						if((inst_t[6:2] === 5'b01100) || (inst_t[6:2] === 5'b01000) || (inst_t[6:2] === 5'b11000))
						begin
							if(inst_t[24:20] === inst_t_1[11:7])
								B_sel = 2'b01;
							else if(inst_t[24:20] === inst_t_2[11:7])
								B_sel = 2'b10;
							else	
								B_sel = 2'b00;
						end
						else
							B_sel = 2'bxx;
					end	
				end			
			end
			//Other issue
			else
			begin
				chech_state = 3'b110;
				enableFF = 4'b1111;
				resetFF = 4'b0000; 
				enablePC = 1'b1;
				A_sel = 2'b00;
				B_sel = 2'b00;			
			end
		end
		else
		begin
			chech_state = 3'b111;
			enableFF = 4'b1111;
			resetFF = 4'b0000; 
			enablePC = 1'b1;
			A_sel = 2'bxx;
			B_sel = 2'bxx;			
		end
	end

always @(*)
begin
	if(((inst_t[6:2] === 5'b01100) || (inst_t[6:2] === 5'b01000) || (inst_t[6:2] === 5'b11000)) && (inst_t_1[6:0] === 7'b0000011) && (inst_t_2[6:0] === 7'b0000011))
	begin
		if((inst_t[19:15] === inst_t_1[11:7]) && (inst_t[24:20] === inst_t_2[11:7]))
		begin
			double_load_check = 2'b01;
			data_double_load = data_WB;			
		end
		else if((inst_t[19:15] === inst_t_2[11:7]) && (inst_t[24:20] === inst_t_1[11:7]))
		begin
			double_load_check = 2'b10;
			data_double_load = data_WB;
		end
		else
		begin
			double_load_check = 2'b00;
			data_double_load = 32'b0;
		end
	end
end
endmodule





