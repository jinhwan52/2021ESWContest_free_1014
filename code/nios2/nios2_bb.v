
module nios2 (
	adc_ltc2308_0_conduit_end_CONVST,
	adc_ltc2308_0_conduit_end_SCK,
	adc_ltc2308_0_conduit_end_SDI,
	adc_ltc2308_0_conduit_end_SDO,
	bridge_0_external_interface_address,
	bridge_0_external_interface_byte_enable,
	bridge_0_external_interface_read,
	bridge_0_external_interface_write,
	bridge_0_external_interface_write_data,
	bridge_0_external_interface_acknowledge,
	bridge_0_external_interface_read_data,
	clk_clk,
	clock_bridge_0_in_clk_clk,
	clock_bridge_100_out_clk_clk,
	clock_bridge_65_out_clk_clk,
	command_from_hps_external_connection_export,
	electrode_voltage_external_connection_export,
	fifo_fpga_to_hps_clk_in_clk,
	fifo_fpga_to_hps_in_writedata,
	fifo_fpga_to_hps_in_write,
	fifo_fpga_to_hps_in_csr_address,
	fifo_fpga_to_hps_in_csr_read,
	fifo_fpga_to_hps_in_csr_writedata,
	fifo_fpga_to_hps_in_csr_write,
	fifo_fpga_to_hps_in_csr_readdata,
	fifo_fpga_to_hps_reset_in_reset_n,
	fifo_hps_to_fpga_clk_out_clk,
	fifo_hps_to_fpga_out_readdata,
	fifo_hps_to_fpga_out_read,
	fifo_hps_to_fpga_out_csr_address,
	fifo_hps_to_fpga_out_csr_read,
	fifo_hps_to_fpga_out_csr_writedata,
	fifo_hps_to_fpga_out_csr_write,
	fifo_hps_to_fpga_out_csr_readdata,
	fifo_hps_to_fpga_reset_out_reset_n,
	finish_fdtd_external_connection_export,
	hps_io_hps_io_emac1_inst_TX_CLK,
	hps_io_hps_io_emac1_inst_TXD0,
	hps_io_hps_io_emac1_inst_TXD1,
	hps_io_hps_io_emac1_inst_TXD2,
	hps_io_hps_io_emac1_inst_TXD3,
	hps_io_hps_io_emac1_inst_RXD0,
	hps_io_hps_io_emac1_inst_MDIO,
	hps_io_hps_io_emac1_inst_MDC,
	hps_io_hps_io_emac1_inst_RX_CTL,
	hps_io_hps_io_emac1_inst_TX_CTL,
	hps_io_hps_io_emac1_inst_RX_CLK,
	hps_io_hps_io_emac1_inst_RXD1,
	hps_io_hps_io_emac1_inst_RXD2,
	hps_io_hps_io_emac1_inst_RXD3,
	hps_io_hps_io_qspi_inst_IO0,
	hps_io_hps_io_qspi_inst_IO1,
	hps_io_hps_io_qspi_inst_IO2,
	hps_io_hps_io_qspi_inst_IO3,
	hps_io_hps_io_qspi_inst_SS0,
	hps_io_hps_io_qspi_inst_CLK,
	hps_io_hps_io_sdio_inst_CMD,
	hps_io_hps_io_sdio_inst_D0,
	hps_io_hps_io_sdio_inst_D1,
	hps_io_hps_io_sdio_inst_CLK,
	hps_io_hps_io_sdio_inst_D2,
	hps_io_hps_io_sdio_inst_D3,
	hps_io_hps_io_usb1_inst_D0,
	hps_io_hps_io_usb1_inst_D1,
	hps_io_hps_io_usb1_inst_D2,
	hps_io_hps_io_usb1_inst_D3,
	hps_io_hps_io_usb1_inst_D4,
	hps_io_hps_io_usb1_inst_D5,
	hps_io_hps_io_usb1_inst_D6,
	hps_io_hps_io_usb1_inst_D7,
	hps_io_hps_io_usb1_inst_CLK,
	hps_io_hps_io_usb1_inst_STP,
	hps_io_hps_io_usb1_inst_DIR,
	hps_io_hps_io_usb1_inst_NXT,
	hps_io_hps_io_spim1_inst_CLK,
	hps_io_hps_io_spim1_inst_MOSI,
	hps_io_hps_io_spim1_inst_MISO,
	hps_io_hps_io_spim1_inst_SS0,
	hps_io_hps_io_uart0_inst_RX,
	hps_io_hps_io_uart0_inst_TX,
	hps_io_hps_io_i2c0_inst_SDA,
	hps_io_hps_io_i2c0_inst_SCL,
	hps_io_hps_io_i2c1_inst_SDA,
	hps_io_hps_io_i2c1_inst_SCL,
	hps_io_hps_io_gpio_inst_GPIO09,
	hps_io_hps_io_gpio_inst_GPIO35,
	hps_io_hps_io_gpio_inst_GPIO48,
	hps_io_hps_io_gpio_inst_GPIO53,
	hps_io_hps_io_gpio_inst_GPIO54,
	hps_io_hps_io_gpio_inst_GPIO61,
	hw_reset_external_connection_export,
	iteration_number_external_connection_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	module_csr_external_connection_export,
	number32_export,
	o_pw_forward_external_connection_export,
	o_pw_reversed_external_connection_export,
	o_temperature2_external_connection_export,
	o_temperature_external_connection_export,
	onchip_ram1_reset1_reset,
	onchip_ram1_reset1_reset_req,
	onchip_ram1_s1_address,
	onchip_ram1_s1_clken,
	onchip_ram1_s1_chipselect,
	onchip_ram1_s1_write,
	onchip_ram1_s1_readdata,
	onchip_ram1_s1_writedata,
	onchip_ram1_s1_byteenable,
	onchip_ram2_reset1_reset,
	onchip_ram2_reset1_reset_req,
	onchip_ram2_s1_address,
	onchip_ram2_s1_clken,
	onchip_ram2_s1_chipselect,
	onchip_ram2_s1_write,
	onchip_ram2_s1_readdata,
	onchip_ram2_s1_writedata,
	onchip_ram2_s1_byteenable,
	pll_adc_locked_export,
	power_unlock_external_connection_export,
	reset_reset,
	rf_on_off_external_connection_export,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	sp_external_connection_export,
	sw_external_connection_export,
	thermocouples_sel_external_connection_export,
	vga_out_CLK,
	vga_out_HS,
	vga_out_VS,
	vga_out_BLANK,
	vga_out_SYNC,
	vga_out_R,
	vga_out_G,
	vga_out_B,
	vga_ref_reset_reset,
	video_ref_clk_clk);	

	output		adc_ltc2308_0_conduit_end_CONVST;
	output		adc_ltc2308_0_conduit_end_SCK;
	output		adc_ltc2308_0_conduit_end_SDI;
	input		adc_ltc2308_0_conduit_end_SDO;
	input	[4:0]	bridge_0_external_interface_address;
	input	[1:0]	bridge_0_external_interface_byte_enable;
	input		bridge_0_external_interface_read;
	input		bridge_0_external_interface_write;
	input	[15:0]	bridge_0_external_interface_write_data;
	output		bridge_0_external_interface_acknowledge;
	output	[15:0]	bridge_0_external_interface_read_data;
	input		clk_clk;
	input		clock_bridge_0_in_clk_clk;
	output		clock_bridge_100_out_clk_clk;
	output		clock_bridge_65_out_clk_clk;
	output	[31:0]	command_from_hps_external_connection_export;
	output	[31:0]	electrode_voltage_external_connection_export;
	input		fifo_fpga_to_hps_clk_in_clk;
	input	[31:0]	fifo_fpga_to_hps_in_writedata;
	input		fifo_fpga_to_hps_in_write;
	input	[2:0]	fifo_fpga_to_hps_in_csr_address;
	input		fifo_fpga_to_hps_in_csr_read;
	input	[31:0]	fifo_fpga_to_hps_in_csr_writedata;
	input		fifo_fpga_to_hps_in_csr_write;
	output	[31:0]	fifo_fpga_to_hps_in_csr_readdata;
	input		fifo_fpga_to_hps_reset_in_reset_n;
	input		fifo_hps_to_fpga_clk_out_clk;
	output	[31:0]	fifo_hps_to_fpga_out_readdata;
	input		fifo_hps_to_fpga_out_read;
	input	[2:0]	fifo_hps_to_fpga_out_csr_address;
	input		fifo_hps_to_fpga_out_csr_read;
	input	[31:0]	fifo_hps_to_fpga_out_csr_writedata;
	input		fifo_hps_to_fpga_out_csr_write;
	output	[31:0]	fifo_hps_to_fpga_out_csr_readdata;
	input		fifo_hps_to_fpga_reset_out_reset_n;
	input	[7:0]	finish_fdtd_external_connection_export;
	output		hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_io_hps_io_emac1_inst_TXD0;
	output		hps_io_hps_io_emac1_inst_TXD1;
	output		hps_io_hps_io_emac1_inst_TXD2;
	output		hps_io_hps_io_emac1_inst_TXD3;
	input		hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_io_hps_io_emac1_inst_MDIO;
	output		hps_io_hps_io_emac1_inst_MDC;
	input		hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_io_hps_io_emac1_inst_RXD1;
	input		hps_io_hps_io_emac1_inst_RXD2;
	input		hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_io_hps_io_qspi_inst_IO0;
	inout		hps_io_hps_io_qspi_inst_IO1;
	inout		hps_io_hps_io_qspi_inst_IO2;
	inout		hps_io_hps_io_qspi_inst_IO3;
	output		hps_io_hps_io_qspi_inst_SS0;
	output		hps_io_hps_io_qspi_inst_CLK;
	inout		hps_io_hps_io_sdio_inst_CMD;
	inout		hps_io_hps_io_sdio_inst_D0;
	inout		hps_io_hps_io_sdio_inst_D1;
	output		hps_io_hps_io_sdio_inst_CLK;
	inout		hps_io_hps_io_sdio_inst_D2;
	inout		hps_io_hps_io_sdio_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D0;
	inout		hps_io_hps_io_usb1_inst_D1;
	inout		hps_io_hps_io_usb1_inst_D2;
	inout		hps_io_hps_io_usb1_inst_D3;
	inout		hps_io_hps_io_usb1_inst_D4;
	inout		hps_io_hps_io_usb1_inst_D5;
	inout		hps_io_hps_io_usb1_inst_D6;
	inout		hps_io_hps_io_usb1_inst_D7;
	input		hps_io_hps_io_usb1_inst_CLK;
	output		hps_io_hps_io_usb1_inst_STP;
	input		hps_io_hps_io_usb1_inst_DIR;
	input		hps_io_hps_io_usb1_inst_NXT;
	output		hps_io_hps_io_spim1_inst_CLK;
	output		hps_io_hps_io_spim1_inst_MOSI;
	input		hps_io_hps_io_spim1_inst_MISO;
	output		hps_io_hps_io_spim1_inst_SS0;
	input		hps_io_hps_io_uart0_inst_RX;
	output		hps_io_hps_io_uart0_inst_TX;
	inout		hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_io_hps_io_gpio_inst_GPIO48;
	inout		hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_io_hps_io_gpio_inst_GPIO61;
	output	[7:0]	hw_reset_external_connection_export;
	output	[15:0]	iteration_number_external_connection_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input	[15:0]	module_csr_external_connection_export;
	input	[31:0]	number32_export;
	input	[15:0]	o_pw_forward_external_connection_export;
	input	[15:0]	o_pw_reversed_external_connection_export;
	input	[15:0]	o_temperature2_external_connection_export;
	input	[15:0]	o_temperature_external_connection_export;
	input		onchip_ram1_reset1_reset;
	input		onchip_ram1_reset1_reset_req;
	input	[6:0]	onchip_ram1_s1_address;
	input		onchip_ram1_s1_clken;
	input		onchip_ram1_s1_chipselect;
	input		onchip_ram1_s1_write;
	output	[15:0]	onchip_ram1_s1_readdata;
	input	[15:0]	onchip_ram1_s1_writedata;
	input	[1:0]	onchip_ram1_s1_byteenable;
	input		onchip_ram2_reset1_reset;
	input		onchip_ram2_reset1_reset_req;
	input	[6:0]	onchip_ram2_s1_address;
	input		onchip_ram2_s1_clken;
	input		onchip_ram2_s1_chipselect;
	input		onchip_ram2_s1_write;
	output	[15:0]	onchip_ram2_s1_readdata;
	input	[15:0]	onchip_ram2_s1_writedata;
	input	[1:0]	onchip_ram2_s1_byteenable;
	output		pll_adc_locked_export;
	output	[7:0]	power_unlock_external_connection_export;
	input		reset_reset;
	output		rf_on_off_external_connection_export;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[19:0]	sp_external_connection_export;
	input	[9:0]	sw_external_connection_export;
	output		thermocouples_sel_external_connection_export;
	output		vga_out_CLK;
	output		vga_out_HS;
	output		vga_out_VS;
	output		vga_out_BLANK;
	output		vga_out_SYNC;
	output	[7:0]	vga_out_R;
	output	[7:0]	vga_out_G;
	output	[7:0]	vga_out_B;
	input		vga_ref_reset_reset;
	input		video_ref_clk_clk;
endmodule
