
// jh_efield 
module jh_efield(
	input rst,
	input clock,
	input [26:0] r,				// Vn
	input [26:0] V_right,				// V_r,z+1 
	input [26:0] V_left,					// V_r,z-1 
	input [26:0] V_top,		// V_r+1,z (top of V_r,z)
	input [26:0] V_bottom,	// V_r-1,z (bottom of V_r,z)
	output [26:0] fdtd_result
);
					
	wire [26:0] const1, const2, const3, const1xr;
	assign const1 = 27'b001110101110011010101100000;		// const1 = alpha1 * 1/2dr  = 0.001759888899531
	assign const2 = 27'b001111001010110100000001000;		// const2 = alpha1 * 1/drdr = 0.021118666794368
	assign const3 = 27'b001111101111010100101111111;		// const3 = alpha1 * 1/dzdz = 0.478881333205632
	
	wire [26:0] out1, out2, out3, out4, out5;
	wire [26:0] out6, out7, out8;
	reg [26:0] dalayed_out4;
	reg [26:0] dalayed_out5;
	reg [26:0] dalayed_out6, dalayed_out6_2, dalayed_out6_3;
	reg [26:0] dalayed_out7;
	
	always @(posedge clock) begin
		dalayed_out4 <= out4;
		dalayed_out5 <= out5;
		dalayed_out6 <= out6;
		dalayed_out7 <= out7;
		dalayed_out6_2 <= dalayed_out6;
		dalayed_out6_3 <= dalayed_out6_2;
	end
	
	// takes 5 clocks 
	fp_multi mul0(const1, r, const1xr);
	fp_adder add1(clock, V_top, {~V_bottom[26], V_bottom[25:0]}, out1);	
	fp_adder add2(clock, V_top, V_bottom, out2);
	fp_adder add3(clock, V_right, V_left, out3);
	fp_multi mul1(out1, const1xr, out4);	
	fp_multi mul2(out2, const2, out5);
	fp_multi mul3(out3, const3, out6);
	fp_adder add5(clock, dalayed_out5, dalayed_out4, out7);
	fp_adder add6(clock, dalayed_out6_3, dalayed_out7, out8); 
	
	assign fdtd_result = out8; 
	
endmodule 