	component nios2 is
		port (
			adc_ltc2308_0_conduit_end_CONVST             : out   std_logic;                                        -- CONVST
			adc_ltc2308_0_conduit_end_SCK                : out   std_logic;                                        -- SCK
			adc_ltc2308_0_conduit_end_SDI                : out   std_logic;                                        -- SDI
			adc_ltc2308_0_conduit_end_SDO                : in    std_logic                     := 'X';             -- SDO
			bridge_0_external_interface_address          : in    std_logic_vector(4 downto 0)  := (others => 'X'); -- address
			bridge_0_external_interface_byte_enable      : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byte_enable
			bridge_0_external_interface_read             : in    std_logic                     := 'X';             -- read
			bridge_0_external_interface_write            : in    std_logic                     := 'X';             -- write
			bridge_0_external_interface_write_data       : in    std_logic_vector(15 downto 0) := (others => 'X'); -- write_data
			bridge_0_external_interface_acknowledge      : out   std_logic;                                        -- acknowledge
			bridge_0_external_interface_read_data        : out   std_logic_vector(15 downto 0);                    -- read_data
			clk_clk                                      : in    std_logic                     := 'X';             -- clk
			clock_bridge_0_in_clk_clk                    : in    std_logic                     := 'X';             -- clk
			clock_bridge_100_out_clk_clk                 : out   std_logic;                                        -- clk
			clock_bridge_65_out_clk_clk                  : out   std_logic;                                        -- clk
			command_from_hps_external_connection_export  : out   std_logic_vector(31 downto 0);                    -- export
			electrode_voltage_external_connection_export : out   std_logic_vector(31 downto 0);                    -- export
			fifo_fpga_to_hps_clk_in_clk                  : in    std_logic                     := 'X';             -- clk
			fifo_fpga_to_hps_in_writedata                : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			fifo_fpga_to_hps_in_write                    : in    std_logic                     := 'X';             -- write
			fifo_fpga_to_hps_in_csr_address              : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			fifo_fpga_to_hps_in_csr_read                 : in    std_logic                     := 'X';             -- read
			fifo_fpga_to_hps_in_csr_writedata            : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			fifo_fpga_to_hps_in_csr_write                : in    std_logic                     := 'X';             -- write
			fifo_fpga_to_hps_in_csr_readdata             : out   std_logic_vector(31 downto 0);                    -- readdata
			fifo_fpga_to_hps_reset_in_reset_n            : in    std_logic                     := 'X';             -- reset_n
			fifo_hps_to_fpga_clk_out_clk                 : in    std_logic                     := 'X';             -- clk
			fifo_hps_to_fpga_out_readdata                : out   std_logic_vector(31 downto 0);                    -- readdata
			fifo_hps_to_fpga_out_read                    : in    std_logic                     := 'X';             -- read
			fifo_hps_to_fpga_out_csr_address             : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			fifo_hps_to_fpga_out_csr_read                : in    std_logic                     := 'X';             -- read
			fifo_hps_to_fpga_out_csr_writedata           : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			fifo_hps_to_fpga_out_csr_write               : in    std_logic                     := 'X';             -- write
			fifo_hps_to_fpga_out_csr_readdata            : out   std_logic_vector(31 downto 0);                    -- readdata
			fifo_hps_to_fpga_reset_out_reset_n           : in    std_logic                     := 'X';             -- reset_n
			finish_fdtd_external_connection_export       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			hps_io_hps_io_emac1_inst_TX_CLK              : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0                : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1                : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2                : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3                : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO                : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC                 : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL              : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0                  : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1                  : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2                  : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3                  : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0                  : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK                  : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK                  : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP                  : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK                 : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI                : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO                : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0                 : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX                  : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX                  : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA                  : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL                  : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA                  : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL                  : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO48               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			hw_reset_external_connection_export          : out   std_logic_vector(7 downto 0);                     -- export
			iteration_number_external_connection_export  : out   std_logic_vector(15 downto 0);                    -- export
			memory_mem_a                                 : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                                : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                                : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                              : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                               : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                              : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                             : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                             : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                              : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                           : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                                : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                               : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                             : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                               : out   std_logic;                                        -- mem_odt
			memory_mem_dm                                : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                             : in    std_logic                     := 'X';             -- oct_rzqin
			module_csr_external_connection_export        : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			number32_export                              : in    std_logic_vector(31 downto 0) := (others => 'X'); -- export
			o_pw_forward_external_connection_export      : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			o_pw_reversed_external_connection_export     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			o_temperature2_external_connection_export    : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			o_temperature_external_connection_export     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			onchip_ram1_reset1_reset                     : in    std_logic                     := 'X';             -- reset
			onchip_ram1_reset1_reset_req                 : in    std_logic                     := 'X';             -- reset_req
			onchip_ram1_s1_address                       : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- address
			onchip_ram1_s1_clken                         : in    std_logic                     := 'X';             -- clken
			onchip_ram1_s1_chipselect                    : in    std_logic                     := 'X';             -- chipselect
			onchip_ram1_s1_write                         : in    std_logic                     := 'X';             -- write
			onchip_ram1_s1_readdata                      : out   std_logic_vector(15 downto 0);                    -- readdata
			onchip_ram1_s1_writedata                     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			onchip_ram1_s1_byteenable                    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			onchip_ram2_reset1_reset                     : in    std_logic                     := 'X';             -- reset
			onchip_ram2_reset1_reset_req                 : in    std_logic                     := 'X';             -- reset_req
			onchip_ram2_s1_address                       : in    std_logic_vector(6 downto 0)  := (others => 'X'); -- address
			onchip_ram2_s1_clken                         : in    std_logic                     := 'X';             -- clken
			onchip_ram2_s1_chipselect                    : in    std_logic                     := 'X';             -- chipselect
			onchip_ram2_s1_write                         : in    std_logic                     := 'X';             -- write
			onchip_ram2_s1_readdata                      : out   std_logic_vector(15 downto 0);                    -- readdata
			onchip_ram2_s1_writedata                     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			onchip_ram2_s1_byteenable                    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			pll_adc_locked_export                        : out   std_logic;                                        -- export
			power_unlock_external_connection_export      : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset                                  : in    std_logic                     := 'X';             -- reset
			rf_on_off_external_connection_export         : out   std_logic;                                        -- export
			sdram_clk_clk                                : out   std_logic;                                        -- clk
			sdram_wire_addr                              : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba                                : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n                             : out   std_logic;                                        -- cas_n
			sdram_wire_cke                               : out   std_logic;                                        -- cke
			sdram_wire_cs_n                              : out   std_logic;                                        -- cs_n
			sdram_wire_dq                                : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm                               : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n                             : out   std_logic;                                        -- ras_n
			sdram_wire_we_n                              : out   std_logic;                                        -- we_n
			sp_external_connection_export                : out   std_logic_vector(19 downto 0);                    -- export
			sw_external_connection_export                : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			thermocouples_sel_external_connection_export : out   std_logic;                                        -- export
			vga_out_CLK                                  : out   std_logic;                                        -- CLK
			vga_out_HS                                   : out   std_logic;                                        -- HS
			vga_out_VS                                   : out   std_logic;                                        -- VS
			vga_out_BLANK                                : out   std_logic;                                        -- BLANK
			vga_out_SYNC                                 : out   std_logic;                                        -- SYNC
			vga_out_R                                    : out   std_logic_vector(7 downto 0);                     -- R
			vga_out_G                                    : out   std_logic_vector(7 downto 0);                     -- G
			vga_out_B                                    : out   std_logic_vector(7 downto 0);                     -- B
			vga_ref_reset_reset                          : in    std_logic                     := 'X';             -- reset
			video_ref_clk_clk                            : in    std_logic                     := 'X'              -- clk
		);
	end component nios2;

	u0 : component nios2
		port map (
			adc_ltc2308_0_conduit_end_CONVST             => CONNECTED_TO_adc_ltc2308_0_conduit_end_CONVST,             --             adc_ltc2308_0_conduit_end.CONVST
			adc_ltc2308_0_conduit_end_SCK                => CONNECTED_TO_adc_ltc2308_0_conduit_end_SCK,                --                                      .SCK
			adc_ltc2308_0_conduit_end_SDI                => CONNECTED_TO_adc_ltc2308_0_conduit_end_SDI,                --                                      .SDI
			adc_ltc2308_0_conduit_end_SDO                => CONNECTED_TO_adc_ltc2308_0_conduit_end_SDO,                --                                      .SDO
			bridge_0_external_interface_address          => CONNECTED_TO_bridge_0_external_interface_address,          --           bridge_0_external_interface.address
			bridge_0_external_interface_byte_enable      => CONNECTED_TO_bridge_0_external_interface_byte_enable,      --                                      .byte_enable
			bridge_0_external_interface_read             => CONNECTED_TO_bridge_0_external_interface_read,             --                                      .read
			bridge_0_external_interface_write            => CONNECTED_TO_bridge_0_external_interface_write,            --                                      .write
			bridge_0_external_interface_write_data       => CONNECTED_TO_bridge_0_external_interface_write_data,       --                                      .write_data
			bridge_0_external_interface_acknowledge      => CONNECTED_TO_bridge_0_external_interface_acknowledge,      --                                      .acknowledge
			bridge_0_external_interface_read_data        => CONNECTED_TO_bridge_0_external_interface_read_data,        --                                      .read_data
			clk_clk                                      => CONNECTED_TO_clk_clk,                                      --                                   clk.clk
			clock_bridge_0_in_clk_clk                    => CONNECTED_TO_clock_bridge_0_in_clk_clk,                    --                 clock_bridge_0_in_clk.clk
			clock_bridge_100_out_clk_clk                 => CONNECTED_TO_clock_bridge_100_out_clk_clk,                 --              clock_bridge_100_out_clk.clk
			clock_bridge_65_out_clk_clk                  => CONNECTED_TO_clock_bridge_65_out_clk_clk,                  --               clock_bridge_65_out_clk.clk
			command_from_hps_external_connection_export  => CONNECTED_TO_command_from_hps_external_connection_export,  --  command_from_hps_external_connection.export
			electrode_voltage_external_connection_export => CONNECTED_TO_electrode_voltage_external_connection_export, -- electrode_voltage_external_connection.export
			fifo_fpga_to_hps_clk_in_clk                  => CONNECTED_TO_fifo_fpga_to_hps_clk_in_clk,                  --               fifo_fpga_to_hps_clk_in.clk
			fifo_fpga_to_hps_in_writedata                => CONNECTED_TO_fifo_fpga_to_hps_in_writedata,                --                   fifo_fpga_to_hps_in.writedata
			fifo_fpga_to_hps_in_write                    => CONNECTED_TO_fifo_fpga_to_hps_in_write,                    --                                      .write
			fifo_fpga_to_hps_in_csr_address              => CONNECTED_TO_fifo_fpga_to_hps_in_csr_address,              --               fifo_fpga_to_hps_in_csr.address
			fifo_fpga_to_hps_in_csr_read                 => CONNECTED_TO_fifo_fpga_to_hps_in_csr_read,                 --                                      .read
			fifo_fpga_to_hps_in_csr_writedata            => CONNECTED_TO_fifo_fpga_to_hps_in_csr_writedata,            --                                      .writedata
			fifo_fpga_to_hps_in_csr_write                => CONNECTED_TO_fifo_fpga_to_hps_in_csr_write,                --                                      .write
			fifo_fpga_to_hps_in_csr_readdata             => CONNECTED_TO_fifo_fpga_to_hps_in_csr_readdata,             --                                      .readdata
			fifo_fpga_to_hps_reset_in_reset_n            => CONNECTED_TO_fifo_fpga_to_hps_reset_in_reset_n,            --             fifo_fpga_to_hps_reset_in.reset_n
			fifo_hps_to_fpga_clk_out_clk                 => CONNECTED_TO_fifo_hps_to_fpga_clk_out_clk,                 --              fifo_hps_to_fpga_clk_out.clk
			fifo_hps_to_fpga_out_readdata                => CONNECTED_TO_fifo_hps_to_fpga_out_readdata,                --                  fifo_hps_to_fpga_out.readdata
			fifo_hps_to_fpga_out_read                    => CONNECTED_TO_fifo_hps_to_fpga_out_read,                    --                                      .read
			fifo_hps_to_fpga_out_csr_address             => CONNECTED_TO_fifo_hps_to_fpga_out_csr_address,             --              fifo_hps_to_fpga_out_csr.address
			fifo_hps_to_fpga_out_csr_read                => CONNECTED_TO_fifo_hps_to_fpga_out_csr_read,                --                                      .read
			fifo_hps_to_fpga_out_csr_writedata           => CONNECTED_TO_fifo_hps_to_fpga_out_csr_writedata,           --                                      .writedata
			fifo_hps_to_fpga_out_csr_write               => CONNECTED_TO_fifo_hps_to_fpga_out_csr_write,               --                                      .write
			fifo_hps_to_fpga_out_csr_readdata            => CONNECTED_TO_fifo_hps_to_fpga_out_csr_readdata,            --                                      .readdata
			fifo_hps_to_fpga_reset_out_reset_n           => CONNECTED_TO_fifo_hps_to_fpga_reset_out_reset_n,           --            fifo_hps_to_fpga_reset_out.reset_n
			finish_fdtd_external_connection_export       => CONNECTED_TO_finish_fdtd_external_connection_export,       --       finish_fdtd_external_connection.export
			hps_io_hps_io_emac1_inst_TX_CLK              => CONNECTED_TO_hps_io_hps_io_emac1_inst_TX_CLK,              --                                hps_io.hps_io_emac1_inst_TX_CLK
			hps_io_hps_io_emac1_inst_TXD0                => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD0,                --                                      .hps_io_emac1_inst_TXD0
			hps_io_hps_io_emac1_inst_TXD1                => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD1,                --                                      .hps_io_emac1_inst_TXD1
			hps_io_hps_io_emac1_inst_TXD2                => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD2,                --                                      .hps_io_emac1_inst_TXD2
			hps_io_hps_io_emac1_inst_TXD3                => CONNECTED_TO_hps_io_hps_io_emac1_inst_TXD3,                --                                      .hps_io_emac1_inst_TXD3
			hps_io_hps_io_emac1_inst_RXD0                => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD0,                --                                      .hps_io_emac1_inst_RXD0
			hps_io_hps_io_emac1_inst_MDIO                => CONNECTED_TO_hps_io_hps_io_emac1_inst_MDIO,                --                                      .hps_io_emac1_inst_MDIO
			hps_io_hps_io_emac1_inst_MDC                 => CONNECTED_TO_hps_io_hps_io_emac1_inst_MDC,                 --                                      .hps_io_emac1_inst_MDC
			hps_io_hps_io_emac1_inst_RX_CTL              => CONNECTED_TO_hps_io_hps_io_emac1_inst_RX_CTL,              --                                      .hps_io_emac1_inst_RX_CTL
			hps_io_hps_io_emac1_inst_TX_CTL              => CONNECTED_TO_hps_io_hps_io_emac1_inst_TX_CTL,              --                                      .hps_io_emac1_inst_TX_CTL
			hps_io_hps_io_emac1_inst_RX_CLK              => CONNECTED_TO_hps_io_hps_io_emac1_inst_RX_CLK,              --                                      .hps_io_emac1_inst_RX_CLK
			hps_io_hps_io_emac1_inst_RXD1                => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD1,                --                                      .hps_io_emac1_inst_RXD1
			hps_io_hps_io_emac1_inst_RXD2                => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD2,                --                                      .hps_io_emac1_inst_RXD2
			hps_io_hps_io_emac1_inst_RXD3                => CONNECTED_TO_hps_io_hps_io_emac1_inst_RXD3,                --                                      .hps_io_emac1_inst_RXD3
			hps_io_hps_io_qspi_inst_IO0                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO0,                  --                                      .hps_io_qspi_inst_IO0
			hps_io_hps_io_qspi_inst_IO1                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO1,                  --                                      .hps_io_qspi_inst_IO1
			hps_io_hps_io_qspi_inst_IO2                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO2,                  --                                      .hps_io_qspi_inst_IO2
			hps_io_hps_io_qspi_inst_IO3                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_IO3,                  --                                      .hps_io_qspi_inst_IO3
			hps_io_hps_io_qspi_inst_SS0                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_SS0,                  --                                      .hps_io_qspi_inst_SS0
			hps_io_hps_io_qspi_inst_CLK                  => CONNECTED_TO_hps_io_hps_io_qspi_inst_CLK,                  --                                      .hps_io_qspi_inst_CLK
			hps_io_hps_io_sdio_inst_CMD                  => CONNECTED_TO_hps_io_hps_io_sdio_inst_CMD,                  --                                      .hps_io_sdio_inst_CMD
			hps_io_hps_io_sdio_inst_D0                   => CONNECTED_TO_hps_io_hps_io_sdio_inst_D0,                   --                                      .hps_io_sdio_inst_D0
			hps_io_hps_io_sdio_inst_D1                   => CONNECTED_TO_hps_io_hps_io_sdio_inst_D1,                   --                                      .hps_io_sdio_inst_D1
			hps_io_hps_io_sdio_inst_CLK                  => CONNECTED_TO_hps_io_hps_io_sdio_inst_CLK,                  --                                      .hps_io_sdio_inst_CLK
			hps_io_hps_io_sdio_inst_D2                   => CONNECTED_TO_hps_io_hps_io_sdio_inst_D2,                   --                                      .hps_io_sdio_inst_D2
			hps_io_hps_io_sdio_inst_D3                   => CONNECTED_TO_hps_io_hps_io_sdio_inst_D3,                   --                                      .hps_io_sdio_inst_D3
			hps_io_hps_io_usb1_inst_D0                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D0,                   --                                      .hps_io_usb1_inst_D0
			hps_io_hps_io_usb1_inst_D1                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D1,                   --                                      .hps_io_usb1_inst_D1
			hps_io_hps_io_usb1_inst_D2                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D2,                   --                                      .hps_io_usb1_inst_D2
			hps_io_hps_io_usb1_inst_D3                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D3,                   --                                      .hps_io_usb1_inst_D3
			hps_io_hps_io_usb1_inst_D4                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D4,                   --                                      .hps_io_usb1_inst_D4
			hps_io_hps_io_usb1_inst_D5                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D5,                   --                                      .hps_io_usb1_inst_D5
			hps_io_hps_io_usb1_inst_D6                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D6,                   --                                      .hps_io_usb1_inst_D6
			hps_io_hps_io_usb1_inst_D7                   => CONNECTED_TO_hps_io_hps_io_usb1_inst_D7,                   --                                      .hps_io_usb1_inst_D7
			hps_io_hps_io_usb1_inst_CLK                  => CONNECTED_TO_hps_io_hps_io_usb1_inst_CLK,                  --                                      .hps_io_usb1_inst_CLK
			hps_io_hps_io_usb1_inst_STP                  => CONNECTED_TO_hps_io_hps_io_usb1_inst_STP,                  --                                      .hps_io_usb1_inst_STP
			hps_io_hps_io_usb1_inst_DIR                  => CONNECTED_TO_hps_io_hps_io_usb1_inst_DIR,                  --                                      .hps_io_usb1_inst_DIR
			hps_io_hps_io_usb1_inst_NXT                  => CONNECTED_TO_hps_io_hps_io_usb1_inst_NXT,                  --                                      .hps_io_usb1_inst_NXT
			hps_io_hps_io_spim1_inst_CLK                 => CONNECTED_TO_hps_io_hps_io_spim1_inst_CLK,                 --                                      .hps_io_spim1_inst_CLK
			hps_io_hps_io_spim1_inst_MOSI                => CONNECTED_TO_hps_io_hps_io_spim1_inst_MOSI,                --                                      .hps_io_spim1_inst_MOSI
			hps_io_hps_io_spim1_inst_MISO                => CONNECTED_TO_hps_io_hps_io_spim1_inst_MISO,                --                                      .hps_io_spim1_inst_MISO
			hps_io_hps_io_spim1_inst_SS0                 => CONNECTED_TO_hps_io_hps_io_spim1_inst_SS0,                 --                                      .hps_io_spim1_inst_SS0
			hps_io_hps_io_uart0_inst_RX                  => CONNECTED_TO_hps_io_hps_io_uart0_inst_RX,                  --                                      .hps_io_uart0_inst_RX
			hps_io_hps_io_uart0_inst_TX                  => CONNECTED_TO_hps_io_hps_io_uart0_inst_TX,                  --                                      .hps_io_uart0_inst_TX
			hps_io_hps_io_i2c0_inst_SDA                  => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SDA,                  --                                      .hps_io_i2c0_inst_SDA
			hps_io_hps_io_i2c0_inst_SCL                  => CONNECTED_TO_hps_io_hps_io_i2c0_inst_SCL,                  --                                      .hps_io_i2c0_inst_SCL
			hps_io_hps_io_i2c1_inst_SDA                  => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SDA,                  --                                      .hps_io_i2c1_inst_SDA
			hps_io_hps_io_i2c1_inst_SCL                  => CONNECTED_TO_hps_io_hps_io_i2c1_inst_SCL,                  --                                      .hps_io_i2c1_inst_SCL
			hps_io_hps_io_gpio_inst_GPIO09               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO09,               --                                      .hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO35               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO35,               --                                      .hps_io_gpio_inst_GPIO35
			hps_io_hps_io_gpio_inst_GPIO48               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO48,               --                                      .hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO53               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO53,               --                                      .hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO54,               --                                      .hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO61               => CONNECTED_TO_hps_io_hps_io_gpio_inst_GPIO61,               --                                      .hps_io_gpio_inst_GPIO61
			hw_reset_external_connection_export          => CONNECTED_TO_hw_reset_external_connection_export,          --          hw_reset_external_connection.export
			iteration_number_external_connection_export  => CONNECTED_TO_iteration_number_external_connection_export,  --  iteration_number_external_connection.export
			memory_mem_a                                 => CONNECTED_TO_memory_mem_a,                                 --                                memory.mem_a
			memory_mem_ba                                => CONNECTED_TO_memory_mem_ba,                                --                                      .mem_ba
			memory_mem_ck                                => CONNECTED_TO_memory_mem_ck,                                --                                      .mem_ck
			memory_mem_ck_n                              => CONNECTED_TO_memory_mem_ck_n,                              --                                      .mem_ck_n
			memory_mem_cke                               => CONNECTED_TO_memory_mem_cke,                               --                                      .mem_cke
			memory_mem_cs_n                              => CONNECTED_TO_memory_mem_cs_n,                              --                                      .mem_cs_n
			memory_mem_ras_n                             => CONNECTED_TO_memory_mem_ras_n,                             --                                      .mem_ras_n
			memory_mem_cas_n                             => CONNECTED_TO_memory_mem_cas_n,                             --                                      .mem_cas_n
			memory_mem_we_n                              => CONNECTED_TO_memory_mem_we_n,                              --                                      .mem_we_n
			memory_mem_reset_n                           => CONNECTED_TO_memory_mem_reset_n,                           --                                      .mem_reset_n
			memory_mem_dq                                => CONNECTED_TO_memory_mem_dq,                                --                                      .mem_dq
			memory_mem_dqs                               => CONNECTED_TO_memory_mem_dqs,                               --                                      .mem_dqs
			memory_mem_dqs_n                             => CONNECTED_TO_memory_mem_dqs_n,                             --                                      .mem_dqs_n
			memory_mem_odt                               => CONNECTED_TO_memory_mem_odt,                               --                                      .mem_odt
			memory_mem_dm                                => CONNECTED_TO_memory_mem_dm,                                --                                      .mem_dm
			memory_oct_rzqin                             => CONNECTED_TO_memory_oct_rzqin,                             --                                      .oct_rzqin
			module_csr_external_connection_export        => CONNECTED_TO_module_csr_external_connection_export,        --        module_csr_external_connection.export
			number32_export                              => CONNECTED_TO_number32_export,                              --                              number32.export
			o_pw_forward_external_connection_export      => CONNECTED_TO_o_pw_forward_external_connection_export,      --      o_pw_forward_external_connection.export
			o_pw_reversed_external_connection_export     => CONNECTED_TO_o_pw_reversed_external_connection_export,     --     o_pw_reversed_external_connection.export
			o_temperature2_external_connection_export    => CONNECTED_TO_o_temperature2_external_connection_export,    --    o_temperature2_external_connection.export
			o_temperature_external_connection_export     => CONNECTED_TO_o_temperature_external_connection_export,     --     o_temperature_external_connection.export
			onchip_ram1_reset1_reset                     => CONNECTED_TO_onchip_ram1_reset1_reset,                     --                    onchip_ram1_reset1.reset
			onchip_ram1_reset1_reset_req                 => CONNECTED_TO_onchip_ram1_reset1_reset_req,                 --                                      .reset_req
			onchip_ram1_s1_address                       => CONNECTED_TO_onchip_ram1_s1_address,                       --                        onchip_ram1_s1.address
			onchip_ram1_s1_clken                         => CONNECTED_TO_onchip_ram1_s1_clken,                         --                                      .clken
			onchip_ram1_s1_chipselect                    => CONNECTED_TO_onchip_ram1_s1_chipselect,                    --                                      .chipselect
			onchip_ram1_s1_write                         => CONNECTED_TO_onchip_ram1_s1_write,                         --                                      .write
			onchip_ram1_s1_readdata                      => CONNECTED_TO_onchip_ram1_s1_readdata,                      --                                      .readdata
			onchip_ram1_s1_writedata                     => CONNECTED_TO_onchip_ram1_s1_writedata,                     --                                      .writedata
			onchip_ram1_s1_byteenable                    => CONNECTED_TO_onchip_ram1_s1_byteenable,                    --                                      .byteenable
			onchip_ram2_reset1_reset                     => CONNECTED_TO_onchip_ram2_reset1_reset,                     --                    onchip_ram2_reset1.reset
			onchip_ram2_reset1_reset_req                 => CONNECTED_TO_onchip_ram2_reset1_reset_req,                 --                                      .reset_req
			onchip_ram2_s1_address                       => CONNECTED_TO_onchip_ram2_s1_address,                       --                        onchip_ram2_s1.address
			onchip_ram2_s1_clken                         => CONNECTED_TO_onchip_ram2_s1_clken,                         --                                      .clken
			onchip_ram2_s1_chipselect                    => CONNECTED_TO_onchip_ram2_s1_chipselect,                    --                                      .chipselect
			onchip_ram2_s1_write                         => CONNECTED_TO_onchip_ram2_s1_write,                         --                                      .write
			onchip_ram2_s1_readdata                      => CONNECTED_TO_onchip_ram2_s1_readdata,                      --                                      .readdata
			onchip_ram2_s1_writedata                     => CONNECTED_TO_onchip_ram2_s1_writedata,                     --                                      .writedata
			onchip_ram2_s1_byteenable                    => CONNECTED_TO_onchip_ram2_s1_byteenable,                    --                                      .byteenable
			pll_adc_locked_export                        => CONNECTED_TO_pll_adc_locked_export,                        --                        pll_adc_locked.export
			power_unlock_external_connection_export      => CONNECTED_TO_power_unlock_external_connection_export,      --      power_unlock_external_connection.export
			reset_reset                                  => CONNECTED_TO_reset_reset,                                  --                                 reset.reset
			rf_on_off_external_connection_export         => CONNECTED_TO_rf_on_off_external_connection_export,         --         rf_on_off_external_connection.export
			sdram_clk_clk                                => CONNECTED_TO_sdram_clk_clk,                                --                             sdram_clk.clk
			sdram_wire_addr                              => CONNECTED_TO_sdram_wire_addr,                              --                            sdram_wire.addr
			sdram_wire_ba                                => CONNECTED_TO_sdram_wire_ba,                                --                                      .ba
			sdram_wire_cas_n                             => CONNECTED_TO_sdram_wire_cas_n,                             --                                      .cas_n
			sdram_wire_cke                               => CONNECTED_TO_sdram_wire_cke,                               --                                      .cke
			sdram_wire_cs_n                              => CONNECTED_TO_sdram_wire_cs_n,                              --                                      .cs_n
			sdram_wire_dq                                => CONNECTED_TO_sdram_wire_dq,                                --                                      .dq
			sdram_wire_dqm                               => CONNECTED_TO_sdram_wire_dqm,                               --                                      .dqm
			sdram_wire_ras_n                             => CONNECTED_TO_sdram_wire_ras_n,                             --                                      .ras_n
			sdram_wire_we_n                              => CONNECTED_TO_sdram_wire_we_n,                              --                                      .we_n
			sp_external_connection_export                => CONNECTED_TO_sp_external_connection_export,                --                sp_external_connection.export
			sw_external_connection_export                => CONNECTED_TO_sw_external_connection_export,                --                sw_external_connection.export
			thermocouples_sel_external_connection_export => CONNECTED_TO_thermocouples_sel_external_connection_export, -- thermocouples_sel_external_connection.export
			vga_out_CLK                                  => CONNECTED_TO_vga_out_CLK,                                  --                               vga_out.CLK
			vga_out_HS                                   => CONNECTED_TO_vga_out_HS,                                   --                                      .HS
			vga_out_VS                                   => CONNECTED_TO_vga_out_VS,                                   --                                      .VS
			vga_out_BLANK                                => CONNECTED_TO_vga_out_BLANK,                                --                                      .BLANK
			vga_out_SYNC                                 => CONNECTED_TO_vga_out_SYNC,                                 --                                      .SYNC
			vga_out_R                                    => CONNECTED_TO_vga_out_R,                                    --                                      .R
			vga_out_G                                    => CONNECTED_TO_vga_out_G,                                    --                                      .G
			vga_out_B                                    => CONNECTED_TO_vga_out_B,                                    --                                      .B
			vga_ref_reset_reset                          => CONNECTED_TO_vga_ref_reset_reset,                          --                         vga_ref_reset.reset
			video_ref_clk_clk                            => CONNECTED_TO_video_ref_clk_clk                             --                         video_ref_clk.clk
		);

