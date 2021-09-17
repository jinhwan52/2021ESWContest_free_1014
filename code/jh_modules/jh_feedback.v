module jh_feedback(
	input							clock,
	input							en_RF,
	input 			[5:0]		max_power,
	input							power_unlock,
	input				[15:0] 	sp,			// setting point
	input				[15:0] 	un,			// process value
	input				[5:0]		i_feedback,		//current feedback value
	output			[5:0] 	o_feedback,			// feedback output
	output						overflow,
	output 						underflow
);
	wire  [5:0] 	time_delay;
	wire  [5:0]		power_max;
	wire	[2:0]	  	comp_spNun;
	reg 	[3:0] 	state_lookup;
	reg  	[5:0] 	temp_feedback;
	reg	[4:0]		timer_counter;
	
	assign time_delay = 5'b00111;
	
	always @ (posedge en_RF)		//state change when the flag is changed
	begin
		if(timer_counter == time_delay) begin
			state_lookup = {comp_spNun, overflow, underflow};
			case(state_lookup)				
				4'b0000: temp_feedback <= i_feedback + 6'b1;	// current temp. > target temp.
				4'b0001: temp_feedback <= i_feedback + 6'b1;	//	current temp. < target temp. & underflow
				4'b1000: temp_feedback <= i_feedback - 6'b1;	//	current temp. > target temp.
				4'b1010: temp_feedback <= i_feedback - 6'b1;	// current temp. > target temp. & overflow
				default: temp_feedback <= i_feedback;
			endcase	
			case(state_lookup)
				//4'b0001: timer_counter <= (time_delay >> 1);	//	current temp. < target temp. & underflow
				4'b1010: timer_counter <= time_delay;			// current temp. > target temp. & overflow
				default: timer_counter <= 0;
			endcase	
		end
		else timer_counter <= timer_counter + 5'b1;
	end
	
	assign comp_spNun = (un > sp) ? 2'b10 :
							  (un > sp) ? 2'b01 : 2'b00 ;
	assign power_max = power_unlock ? max_power : 6'b01_1111;
	assign overflow = (temp_feedback == power_max) ? 1 : 0;
	assign underflow = (temp_feedback == 6'b0) ? 1: 0;
	
	assign o_feedback = temp_feedback;

endmodule
