module jh_adc_rfsig(
input							CLOCK_65,						// AD9248 uses 65 Mhz (65 MSPS)
input							rst,
input							start_write,
input				[13:0]	monitor_ADC,		
input				[15:0] 	sram_readdata,
output	reg 	[15:0] 	sram_writedata,
output	reg 	[6:0] 	sram_address,
output	reg 				sram_write,
output 	reg	[15:0] 	Vpp,
output						rfsig_state
);

localparam WAIT = 4'd0, WRITE = 4'd1, READ_SET = 4'd2, READ_WAIT1 = 4'd3, READ_WAIT2 = 4'd4, READ = 4'd5, RESULT = 4'd6, DELAY = 4'd7, WAIT_RFOFF = 4'd8;

reg [15:0] min_voltage;	
reg [15:0] max_voltage;
reg [15:0] min_voltage_pre;
reg [15:0] max_voltage_pre;
reg [15:0] delay_timer;			// 2^16 * 15.4 nsec = 100 usec
reg 		  get_volt;

reg [3:0] current_state;
reg [3:0] next_state;

assign rfsig_state = get_volt;

always @(negedge CLOCK_65) begin
	if (rst) begin
		current_state <= WAIT;
	end
	else begin		
		current_state <= next_state; 
	end
end

always @(posedge CLOCK_65) begin		// 65 Mhz = 15.4 nsec
	if (rst) begin
		Vpp <= 0;
		get_volt <= 0;
		delay_timer <= 0;
		min_voltage <= 0;											
		max_voltage <= 0;
		sram_write <= 0;
		sram_address <= 0;
		next_state <= WAIT;
	end
	case(current_state)
		WAIT: begin
			if(start_write) begin
				next_state <= DELAY;
				delay_timer <= 0;
				sram_address <= 0;
				sram_write <= 1;
				sram_writedata <= {{2'b0}, monitor_ADC} ;
				min_voltage <= 0;											// Reset MIN & MAX value befor read new voltage
				max_voltage <= 0;
			end
			else begin
				next_state <= WAIT;
				get_volt <= 0;
				sram_address <= 0;
				sram_write <= 0;
			end
		end
		// Delay 100 usec after starting generate 500 khz wave 
		// ADDA (@50Mhz) generates 500 khz wave (taking 100 clk = 2 usec)  
		DELAY: begin
			if(delay_timer == 16'b1111_1111_1111_1111) begin
				delay_timer <= 0;
				next_state <= WRITE;
			end
			else begin 
				delay_timer <= delay_timer + 16'b1;
				next_state <= DELAY;
			end
		end		
		// Write temperautre to SRAM.
		WRITE: begin
			sram_address <= sram_address + 7'b1 ;
			sram_writedata <= {{2'b0}, monitor_ADC} ;			// Monitor_ADC is 14 bits, SRAM is 16 bits.
			sram_write <= (&sram_address) ? 1'b0 : 1'b1;
			next_state <= (&sram_address) ? READ_SET : WRITE;	
		end
		// Set up SRAM address to read SRAM data.
		READ_SET: begin								
			sram_write <= 0;
			min_voltage_pre <= min_voltage;
			max_voltage_pre <= max_voltage;
			next_state <= READ_WAIT1;
		end
		// Wait two cycle since read ADC data.
		READ_WAIT1: begin
			next_state <= READ_WAIT2;
		end
		READ_WAIT2: begin
			next_state <= READ;
		end
		// Read temperature in SRAM and find MAX & MIN.
		READ: begin		
			min_voltage <= (sram_address==0) ? sram_readdata :		// If min_voltage_pre == 0, min_voltage = sram_readdata
								(min_voltage_pre >  sram_readdata + 16'd64) ? min_voltage_pre:
								(min_voltage_pre < sram_readdata) ? min_voltage_pre : sram_readdata ;	
								
			// Have to find the solution 		
			max_voltage <= (sram_address==0) ? sram_readdata :		// If max_voltage_pre == 0, max_voltage = sram_readdata
								(sram_readdata > max_voltage_pre + 16'd64) ? max_voltage_pre:
								(max_voltage_pre > sram_readdata) ? max_voltage_pre : sram_readdata ;
			sram_address <= sram_address + 7'b1 ;
			next_state <= (&sram_address) ? RESULT : READ_SET;
		end
		
		RESULT: begin
			next_state <= WAIT_RFOFF;	///////////////////////////// edit: next_state <= WAIT;
			get_volt <= 1;
			if(max_voltage >= min_voltage) Vpp <= max_voltage - min_voltage;
		end
		
		WAIT_RFOFF: begin
			if(!start_write) next_state <= WAIT;
			else next_state <= WAIT_RFOFF;
		end
		
				
		default:	begin
			next_state <= WAIT;
		end
		
	endcase
end


endmodule



