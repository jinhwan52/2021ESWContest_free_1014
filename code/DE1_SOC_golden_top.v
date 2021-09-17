// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Thu Jul 11 11:26:45 2013
// ============================================================================

`define ENABLE_ADC
`define ENABLE_AUD
`define ENABLE_CLOCK2
`define ENABLE_CLOCK3
`define ENABLE_CLOCK4
`define ENABLE_CLOCK
`define ENABLE_DRAM
`define ENABLE_FAN
`define ENABLE_FPGA
//`define ENABLE_GPIO		// Use only one of ENABLE_GPIO and ENABLE_ADDA
`define ENABLE_ADDA
`define ENABLE_HEX
`define ENABLE_HPS
`define ENABLE_IRDA
`define ENABLE_KEY
`define ENABLE_LEDR
`define ENABLE_PS2
`define ENABLE_SW
`define ENABLE_TD
`define ENABLE_VGA

module DE1_SOC_golden_top(
		
      /* Enables ADC - 3.3V */
	`ifdef ENABLE_ADC

      output             ADC_CONVST,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

	`endif

       /* Enables AUD - 3.3V */
	`ifdef ENABLE_AUD

      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

	`endif

      /* Enables CLOCK2  */
	`ifdef ENABLE_CLOCK2
      input              CLOCK2_50,
	`endif

      /* Enables CLOCK3 */
	`ifdef ENABLE_CLOCK3
      input              CLOCK3_50,
	`endif

      /* Enables CLOCK4 */
	`ifdef ENABLE_CLOCK4
      input              CLOCK4_50,
	`endif

      /* Enables CLOCK */
	`ifdef ENABLE_CLOCK
      input              CLOCK_50,
	`endif

       /* Enables DRAM - 3.3V */
	`ifdef ENABLE_DRAM
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
	`endif

      /* Enables FAN - 3.3V */
	`ifdef ENABLE_FAN
      output             FAN_CTRL,
	`endif

      /* Enables FPGA - 3.3V */
	`ifdef ENABLE_FPGA
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,
	`endif

      /* Enables GPIO - 3.3V */
	`ifdef ENABLE_GPIO
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
	`endif
		
		// OR
		
		/* GPIO_0_1, GPIO_0_1 connect to ADA - High Speed ADC/DAC */
	`ifdef ENABLE_ADDA
		output		          		ADC_CLK_A,
		output		          		ADC_CLK_B,
		input 		    [13:0]		ADC_DA,
		input 		    [13:0]		ADC_DB,
		output		          		ADC_OEB_A,
		output		          		ADC_OEB_B,
		input 		          		ADC_OTR_A,
		input 		          		ADC_OTR_B,
		output		          		DAC_CLK_A,
		output		          		DAC_CLK_B,
		output		    [13:0]		DAC_DA,
		output		    [13:0]		DAC_DB,
		output		          		DAC_MODE,
		output		          		DAC_WRT_A,
		output		          		DAC_WRT_B,
		input 		          		OSC_SMA_ADC4,
		output		          		POWER_ON,
		input 		          		SMA_DAC4,
	`endif
      /* Enables HEX - 3.3V */
	`ifdef ENABLE_HEX
      output      [6:0]  HEX0,
      output      [6:0]  HEX1,
      output      [6:0]  HEX2,
      output      [6:0]  HEX3,
      output      [6:0]  HEX4,
      output      [6:0]  HEX5,
	`endif
	
	/* Enables HPS */
	`ifdef ENABLE_HPS
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N, //1.5V
      output             HPS_DDR3_CK_P, //1.5V
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif 

      /* Enables IRDA - 3.3V */
	`ifdef ENABLE_IRDA
      input              IRDA_RXD,
      output             IRDA_TXD,
	`endif

      /* Enables KEY - 3.3V */
	`ifdef ENABLE_KEY
      input       [3:0]  KEY,
	`endif

      /* Enables LEDR - 3.3V */
	`ifdef ENABLE_LEDR
      output      [9:0]  LEDR,
	`endif

      /* Enables PS2 - 3.3V */
	`ifdef ENABLE_PS2
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,
	`endif

      /* Enables SW - 3.3V */
	`ifdef ENABLE_SW
      input       [9:0]  SW,
	`endif

      /* Enables TD - 3.3V */
	`ifdef ENABLE_TD
      input             TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output            TD_RESET_N,
      input             TD_VS,
	`endif

      /* Enables VGA - 3.3V */
	`ifdef ENABLE_VGA
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
	`endif
	
);

//=======================================================
//						REG/WIRE declarations
//=======================================================
	wire [15:0] module_csr;			//Save state of each module
	assign module_csr[0] = en_RF_fpga;
	assign module_csr[1] = fw_state;
	assign module_csr[2] = re_state;
	assign module_csr[3] = en_RF;
	
	wire [19:0] dec_temp;
	wire [15:0] display_adc;
	wire [6:0] display_adc2;	
	
	assign display_adc = temperature1;
	 
	bin2bcd #(.W(16)) uut (.bin(display_adc), .bcd(dec_temp));	//	dec_temp = Display thermocouples value as decimal number
	bin2bcd #(.W(6)) uut2 (.bin(f_out), .bcd(display_adc2));		// display_adc2 = Display the gain of feedback
	
	HexDigit Digit0(HEX0, dec_temp[3:0]);
	HexDigit Digit1(HEX1, dec_temp[7:4]);
	HexDigit Digit2(HEX2, dec_temp[11:8]);
	HexDigit Digit3(HEX3, dec_temp[15:12]);
	HexDigit Digit4(HEX4, display_adc2[3:0]);
	HexDigit Digit5(HEX5, display_adc2[6:4]);

//======================================================
//			Read ADC data from LTC2308 (Temperature) &
//======================================================
	wire 	[15:0] 	temperature1;
	wire 	[15:0] 	temperature2;
	wire				system_rest;
	wire 				en_RF, en_RF_fpga, en_RF_hps;	
	wire 				hw_rest;
	wire				triger;
	wire 	[15:0] 	bus_addr;         	// Avalon address
	wire 	[3:0] 	bus_byte_enable ; 	// four bit byte read/write mask
	wire 				bus_read  ;       	// high when requesting data
	wire 				bus_write ;      		// high when writing data
	wire 	[15:0] 	bus_write_data ; 		// data to send to Avalog bus
	wire 				bus_ack  ;       		// Avalon bus raises this when done
	wire 	[15:0] 	bus_read_data ; 		// data from Avalon bus
	
	wire	[3:0]		test_state;
	jh_adc_temp 	md_adc_temp(
		.clock(CLOCK_50), 					// it has to be clock_50 ㅇ
		.reset(system_rest), 
		.temperature1(temperature1),
		.temperature2(temperature2),
		.en_RF(en_RF_fpga),
		.temperature_addr(16'h0000), 
		.bus_addr(bus_addr),
		.bus_byte_enable(bus_byte_enable),
		.bus_read(bus_read),
		.bus_write(bus_write),
		.bus_write_data(bus_write_data),
		.bus_ack(bus_ack),
		.bus_read_data(bus_read_data)
		);
		
	assign system_rest = !KEY[0] | hw_rest;
	assign en_RF = en_RF_fpga & (en_RF_hps | !KEY[3]) & !system_rest;
	
//=====================================================
//							Feedback 
//=====================================================
	wire	[15:0]	sp;					// Setting point <- hps command
	wire  [15:0]   sp_input;
	wire	[15:0]	un;					// Process value
	wire				thermo_sel;			
	wire	[5:0]		f_out;				// Feedback value --> this value is to be 'gain' of DAC1 module
	wire  [5:0]	 	i_feedback;
	wire				power_unlock;

	assign un = (thermo_sel | SW[9]) ? temperature2 : temperature1;	// if 'thermo_sel' is 0, 'un' is 'temp1'.  <- hps command
	assign i_feedback = f_out;
	assign sp_input = sp ? sp : 16'b0000_0001_1001_0000;  // if sp is not determined, sp_input is set 40.0 C(16'b0000_0001_1001_0000 = 16'd400)

	jh_feedback 	md_feedback(
		.clock(CLOCK_50),
		.en_RF(en_RF),
		.max_power(SW[5:0]),
		.power_unlock(SW[9] | power_unlock), 	// .power_unlock(power_unlock)  <- hps command
		.i_feedback(i_feedback), 
		.sp(sp_input), 								//  temperally set 'sp' as 40.0C.  <- hps command
		.un(un), 
		.o_feedback(f_out) 	  			// 0 =< f_out < 64
	);

//=====================================================
//					ADA_board DAC & ADC module
//=====================================================
	wire				CLOCK_65;
	wire 				ADC_pw_clk65;
	wire	[14:0]	voltage_forward;
	wire	[14:0]	voltage_reversed;

	jh_ADDA		md_DAC(
		.CLOCK_50	 (CLOCK3_50),
		.CLOCK_65	 (CLOCK_65),
		.ADC_CLK_A	 (ADC_CLK_A),
		.ADC_CLK_B   (ADC_CLK_B),
		.ADC_DA		 (ADC_DA),
		.ADC_DB		 (ADC_DB),
		.ADC_OEB_A	 (ADC_OEB_A),
		.ADC_OEB_B	 (ADC_OEB_B),
		.ADC_OTR_A   (ADC_OTR_A),
		.ADC_OTR_B	 (ADC_OTR_B),
		.DAC_CLK_A	 (DAC_CLK_A),
		.DAC_CLK_B   (DAC_CLK_B),
		.DAC_DA		 (DAC_DA),
		.DAC_DB		 (DAC_DB),
		.DAC_MODE	 (DAC_MODE),
		.DAC_WRT_A	 (DAC_WRT_A),
		.DAC_WRT_B	 (DAC_WRT_B),
		.POWER_ON    (POWER_ON),
		.OSC_SMA_ADC4(OSC_SMA_ADC4),
		.SMA_DAC4    (SMA_DAC4),
		.DAC_rst		 (!en_RF),			// It is from <jh_adc_temp>
		.gain			 (f_out),			// It is from <jh_feedback>
		.ADC_out_A	 (voltage_forward),
		.ADC_out_B	 (voltage_reversed)
	);
	

//=====================================================
//				Voltage monitoring (Forward & Reversed)
//=====================================================
	wire [15:0] sram_readdata;
	wire [15:0] sram_writedata;
	wire [6:0] 	sram_address;
	wire 			sram_write;

	wire [15:0] sram_readdata2;
	wire [15:0] sram_writedata2;
	wire [6:0] 	sram_address2;
	wire 			sram_write2;

	wire [15:0] pw_forward;
	wire [15:0] pw_reversed;

	wire [3:0] 	fw_state;
	wire [3:0] 	re_state;
	
	// To solve metastability problem of the asynchronous reset signal and en_RF 
	reg 		  power_en1, power_reset_trigger1;
	reg 		  power_en2, power_reset_trigger2;
	
	// Two flip-flop
	always @(posedge CLOCK_65) begin
		power_reset_trigger1 <= system_rest;
		power_en1 <= en_RF;
	end
	always @(posedge CLOCK_65) begin
		power_reset_trigger2 <= power_reset_trigger1;
		power_en2 <= power_en1;
	end
	

	jh_adc_rfsig fw_power(
		.CLOCK_65(CLOCK_65),					// AD9248 uses 65 Mhz (65 MSPS)
		.rst(power_reset_trigger2),
		.start_write(power_en2),
		.monitor_ADC(voltage_forward),
		.sram_readdata(sram_readdata),
		.sram_writedata(sram_writedata),
		.sram_address(sram_address),
		.sram_write(sram_write),
		.Vpp(pw_forward),						//******** It should be changed [vpp] -> [rms]. (Beforehand, determine the number type! float? fix?)
		.rfsig_state(fw_state)			
		);
		
	jh_adc_rfsig re_power(
		.CLOCK_65(CLOCK_65),				   // AD9248 uses 65 Mhz (65 MSPS)
		.rst(power_reset_trigger2),
		.start_write(power_en2),
		.monitor_ADC(voltage_reversed),
		.sram_readdata(sram_readdata2),
		.sram_writedata(sram_writedata2),
		.sram_address(sram_address2),
		.sram_write(sram_write2),
		.Vpp(pw_reversed),						//******** It should be changed [vpp] -> [rms]. (Beforehand, determine the number type! float? fix?)
		.rfsig_state(re_state)				
		);
			
	
	
//=====================================================
//							Real time FDTD	
//=====================================================	

	wire 				CLOCK_100;
	wire 	[31:0]	command_from_hps;	// Command from HPS 
	// hps_to_fpga_readdata [31:0] = [31:26 (r), 25:0 (number)],  (number =	voltage )
	// command_from_hps [31:0] = [13:10 (mode), 5:0 (pe number = r)]
	//	mode =	4'b0001: init, 
	//				4'b0010: computing, 
	//				4'b0100: read single M10K, 
	//				4'b1000: read all M10K, 
	//				*4'b0000: finish read operation
	//	pe_num = 0 to 12

	/////////////////////////////////
	// hps to fpga fifo
	/////////////////////////////////

	reg 	[31:0] 	hps_to_fpga_readdata ; 
	reg 				hps_to_fpga_read ; 				// read command
	wire 	[31:0] 	hps_to_fpga_out_csr_address ; // fill_level
	reg 	[31:0]	hps_to_fpga_out_csr_readdata;	// In this system, check only full or empty
	wire				hps_to_fpga_out_csr_read;
	reg 	[7:0] 	hps_to_fpga_out_state;
	reg	[31:0]	data_buffer;
	
	assign hps_to_fpga_out_csr_address = 32'd1;
	assign hps_to_fpga_out_csr_read = 1'b1;
	// status addresses (csr_address)
	// base => fill level
	// base+1 => status bits; 
	//           bit0==1 if full
	//           bit1==1 if empty
	reg 	[26:0] 	hps2m10k_data;
	reg 	[6:0]  	hps2m10k_addr;		// 7bits
	reg 			  	hps2m10k_we;
	wire	[5:0]		target_pe;	
	
	always @(posedge CLOCK_100) begin
		// reset state machine and read/write controls
		if (system_rest | (command_from_hps[13:10] == 4'b0000)) begin
			hps_to_fpga_out_state <= 8'd0 ;
			hps2m10k_addr <= 0;
		end
		// Is there data in FIFO
		if (hps_to_fpga_out_state == 8'd0 && command_from_hps[13:10] == 4'b0001 && !(hps_to_fpga_out_csr_readdata[1])) begin //2'b01: write (h2f)
			hps_to_fpga_read <= 1'b1;
			hps_to_fpga_out_state <= 8'd1;
		end
		// wait a cycle to read csr data
		if (hps_to_fpga_out_state == 8'd1) begin
			hps_to_fpga_read <= 1'b0;
			hps_to_fpga_out_state <= 8'd2;
		end
		// IF so, set up to read a word from the FIFO
		if (hps_to_fpga_out_state == 8'd2) begin
			data_buffer <= hps_to_fpga_readdata; // transmit the data to PE
			hps_to_fpga_out_state <= 8'd3 ;  // look for next data
		end
		// Save the FIFO data to M10K
		if (hps_to_fpga_out_state == 8'd3) begin
			hps2m10k_we <= 1;
			hps2m10k_data <= data_buffer[26:0]; 
			hps_to_fpga_out_state <= 8'd4 ;  
		end
		if (hps_to_fpga_out_state == 8'd4) begin
			hps2m10k_we <= 0;
			hps2m10k_addr <= hps2m10k_addr + 7'b1;
			hps_to_fpga_out_state <= 8'd0 ;  
		end
	end 

	//////////////////////////////////
	// fpga to hps fifo
	//////////////////////////////////
	
	reg 	[31:0] 	fpga_to_hps_in_writedata ; 
	reg 				fpga_to_hps_in_write ; 			// write command
	wire 	[31:0] 	fpga_to_hps_in_csr_address ; 	// In this system, check only full or empty
	reg 	[31:0]	fpga_to_hps_in_csr_readdata;	// 
	wire				fpga_to_hps_in_csr_read;
	reg 	[3:0] 	fpga_to_hps_out_state;
	reg	[31:0]	data_buffer2;
	reg				rst_command;
	
	assign fpga_to_hps_in_csr_address = 32'd1;
	assign fpga_to_hps_in_csr_read = 1'b1;
	// status addresses (csr_address)
	// base => fill level
	// base+1 => status bits; 
	//           bit0==1 if full
	//           bit1==1 if empty
	
	reg start_read_M10K, finish_read_M10K, block_read_M10K;
	always @(posedge CLOCK_100) begin
		if(~start_read_M10K)	begin
			start_read_M10K <= (command_from_hps[13:10] == 4'b0100) ? 1'b1 : 1'b0; // When command_from_hps[1] is high
			rst_command <= 0;
		end
		else
		if(~block_read_M10K) block_read_M10K <= finish_read_M10K;	// When finishing read M10K
		else
		if(command_from_hps[13:10]==4'b0000) begin
			start_read_M10K <= 0;		// When command_from_hps[1] is low
			block_read_M10K <= 0;
			rst_command <= 1;
		end
	end 
	
	wire 	[26:0] 	read_M10K_data;
	reg 	[6:0] 	read_M10K_addr;	// 7 bits
	reg 		  		read_M10K_we;
	always @(posedge CLOCK_100) begin
		if (system_rest | rst_command) begin
			fpga_to_hps_out_state <= 4'd0;
			finish_read_M10K <= 1'b0;
		end
		if (fpga_to_hps_out_state == 4'd0 && start_read_M10K && !block_read_M10K && !(fpga_to_hps_in_csr_readdata[0])) begin
			read_M10K_we <= 1'b0;
			read_M10K_addr <= 7'b0;  
			fpga_to_hps_out_state <= 4'd1;
		end
		// wait a cycle
		if(fpga_to_hps_out_state == 4'd1) begin
			fpga_to_hps_out_state <= 4'd2;
		end
		if(fpga_to_hps_out_state == 4'd2) begin
			fpga_to_hps_in_write <= 1;
			fpga_to_hps_in_writedata <= {5'b0, read_M10K_data};
			fpga_to_hps_out_state <= 4'd3;
		end
		if(fpga_to_hps_out_state == 4'd3) begin 
			fpga_to_hps_in_write <= 0;
			fpga_to_hps_out_state <= 4'd4;
		end
		if(fpga_to_hps_out_state == 4'd4 && start_read_M10K && !(fpga_to_hps_in_csr_readdata[0])) begin
			fpga_to_hps_in_write <= 0;
			read_M10K_addr <= read_M10K_addr + 7'b1;
			fpga_to_hps_out_state <= (read_M10K_addr == 7'b1101101) ? 4'd5 : 4'd1;	// 7'b1101101 = 109
		end
		if(fpga_to_hps_out_state == 4'd5) begin
			finish_read_M10K <= 1'b1;
			read_M10K_addr <= 7'b0;
			fpga_to_hps_out_state <= 4'd6;
		end
		// wait a cycle to block this "always module"
		if(fpga_to_hps_out_state == 4'd6) begin
			fpga_to_hps_out_state <= 4'd0;
		end
	end
	
	//////////////////////////////////
	// global to processing elements 
	//////////////////////////////////
	
	wire [26:0] global2pe_data;
	wire [6:0] global2pe_addr;
	wire global2pe_we;
	wire computing_on;
	// Command from hps[13:10]
	//			 	4'b0001: init, 
	//				4'b0010: computing, 
	//				4'b0100: read single M10K, 
	//				4'b1000: read all M10K, 
	//				*4'b0000: Reset
	
	assign global2pe_data = hps2m10k_data;	
	assign global2pe_we	 = (command_from_hps[13:10] == 4'b0001) ? hps2m10k_we : 1'b0;				//4'b0001: init (h2f)	
	assign global2pe_addr = (command_from_hps[13:10] == 4'b0001) ? hps2m10k_addr : read_M10K_addr; 
	assign computing_on = (command_from_hps[13:10] == 4'b0010) ? 1'b1 : 1'b0;
	assign target_pe = (command_from_hps[13:10] == 4'b0001) ? data_buffer[31:27] :					// command_from_hps[5:0] for "read(4'b0100)", data_buffer[31:26] for init 
							 (command_from_hps[13:10] == 4'b0100) ? command_from_hps[5:0] : 6'd63;		// the idle state of target_pe is 6'd63 that is not pe number (pe number = [0 to 20]	
	assign read_M10K_data = (command_from_hps[5:0] == 6'd0) ? out_n[0] :
									(command_from_hps[5:0] == 6'd1) ? out_n[1] :	
									(command_from_hps[5:0] == 6'd2) ? out_n[2] : 
									(command_from_hps[5:0] == 6'd3) ? out_n[3] : 
									(command_from_hps[5:0] == 6'd4) ? out_n[4] : 
									(command_from_hps[5:0] == 6'd5) ? out_n[5] :
									(command_from_hps[5:0] == 6'd6) ? out_n[6] :
									(command_from_hps[5:0] == 6'd7) ? out_n[7] :
									(command_from_hps[5:0] == 6'd8) ? out_n[8] :
									(command_from_hps[5:0] == 6'd9) ? out_n[9] :
									(command_from_hps[5:0] == 6'd10) ? out_n[10] :
									(command_from_hps[5:0] == 6'd11) ? out_n[11] :	
									(command_from_hps[5:0] == 6'd12) ? out_n[12] : 27'b0;
									
	///////////////////////////////////////
	// generate Processing elements (PEs) 
	///////////////////////////////////////	
	localparam SIZE = 13;
		
	wire [26:0] out_n [SIZE-1:0];
	wire [6:0] 	out_n_addr [SIZE-1:0];
	wire [26:0] Vn1, Vn1_end;
	wire [6:0] 	Vn1_addr, Vn1_addr_end;
	wire  		starting_write;
	wire  		finishing_fdtd;
	wire			pe_rst;
	
	wire [15:0] iteration_number;		// this data from HPS
	wire [31:0] electrode_voltage;	// this data from HPS
	
	wire [26:0] r [SIZE-1:0];	

	assign r[0] = 27'b000000000000000000000000000;
	assign r[1] = 27'b010000001100000000000000000; // 6
	assign r[2] = 27'b010000000100000000000000000; // 3
	assign r[3] = 27'b010000000000000000000000000; // 2
	assign r[4] = 27'b001111111100000000000000000; // 1.5
	assign r[5] = 27'b001111111001100110011001100; // 1.2
	assign r[6] = 27'b001111111000000000000000000; // 1
	assign r[7] = 27'b001111110101101101101101101; // 0.857142857142857
	assign r[8] = 27'b001111110100000000000000000; // 0.75
	assign r[9] = 27'b001111110010101010101010101; // 0.666666666666667
	assign r[10] = 27'b001111110001100110011001100; // 0.6
	assign r[11] = 27'b001111110000101110100010111; // 0.545454545454546
	assign r[12] = 27'b001111110000000000000000000; // 0.5
	
	assign pe_rst = system_rest | rst_command;
	
	genvar i;
	generate 
		for (i=0; i<SIZE; i=i+1) begin: gen_inst
			if(i==0)
				jh_PE4FDTD_boundary pe_first
				(
					.clk(CLOCK_100),
					.rst(pe_rst),
					.pe_number32(i),
					.target_pe(target_pe),
					.data(global2pe_data),
					.addr(global2pe_addr),
					.we(global2pe_we),
					.computing_on(computing_on),
					.out_n(out_n[0]),					//	output Vn of pe0
					.n_addr(out_n_addr[1]),				// input Vn address of pe1 
					.Vn1(Vn1),						// input Vn1 of pe1
					.Vn1_addr(Vn1_addr),			// input Vn1 address of pe1
					.starting_write(starting_write),
					.finishing_fdtd(finishing_fdtd)
				);
			else if(i==1)
				jh_PE4FDTD #(.Z_SIZE(7'd110), .R_SIZE(5'd20)) pe	
				(
					.clk(CLOCK_100), 
					.rst(pe_rst), 
					.pe_number32(i),
					.target_pe(target_pe),
					.r(r[i]),
					.iteration_number(iteration_number),
					.data(global2pe_data), 
					.addr(global2pe_addr),
					.we(global2pe_we), 
					.computing_on(computing_on),
					.n_top(out_n[i+1]),
					.n_bottom(out_n[i-1]),
					.out_n(out_n[i]),							// output Vn 
					.out_n_addr(out_n_addr[i]),			// output Vn address
					.Vn1(Vn1),								// output Vn1
					.Vn1_addr(Vn1_addr),					// output Vn1 address
					.starting_write(starting_write),
					.finishing_fdtd(finishing_fdtd)
				);
			else if(i==SIZE-2)
				jh_PE4FDTD #(.Z_SIZE(7'd110), .R_SIZE(5'd20)) pe	
				(
					.clk(CLOCK_100), 
					.rst(pe_rst), 
					.pe_number32(i),
					.target_pe(target_pe),
					.r(r[i]),			//27'b001111110000011100011100011
					.iteration_number(iteration_number),
					.data(global2pe_data), 
					.addr(global2pe_addr),
					.we(global2pe_we), 
					.computing_on(computing_on),
					.n_top(out_n[i+1]),
					.n_bottom(out_n[i-1]),
					.out_n(out_n[i]),							// output Vn 
					.out_n_addr(out_n_addr[i]),			// output Vn address
					.Vn1(Vn1_end),								// output Vn1
					.Vn1_addr(Vn1_addr_end)					// output Vn1 address
				);
			else if(i==SIZE-1)
				jh_PE4FDTD_boundary pe_last
				(
					.clk(CLOCK_100),
					.rst(pe_rst),
					.pe_number32(i),
					.target_pe(target_pe),
					.data(global2pe_data),
					.addr(global2pe_addr),
					.we(global2pe_we),
					.computing_on(computing_on),
					.out_n(out_n[i]),					//	output Vn of pe0
					.n_addr(out_n_addr[i-1]),				// input Vn address of pe1 
					.Vn1(Vn1_end),						// input Vn1 of pe1
					.Vn1_addr(Vn1_addr_end),			// input Vn1 address of pe1
					.starting_write(starting_write),
					.finishing_fdtd(finishing_fdtd)
				);
			else
				jh_PE4FDTD #(.Z_SIZE(7'd110), .R_SIZE(5'd20)) pe	
				(
					.clk(CLOCK_100), 
					.rst(pe_rst), 
					.pe_number32(i),
					.target_pe(target_pe),
					.r(r[i]),
					.iteration_number(iteration_number),
					.data(global2pe_data), 
					.addr(global2pe_addr),
					.we(global2pe_we), 
					.computing_on(computing_on),
					.n_top(out_n[i+1]),
					.n_bottom(out_n[i-1]),
					.out_n(out_n[i]),							// output Vn 
					.out_n_addr(out_n_addr[i])			// output Vn address
				);
			end
		
	endgenerate


//=====================================================
//									QSYS	
//=====================================================									

nios2 nios2_sdram (
		.clk_clk                         (CLOCK_50),                   //    clk.clk
		.clock_bridge_65_out_clk_clk     (CLOCK_65),               		//    clock_bridge_65_out_clk.clk
		.clock_bridge_100_out_clk_clk    (CLOCK_100),              		//    clock_bridge_100_out_clk.clk
		
		.number32_export                	(electrode_voltage),          //    number32.export
      .reset_reset                     (1'b0),                     	//    reset.reset
		.hw_reset_external_connection_export          (hw_rest),           //          hw_reset_external_connection.export
		.sw_external_connection_export   (SW[9:0]), 							//		switches
		.o_temperature_external_connection_export (temperature1), 		// 	o_temperature_external_connection.export 
		.o_temperature2_external_connection_export(temperature2),  		//  	o_temperature2_external_connection.export
      .o_pw_forward_external_connection_export  (pw_forward),  		//  	o_pw_forward_external_connection.export
      .o_pw_reversed_external_connection_export (pw_reversed),  		// 	o_pw_reversed_external_connection.export
		.rf_on_off_external_connection_export 		(en_RF_hps),  					// 	rf_on_off_state_external_connection.export
		.command_from_hps_external_connection_export   (command_from_hps),  	//   data_read_write_external_connection.export 
		.sp_external_connection_export            	 (sp),             		//    sp_external_connection.export
      .thermocouples_sel_external_connection_export (thermo_sel), 			// thermocouples_sel_external_connection.export
      .electrode_voltage_external_connection_export (electrode_voltage), 	// electrode_voltage_external_connection.export
      .iteration_number_external_connection_export  (iteration_number),   	//  iteration_number_external_connection.export
      .finish_fdtd_external_connection_export       (finishing_fdtd),      //       finish_fdtd_external_connection.export
		.module_csr_external_connection_export        (module_csr),         	//        module_csr_external_connection.export
		.power_unlock_external_connection_export      (power_unlock),       //      power_unlock_external_connection.export
    
    
		//=============================================
	   //		On-chip SRAM for read RF power (M10K)
	   //=============================================
	   .clock_bridge_0_in_clk_clk                 (CLOCK_50),         //                 clock_bridge_0_in_clk.clk
   		
		.onchip_ram1_s1_address                    (sram_address),     //    onchip_ram1_s1.address
		.onchip_ram1_s1_clken                      (1'b1),             //    .clken
		.onchip_ram1_s1_chipselect                 (1'b1),             //    .chipselect
		.onchip_ram1_s1_write                      (sram_write),       //    .write
		.onchip_ram1_s1_readdata                   (sram_readdata),    //    .readdata
		.onchip_ram1_s1_writedata                  (sram_writedata),   //    .writedata
		.onchip_ram1_s1_byteenable                 (4'b0011),          //    .byteenable
		.onchip_ram1_reset1_reset                  (1'b0),             //                 onchip_ram1_reset1.reset
      .onchip_ram1_reset1_reset_req              (1'b0),             //                                   .reset_req
        
		.onchip_ram2_s1_address                    (sram_address2),    //    onchip_ram2_s1.address
		.onchip_ram2_s1_clken                      (1'b1),             //    .clken
		.onchip_ram2_s1_chipselect                 (1'b1),             //    .chipselect
		.onchip_ram2_s1_write                      (sram_write2),      //    .write
		.onchip_ram2_s1_readdata                   (sram_readdata2),   //    .readdata
		.onchip_ram2_s1_writedata                  (sram_writedata2),  //    .writedata
		.onchip_ram2_s1_byteenable                 (4'b0011),          //    .byteenable
		.onchip_ram2_reset1_reset                  (1'b0),             //                 onchip_ram2_reset1.reset
      .onchip_ram2_reset1_reset_req              (1'b0),             //                                   .reset_req
    
		//============
	   //		SDRAM
	   //============
		.sdram_wire_addr (DRAM_ADDR),
		.sdram_wire_ba (DRAM_BA),
		.sdram_wire_cas_n (DRAM_CAS_N),
		.sdram_wire_cke (DRAM_CKE),
		.sdram_wire_cs_n (DRAM_CS_N),
		.sdram_wire_dq (DRAM_DQ),
		.sdram_wire_dqm ({DRAM_UDQM,DRAM_LDQM}),
		.sdram_wire_ras_n (DRAM_RAS_N),
		.sdram_wire_we_n (DRAM_WE_N),
		.sdram_clk_clk (DRAM_CLK),                
	   
		//============
		//		VGA
		//============
		.video_ref_clk_clk (CLOCK2_50), 
		.vga_ref_reset_reset (1'b0),  		//vga_subsystem_video_pll_ref_reset.reset
		.vga_out_CLK      (VGA_CLK),      	//vga_out.CLK
		.vga_out_HS       (VGA_HS),       	//.HS
		.vga_out_VS       (VGA_VS),       	//.VS
		.vga_out_BLANK    (VGA_BLANK_N),    //.BLANK
		.vga_out_SYNC     (VGA_SYNC_N),     //.SYNC
		.vga_out_R        (VGA_R),        	//.R
		.vga_out_G        (VGA_G),        	//.G
		.vga_out_B        (VGA_B),
	
		//==============================
		//		ADC for temperature
		//==============================
		.adc_ltc2308_0_conduit_end_CONVST  (ADC_CONVST),  	// adc_ltc2308_0_conduit_end.CONVST
		.adc_ltc2308_0_conduit_end_SCK     (ADC_SCLK),     //                          .SCK
		.adc_ltc2308_0_conduit_end_SDI     (ADC_DIN),     	//                          .SDI
		.adc_ltc2308_0_conduit_end_SDO     (ADC_DOUT),     //                          .SDO
	
		//==============================
		//		EBAB for temperature
		//==============================
		.bridge_0_external_interface_address     (bus_addr ),     	// bridge_0_external_interface.address
		.bridge_0_external_interface_byte_enable (bus_byte_enable), //                            .byte_enable
		.bridge_0_external_interface_read        (bus_read),        //                            .read
		.bridge_0_external_interface_write       (bus_write),       //                            .write
		.bridge_0_external_interface_write_data  (bus_write_data),  //                            .write_data
		.bridge_0_external_interface_acknowledge (bus_ack), 			//                            .acknowledge
		.bridge_0_external_interface_read_data   (bus_read_data),   //                            .read_data

		//==============================
		//		FIFO for HPS to FPGA		
		//==============================
		.fifo_hps_to_fpga_out_readdata             (hps_to_fpga_readdata),             		//               fifo_hps_to_fpga_out.readdata
		.fifo_hps_to_fpga_out_read                 (hps_to_fpga_read),                 		//                                   .read
		.fifo_hps_to_fpga_out_waitrequest          (),          										//                                   .waitrequest
		.fifo_hps_to_fpga_out_csr_address          (hps_to_fpga_out_csr_address),          								//           fifo_hps_to_fpga_out_csr.address
		.fifo_hps_to_fpga_out_csr_read             (hps_to_fpga_out_csr_read),             							//                                   .read
		.fifo_hps_to_fpga_out_csr_writedata        (),         										//												 .writedata
		.fifo_hps_to_fpga_out_csr_write            (1'b0),            								//                                   .write
		.fifo_hps_to_fpga_out_csr_readdata         (hps_to_fpga_out_csr_readdata),         	//                                   .readdata
		.fifo_hps_to_fpga_reset_out_reset_n        (1'b1),         									//         fifo_hps_to_fpga_reset_out.reset_n
		.fifo_hps_to_fpga_clk_out_clk              (CLOCK_100),                 //              fifo_hps_to_fpga_clk_out.clk
  
		//==============================
		//		FIFO for FPGA to HPS
		//==============================
		.fifo_fpga_to_hps_in_writedata             (fpga_to_hps_in_writedata),          		//                   fifo_fpga_to_hps_in.writedata
		.fifo_fpga_to_hps_in_write                 (fpga_to_hps_in_write),               	//                                      .write
		.fifo_fpga_to_hps_in_csr_address           (fpga_to_hps_in_csr_address),              							//               fifo_fpga_to_hps_in_csr.address
		.fifo_fpga_to_hps_in_csr_read              (fpga_to_hps_in_csr_read),                 						//                                      .read
		.fifo_fpga_to_hps_in_csr_writedata         (),            									//                                      .writedata
		.fifo_fpga_to_hps_in_csr_write             (1'b0),                						//                                      .write
		.fifo_fpga_to_hps_in_csr_readdata          (fpga_to_hps_in_csr_readdata),       	//                                      .readdata
		.fifo_fpga_to_hps_reset_in_reset_n         (1'b1),            								//             fifo_fpga_to_hps_reset_in.reset_n
		.fifo_fpga_to_hps_clk_in_clk               (CLOCK_100),                   //               fifo_fpga_to_hps_clk_in.clk
    
	///////////////////////////////////////////////////////////////
		/// HPS system
		//////////////////////////////////////////////////////////////
	`ifdef ENABLE_HPS
		// DDR3 SDRAM
		.memory_mem_a			(HPS_DDR3_ADDR),
		.memory_mem_ba			(HPS_DDR3_BA),
		.memory_mem_ck			(HPS_DDR3_CK_P),
		.memory_mem_ck_n		(HPS_DDR3_CK_N),
		.memory_mem_cke		(HPS_DDR3_CKE),
		.memory_mem_cs_n		(HPS_DDR3_CS_N),
		.memory_mem_ras_n		(HPS_DDR3_RAS_N),
		.memory_mem_cas_n		(HPS_DDR3_CAS_N),
		.memory_mem_we_n		(HPS_DDR3_WE_N),
		.memory_mem_reset_n	(HPS_DDR3_RESET_N),
		.memory_mem_dq			(HPS_DDR3_DQ),
		.memory_mem_dqs		(HPS_DDR3_DQS_P),
		.memory_mem_dqs_n		(HPS_DDR3_DQS_N),
		.memory_mem_odt		(HPS_DDR3_ODT),
		.memory_mem_dm			(HPS_DDR3_DM),
		.memory_oct_rzqin		(HPS_DDR3_RZQ),
		
		//Ethernet
		.hps_io_hps_io_gpio_inst_GPIO35	(HPS_ENET_INT_N),
		.hps_io_hps_io_emac1_inst_TX_CLK	(HPS_ENET_GTX_CLK),
		.hps_io_hps_io_emac1_inst_TXD0	(HPS_ENET_TX_DATA[0]),
		.hps_io_hps_io_emac1_inst_TXD1	(HPS_ENET_TX_DATA[1]),
		.hps_io_hps_io_emac1_inst_TXD2	(HPS_ENET_TX_DATA[2]),
		.hps_io_hps_io_emac1_inst_TXD3	(HPS_ENET_TX_DATA[3]),
		.hps_io_hps_io_emac1_inst_RXD0	(HPS_ENET_RX_DATA[0]),
		.hps_io_hps_io_emac1_inst_MDIO	(HPS_ENET_MDIO),
		.hps_io_hps_io_emac1_inst_MDC		(HPS_ENET_MDC),
		.hps_io_hps_io_emac1_inst_RX_CTL	(HPS_ENET_RX_DV),
		.hps_io_hps_io_emac1_inst_TX_CTL	(HPS_ENET_TX_EN),
		.hps_io_hps_io_emac1_inst_RX_CLK	(HPS_ENET_RX_CLK),
		.hps_io_hps_io_emac1_inst_RXD1	(HPS_ENET_RX_DATA[1]),
		.hps_io_hps_io_emac1_inst_RXD2	(HPS_ENET_RX_DATA[2]),
		.hps_io_hps_io_emac1_inst_RXD3	(HPS_ENET_RX_DATA[3]),

		// Flash
		.hps_io_hps_io_qspi_inst_IO0	(HPS_FLASH_DATA[0]),
		.hps_io_hps_io_qspi_inst_IO1	(HPS_FLASH_DATA[1]),
		.hps_io_hps_io_qspi_inst_IO2	(HPS_FLASH_DATA[2]),
		.hps_io_hps_io_qspi_inst_IO3	(HPS_FLASH_DATA[3]),
		.hps_io_hps_io_qspi_inst_SS0	(HPS_FLASH_NCSO),
		.hps_io_hps_io_qspi_inst_CLK	(HPS_FLASH_DCLK),

		// Accelerometer
		.hps_io_hps_io_gpio_inst_GPIO61	(HPS_GSENSOR_INT),
		// General Purpose I/O
		//.hps_io_hps_io_gpio_inst_GPIO40	(HPS_LTC_GPIO),

		// SD Card
		.hps_io_hps_io_sdio_inst_CMD	(HPS_SD_CMD),
		.hps_io_hps_io_sdio_inst_D0	(HPS_SD_DATA[0]),
		.hps_io_hps_io_sdio_inst_D1	(HPS_SD_DATA[1]),
		.hps_io_hps_io_sdio_inst_CLK	(HPS_SD_CLK),
		.hps_io_hps_io_sdio_inst_D2	(HPS_SD_DATA[2]),
		.hps_io_hps_io_sdio_inst_D3	(HPS_SD_DATA[3]),

		// USB
		.hps_io_hps_io_gpio_inst_GPIO09	(HPS_CONV_USB_N),
		.hps_io_hps_io_usb1_inst_D0		(HPS_USB_DATA[0]),
		.hps_io_hps_io_usb1_inst_D1		(HPS_USB_DATA[1]),
		.hps_io_hps_io_usb1_inst_D2		(HPS_USB_DATA[2]),
		.hps_io_hps_io_usb1_inst_D3		(HPS_USB_DATA[3]),
		.hps_io_hps_io_usb1_inst_D4		(HPS_USB_DATA[4]),
		.hps_io_hps_io_usb1_inst_D5		(HPS_USB_DATA[5]),
		.hps_io_hps_io_usb1_inst_D6		(HPS_USB_DATA[6]),
		.hps_io_hps_io_usb1_inst_D7		(HPS_USB_DATA[7]),
		.hps_io_hps_io_usb1_inst_CLK		(HPS_USB_CLKOUT),
		.hps_io_hps_io_usb1_inst_STP		(HPS_USB_STP),
		.hps_io_hps_io_usb1_inst_DIR		(HPS_USB_DIR),
		.hps_io_hps_io_usb1_inst_NXT		(HPS_USB_NXT),

		// SPI
		.hps_io_hps_io_spim1_inst_CLK		(HPS_SPIM_CLK),
		.hps_io_hps_io_spim1_inst_MOSI	(HPS_SPIM_MOSI),
		.hps_io_hps_io_spim1_inst_MISO	(HPS_SPIM_MISO),
		.hps_io_hps_io_spim1_inst_SS0		(HPS_SPIM_SS),

		// UART
		.hps_io_hps_io_uart0_inst_RX	(HPS_UART_RX),
		.hps_io_hps_io_uart0_inst_TX	(HPS_UART_TX),

		// I2C
		.hps_io_hps_io_gpio_inst_GPIO48	(HPS_I2C_CONTROL),
		.hps_io_hps_io_i2c0_inst_SDA		(HPS_I2C1_SDAT),
		.hps_io_hps_io_i2c0_inst_SCL		(HPS_I2C1_SCLK),
		.hps_io_hps_io_i2c1_inst_SDA		(HPS_I2C2_SDAT),
		.hps_io_hps_io_i2c1_inst_SCL		(HPS_I2C2_SCLK),

		// Pushbutton
		.hps_io_hps_io_gpio_inst_GPIO54	(HPS_KEY),

		// LED
		.hps_io_hps_io_gpio_inst_GPIO53	(HPS_LED)
`endif 

);
endmodule

