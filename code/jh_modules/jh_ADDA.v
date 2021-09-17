module jh_ADDA (
input		          		CLOCK_50,
input		          		CLOCK_65,
output		          	ADC_CLK_A,
output		          	ADC_CLK_B,
input		    [13:0]		ADC_DA,
input		    [13:0]		ADC_DB,
output		          	ADC_OEB_A,
output		          	ADC_OEB_B,
input		          		ADC_OTR_A,
input		          		ADC_OTR_B,
output		          	DAC_CLK_A,
output		          	DAC_CLK_B,
output       [13:0]		DAC_DA,
output		 [13:0]		DAC_DB,
output		          	DAC_MODE,
output		          	DAC_WRT_A,
output		          	DAC_WRT_B,
output		        		POWER_ON,
output                  OSC_SMA_ADC4,
output                  SMA_DAC4,
input							DAC_rst,
input			[5:0]			gain,
output		[13:0]		ADC_out_A,
output		[13:0]		ADC_out_B
						);

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [13:0] rom_memory [99:0];		// 50 Mhz/100 sample = 500 Khz sine wave 
integer i;

initial begin
	i = 0;
	rom_memory[0] = 8192; 
	rom_memory[1] = 8706; 
	rom_memory[2] = 9218; 
	rom_memory[3] = 9726; 
	rom_memory[4] = 10229; 
	rom_memory[5] = 10723; 
	rom_memory[6] = 11207; 
	rom_memory[7] = 11679; 
	rom_memory[8] = 12138; 
	rom_memory[9] = 12581; 
	rom_memory[10] = 13006; 
	rom_memory[11] = 13413; 
	rom_memory[12] = 13799; 
	rom_memory[13] = 14163; 
	rom_memory[14] = 14503; 
	rom_memory[15] = 14819; 
	rom_memory[16] = 15108; 
	rom_memory[17] = 15370; 
	rom_memory[18] = 15603; 
	rom_memory[19] = 15808; 
	rom_memory[20] = 15982; 
	rom_memory[21] = 16126; 
	rom_memory[22] = 16238; 
	rom_memory[23] = 16318; 
	rom_memory[24] = 16367; 
	rom_memory[25] = 16383; 
	rom_memory[26] = 16367; 
	rom_memory[27] = 16318; 
	rom_memory[28] = 16238; 
	rom_memory[29] = 16126; 
	rom_memory[30] = 15982; 
	rom_memory[31] = 15808; 
	rom_memory[32] = 15603; 
	rom_memory[33] = 15370; 
	rom_memory[34] = 15108; 
	rom_memory[35] = 14819; 
	rom_memory[36] = 14503; 
	rom_memory[37] = 14163; 
	rom_memory[38] = 13799; 
	rom_memory[39] = 13413; 
	rom_memory[40] = 13006; 
	rom_memory[41] = 12581; 
	rom_memory[42] = 12138; 
	rom_memory[43] = 11679; 
	rom_memory[44] = 11207; 
	rom_memory[45] = 10723; 
	rom_memory[46] = 10229; 
	rom_memory[47] = 9726; 
	rom_memory[48] = 9218; 
	rom_memory[49] = 8706; 
	rom_memory[50] = 8192; 
	rom_memory[51] = 7677; 
	rom_memory[52] = 7165; 
	rom_memory[53] = 6657; 
	rom_memory[54] = 6154; 
	rom_memory[55] = 5660; 
	rom_memory[56] = 5176; 
	rom_memory[57] = 4704; 
	rom_memory[58] = 4245; 
	rom_memory[59] = 3802; 
	rom_memory[60] = 3377; 
	rom_memory[61] = 2970; 
	rom_memory[62] = 2584; 
	rom_memory[63] = 2220; 
	rom_memory[64] = 1880; 
	rom_memory[65] = 1564; 
	rom_memory[66] = 1275; 
	rom_memory[67] = 1013; 
	rom_memory[68] = 780; 
	rom_memory[69] = 575; 
	rom_memory[70] = 401; 
	rom_memory[71] = 257; 
	rom_memory[72] = 145; 
	rom_memory[73] = 65; 
	rom_memory[74] = 16; 
	rom_memory[75] = 0; 
	rom_memory[76] = 16; 
	rom_memory[77] = 65; 
	rom_memory[78] = 145; 
	rom_memory[79] = 257; 
	rom_memory[80] = 401; 
	rom_memory[81] = 575; 
	rom_memory[82] = 780; 
	rom_memory[83] = 1013; 
	rom_memory[84] = 1275; 
	rom_memory[85] = 1564; 
	rom_memory[86] = 1880; 
	rom_memory[87] = 2220; 
	rom_memory[88] = 2584; 
	rom_memory[89] = 2970; 
	rom_memory[90] = 3377; 
	rom_memory[91] = 3802; 
	rom_memory[92] = 4245; 
	rom_memory[93] = 4704; 
	rom_memory[94] = 5176; 
	rom_memory[95] = 5660; 
	rom_memory[96] = 6154; 
	rom_memory[97] = 6657; 
	rom_memory[98] = 7165; 
	rom_memory[99] = 7677; 
end



//=======================================================
//  Structural coding
//=======================================================
////////////////////////////////////////////
// DAC for signal generator
reg		 [19:0]		sin_out;

assign  DAC_WRT_A = ~CLOCK_50;      //Input write signal for PORT A
assign  DAC_MODE = 1; 		       	//Mode Select. 1 = dual port, 0 = interleaved.
assign  DAC_CLK_A = ~CLOCK_50; 	   //PLL Clock to DAC_A
assign  DAC_DA = sin_out[13:0];				// A			
assign  POWER_ON  = 1;            //Disable OSC_SMA


always @(posedge CLOCK_50)											
begin
		i = i + 1;
		if(i == 100) i = 0;
		if (DAC_rst) 
			//sin_out = 8192;
			sin_out = 0;
		else	begin
			if (gain == 0) sin_out = 0;//sin_out = 8192;
			else	sin_out = (rom_memory[i] * gain) >> 6;
			 
		end 
		
end


/////////////////////////////////////////
// ADC for monitoring voltage
reg		 [13:0]		r_ADC_DA;
reg		 [13:0]		r_ADC_DB;

assign  ADC_OEB_A = 0; 		  	    //ADC_OEA	0: enable, 1: disable
assign  ADC_OEB_B = 0; 		  	    //ADC_OEA	0: enable, 1: disable
assign  ADC_CLK_A = ~CLOCK_50;
assign  ADC_CLK_B = ~CLOCK_50;  	    //PLL Clock to ADC_B
assign  ADC_out_A = r_ADC_DA;
assign  ADC_out_B = r_ADC_DB;

always @ (posedge CLOCK_65) 
begin
	r_ADC_DA <= ADC_DA;
	r_ADC_DB <= ADC_DB;
end

endmodule