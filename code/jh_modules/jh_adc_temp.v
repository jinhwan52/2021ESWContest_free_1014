module jh_adc_temp(
	input 						clock,
	input							reset,
	output 			[15:0] 	temperature1,
	output 			[15:0] 	temperature2,
	output 	reg				en_RF,
	input				[15:0]	temperature_addr,
	output	reg	[15:0] 	bus_addr,         // Avalon address
	output	reg	[3:0] 	bus_byte_enable, 	// four bit byte read/write mask
	output	reg				bus_read,      	// high when requesting data
	output	reg 				bus_write,      	// high when writing data
	output	reg 	[15:0] 	bus_write_data, 	// data to send to Avalog bus
	input			 				bus_ack,       	// Avalon bus raises this when done
	input		 		[15:0] 	bus_read_data	 	// data from Avalon bus	
);

assign test_state = state;  /////////////////////////edit

localparam 	Read_Number = 16'd4,	Shift_Sum_Temperature = 2,	timer_size = 18;		
localparam 	R_temp1 = 4'd0, R_temp2 = 4'd2, R_foot	= 4'd4;	
				
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg	[3:0]		ch;									// It is from jh_controller module
reg	[3:0] 	state;
reg 	[timer_size-1:0]	timer;
reg 	[15:0]	delay_timer;
reg 	[Shift_Sum_Temperature:0] read_count;
reg 	[15:0] 	temperature;
reg 	[15:0] 	temperature_display, temperature_display1, temperature_display2;

//=======================================================
//  Bus controller for AVALON bus-master of ADC
//=======================================================

assign temperature1 = temperature_display1;
assign temperature2 = temperature_display2;

always @(posedge clock) begin
	// reset state machine and read/write controls
	if (reset) begin
		state <= 0;
		timer <= 0;
		en_RF <= 0;
		bus_read <= 0 ; // set to one if a read opeation from bus
		bus_write <= 0 ; // set to on if a write operation to bus
		read_count <= 0;
		temperature <= 0;
		delay_timer <= 0;
		temperature_display1 <= 0;
		temperature_display2 <= 0;
		ch <= 0; 
	end
	// otherwise run counter at 50 MHz 
	// RF ON duration 2^18/5e7 seconds ~ 5.24 msec 
	// RF OFF (meausre temperature) duration 5.24 x 3 = 15.72 msec
	// 
	else begin
		timer <= timer + 1'b1 ;
	end
	
	// Set measurement number
	if (state == 4'd0 && timer == 0) begin	// Minimum delay
		en_RF <= 0;	
		state <= 4'd1;
		// set up the write data
		bus_write_data <= Read_Number ;
		// 
		bus_byte_enable <= 4'b0001 ; 
		// 
		bus_addr <= temperature_addr + 16'h0004 ; 				
		// signal the write request to the Avalon bus
		bus_write <= 1 ;
	end
	
	// Start measure
	if (state == 4'd1 && bus_ack==1) begin
		state <= 4'd2 ;
		// set up the write data
		bus_write_data <= (ch << 1) | 16'h00 ;
		// 
		bus_byte_enable <= 4'b0001 ; 
		// 
		bus_addr <= temperature_addr ; 
		// signal the write request to the Avalon bus
		bus_write <= 1 ;
	end
	
	if (state == 4'd2 && bus_ack==1) begin
		state <= 4'd3 ;
		// set up the write data
		bus_write_data <= (ch << 1) | 16'h01 ;
		// 
		bus_byte_enable <= 4'b0001 ; 
		// 
		bus_addr <= temperature_addr ; 
		// signal the write request to the Avalon bus
		bus_write <= 1 ;
	end
	
	if (state == 4'd3 && bus_ack==1) begin
		state <= 4'd4 ;
		// set up the write data
		bus_write_data <= (ch << 1) | 16'h00 ;
		// 
		bus_byte_enable <= 4'b0001 ; 
		// 
		bus_addr <= temperature_addr ; 
		// signal the write request to the Avalon bus
		bus_write <= 1 ;
	end
	
	// wait measure done
	if (state == 4'd4 && bus_ack==1) begin
		if (bus_read_data & 16'h01 == 16'h00) state <= 4'd4;
		else 	state <= 4'd5 ;
		// set up the read data
		bus_addr <= temperature_addr ; 
		// 
		bus_byte_enable <= 4'b0001 ; 
		// signal the read request to the Avalon bus
		bus_write <= 0 ;
		bus_read  <= 1 ;
	end
	
	// read adc value
	if (state == 4'd5 && bus_ack==1) begin
		if (read_count < Read_Number + 16'd1) begin
			state <= 4'd5 ;
			// set up the read data
			temperature <= temperature+bus_read_data;
			// 
			bus_addr <= temperature_addr + 16'h0004 ; 			
			// signal the read request to the Avalon bus
			bus_byte_enable <= 4'b0011 ;
			bus_read  <= 1 ;
			bus_write <= 0 ;
			read_count <= read_count + 1;
		end
		else begin
			state 		<= 4'd6;
			bus_write 	<= 0;
			bus_read  	<= 0;
			read_count 	<= 0;
			temperature <= 0;
			temperature_display <= temperature >> Shift_Sum_Temperature;	
		end
	end
	
	if (state == 4'd6) begin		// From state0 to state6, it takes about 20 clock. 
		state <= 4'd0;					
		if(ch == 4'd0) begin
			ch <= 4'd2;
			en_RF <= 0;
			timer <= 1;					
		end
		else if(ch == 4'd2) begin
			temperature_display1 <= temperature_display;
			ch <= 4'd4;	
			en_RF <= 0;
			timer <= 1;		
		end
		else begin
			temperature_display2 <= temperature_display;
			ch <= 4'd0;
			en_RF <= 1;
			timer <= 1;
		end
	end
	
end

endmodule
