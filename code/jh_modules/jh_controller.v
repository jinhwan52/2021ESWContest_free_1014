module jh_controller
(
	input							reset,
	input				[15:0] 	ADC_data,
	input 						flag,
	output			[3:0]		ch,	
	output 	reg	[15:0]	temperature1,
	output	reg	[15:0]	temperature2
);

localparam 	R_temp1 = 4'd0, R_temp2 = 4'd2, R_foot	= 4'd4;				
				
reg [5:0] current_ch, next_ch;		

always @ (negedge flag or posedge reset)		//state change when the flag is changed
begin
	if (reset) 
		begin
		current_ch <= R_temp1;
		end
	else 
		begin
		current_ch <= next_ch;
		
		case(current_ch)
			R_temp1:
				begin
					temperature1 <= ADC_data;	
					next_ch <= R_temp2;
				end
			R_temp2:
				begin
					temperature2 <= ADC_data;
					next_ch <= R_foot;
				end
			R_foot:
				begin
					next_ch <= R_temp1;		
				end
			default: next_ch = R_temp1;
		endcase

	end
end


assign ch = next_ch;
endmodule
