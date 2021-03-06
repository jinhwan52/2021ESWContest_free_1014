////////////////////////////////////////
//Modified IEEE singl precision FP
//bit [26]		Sign		(0: pos, 1: neg)
//bit [25:18]	Exponent	(unsigned)
//bit	[17:0]	Fraction	(unsigned)
//No infinity, no NAN, no denorms.
//number length = 27 bit (1/8/18) (It can be saved at 20 bit M10K blocks of CyclonV)
//Reference: https://people.ece.cornell.edu/land/courses/ece5760/FloatingPoint/index.html
//Reference: https://people.ece.cornell.edu/land/courses/ece5760/StudentWork/mje56/FPmath.v
///////////////////////////////////////

///////////////////////////////////////////
// Floating point multipier
// Combinational
///////////////////////////////////////////
module fp_multi
#(parameter number_length = 27,
				exponent_length = 8,
				fraction_length = 18)
(
	input [number_length-1:0] in_A,
	input [number_length-1:0] in_B,
	output [number_length-1:0] out_Prod
);
	//Sign, Exponent, and Faction of in_A and in_B
	wire								A_s;
	wire [exponent_length-1:0]	A_e;
	wire [fraction_length-1:0]	A_f;
	wire								B_s;
	wire [exponent_length-1:0]	B_e;
	wire [fraction_length-1:0]	B_f;
	assign A_s = in_A[number_length-1];
	assign A_e = in_A[number_length-2:fraction_length];
	assign A_f = {1'b1, in_A[fraction_length-1:1]};			// Hidden bit and No round
	assign B_s = in_B[number_length-1];
	assign B_e = in_B[number_length-2:fraction_length];
	assign B_f = {1'b1, in_B[fraction_length-1:1]};

    // XOR sign bits to determine product sign.
	wire        out_Prod_s;
	assign out_Prod_s = A_s ^ B_s;

	// Multiply the fractions of A and B
	wire [fraction_length+fraction_length-1:0] pre_prod_frac;
	assign pre_prod_frac = A_f * B_f;

	// Add exponents of A and B
	wire [exponent_length:0]  pre_prod_exp;		// 1 bit added for overflow 
	assign pre_prod_exp = A_e + B_e;

	// If top bit of product frac is 0, shift left one
	wire [exponent_length-1:0] out_Prod_e;
	wire [fraction_length-1:0] out_Prod_f;
	assign out_Prod_e = pre_prod_frac[fraction_length+fraction_length-1] ? (pre_prod_exp-9'd126) : (pre_prod_exp - 9'd127); //Becuase left one shift (exp-1)
	assign out_Prod_f = pre_prod_frac[fraction_length+fraction_length-1] ? pre_prod_frac[fraction_length+fraction_length-2:fraction_length-1] : 
																							  pre_prod_frac[fraction_length+fraction_length-3:fraction_length-2];

	// Detect underflow
	wire        underflow;
	assign underflow = pre_prod_exp < 9'h80;

	// Detect zero conditions (either product frac doesn't start with 1, or underflow)
	assign out_Prod = underflow     	  ? 27'b0 :
							(B_e == 8'd0)    ? 27'b0 :
							(A_e == 8'd0)    ? 27'b0 :
							{out_Prod_s, out_Prod_e, out_Prod_f};

endmodule

///////////////////////////////////////////
// Floating point adder
// 2-stage pipeline
///////////////////////////////////////////
module fp_adder 
#(parameter number_length = 27,
				exponent_length = 8,
				fraction_length = 18)
(
	input clock,
	input [number_length-1:0] in_A,
	input [number_length-1:0] in_B,
	output [number_length-1:0] out_Sum
);
		
	//Sign, Exponent, and Faction of in_A and in_B
	wire								A_s;
	wire [exponent_length-1:0]	A_e;
	wire [fraction_length-1:0]	A_f;
	wire								B_s;
	wire [exponent_length-1:0]	B_e;
	wire [fraction_length-1:0]	B_f;
	
	assign A_s = in_A[number_length-1];
	assign A_e = in_A[number_length-2:fraction_length];
	assign A_f = {1'b1, in_A[fraction_length-1:1]};			// Hidden bit and No round
	assign B_s = in_B[number_length-1];
	assign B_e = in_B[number_length-2:fraction_length];
	assign B_f = {1'b1, in_B[fraction_length-1:1]};
	
	//Shiftted fractions of A and B to align
	wire [exponent_length-1:0] exp_diff_A;
	wire [exponent_length-1:0] exp_diff_B;
	wire [exponent_length-1:0] exp_larger;
	wire [fraction_length+fraction_length:0] A_f_shifted;
	wire [fraction_length+fraction_length:0] B_f_shifted;
	wire	A_larger;
	
	assign A_larger = (A_e > B_e) ? 1'b1:							// Which one is bigger
							((A_e == B_e) && (A_f > B_f)) ? 1'b1 : 1'b0;
	
	assign exp_diff_A = B_e - A_e; // if B bigger
	assign exp_diff_B = A_e - B_e; // if A bigger
	
	assign exp_larger = (B_e > A_e) ? B_e : A_e;
	
	//************** Need to change number to parameter
	assign A_f_shifted = A_larger ? {1'b0, A_f, {fraction_length{1'b0}}} : 		// need a high order bit for 1.0<sum<2.0
								(exp_diff_A > 8'd21) ? 37'b0 :
								({1'b0, A_f, {fraction_length{1'b0}}} >> exp_diff_A);	
	assign B_f_shifted = ~A_larger ? {1'b0, B_f, {fraction_length{1'b0}}} : 
								(exp_diff_B > 8'd21) ? 37'b0 :
								({1'b0, B_f, {fraction_length{1'b0}}} >> exp_diff_B);
								
	//Calculate sum or difference of the shifted fractions
	wire [fraction_length+fraction_length:0] pre_sum;
	assign pre_sum = ((A_s^B_s) &  A_larger) ? A_f_shifted - B_f_shifted :
                    ((A_s^B_s) & ~A_larger) ? B_f_shifted - A_f_shifted :
                    A_f_shifted + B_f_shifted;

	//Buffer for midway results 
	reg  [fraction_length+fraction_length:0] 		buf_pre_sum;
	reg  [exponent_length-1:0]  						buf_larger_exp;
	reg         											buf_A_e_zero;
	reg         											buf_B_e_zero;
	reg  [number_length-1:0] 							buf_A;
	reg  [number_length-1:0] 							buf_B;
	reg         											buf_out_Sum_s;
	always @(posedge clock) begin
        buf_pre_sum    <= pre_sum;
        buf_larger_exp <= exp_larger;
        buf_A_e_zero   <= (A_e == 8'b0);
        buf_B_e_zero   <= (B_e == 8'b0);
        buf_A          <= in_A;
        buf_B          <= in_B;
        buf_out_Sum_s  <= A_larger ? A_s : B_s;
    end
	
	// Convert to positive fraction and a sign bit.
	wire [fraction_length+fraction_length:0] pre_frac;
	assign pre_frac = buf_pre_sum;

	// Normalizing process: Determine output fraction and exponent change with position of first 1.
	wire [fraction_length-1:0] out_Sum_f;
	wire [7:0]  shft_amount;
	assign shft_amount =  pre_frac[36] ? 8'd0  : pre_frac[35] ? 8'd1  :
								 pre_frac[34] ? 8'd2  : pre_frac[33] ? 8'd3  :
								 pre_frac[32] ? 8'd4  : pre_frac[31] ? 8'd5  :
								 pre_frac[30] ? 8'd6  : pre_frac[29] ? 8'd7  :
								 pre_frac[28] ? 8'd8  : pre_frac[27] ? 8'd9  :
								 pre_frac[26] ? 8'd10 : pre_frac[25] ? 8'd11 :
								 pre_frac[24] ? 8'd12 : pre_frac[23] ? 8'd13 :
								 pre_frac[22] ? 8'd14 : pre_frac[21] ? 8'd15 :
								 pre_frac[20] ? 8'd16 : pre_frac[19] ? 8'd17 :
								 pre_frac[18] ? 8'd18 : pre_frac[17] ? 8'd19 :
								 pre_frac[16] ? 8'd20 : pre_frac[15] ? 8'd21 :
								 pre_frac[14] ? 8'd22 : pre_frac[13] ? 8'd23 :
								 pre_frac[12] ? 8'd24 : pre_frac[11] ? 8'd25 :
								 pre_frac[10] ? 8'd26 : pre_frac[9]  ? 8'd27 :
								 pre_frac[8]  ? 8'd28 : pre_frac[7]  ? 8'd29 :
								 pre_frac[6]  ? 8'd30 : pre_frac[5]  ? 8'd31 :
								 pre_frac[4]  ? 8'd32 : pre_frac[3]  ? 8'd33 :
								 pre_frac[2]  ? 8'd34 : pre_frac[1]  ? 8'd35 :
								 pre_frac[0]  ? 8'd36 : 8'd37;

	// check denormalization							 
	wire [53:0] pre_frac_shft, uflow_shft;

	assign pre_frac_shft = {pre_frac, 17'b0} << (shft_amount+1);
	assign uflow_shft = {pre_frac, 17'b0} << (shft_amount);
	assign out_Sum_f = pre_frac_shft[53:36];

	wire [7:0] out_Sum_e;
	assign out_Sum_e = buf_larger_exp - shft_amount + 8'b1;

	// Detect underflow
	wire underflow;
	assign underflow = ~uflow_shft[53];	// If it is '1', the number is denormalization
	assign out_Sum = (buf_A_e_zero && buf_B_e_zero)   ? 27'b0 :		// The exponent of number A and B are both zero. (0 + 0 = 0)
							buf_A_e_zero                     ? buf_B :
							buf_B_e_zero                     ? buf_A :
							underflow                        ? 27'b0 :
							(pre_frac == 0)                  ? 27'b0 :
							{buf_out_Sum_s, out_Sum_e, out_Sum_f};
			
endmodule 
