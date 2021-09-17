
module VGA_subsystem (
	char_buffer_slave_byteenable,
	char_buffer_slave_chipselect,
	char_buffer_slave_read,
	char_buffer_slave_write,
	char_buffer_slave_writedata,
	char_buffer_slave_readdata,
	char_buffer_slave_waitrequest,
	char_buffer_slave_address,
	char_control_slave_address,
	char_control_slave_byteenable,
	char_control_slave_chipselect,
	char_control_slave_read,
	char_control_slave_write,
	char_control_slave_writedata,
	char_control_slave_readdata,
	pixel_dma_master_readdatavalid,
	pixel_dma_master_waitrequest,
	pixel_dma_master_address,
	pixel_dma_master_lock,
	pixel_dma_master_read,
	pixel_dma_master_readdata,
	pixel_dma_slave_address,
	pixel_dma_slave_byteenable,
	pixel_dma_slave_read,
	pixel_dma_slave_write,
	pixel_dma_slave_writedata,
	pixel_dma_slave_readdata,
	sys_clk_clk,
	sys_reset_reset_n,
	vga_out_CLK,
	vga_out_HS,
	vga_out_VS,
	vga_out_BLANK,
	vga_out_SYNC,
	vga_out_R,
	vga_out_G,
	vga_out_B,
	video_pll_ref_reset_reset,
	video_ref_clk_clk);	

	input		char_buffer_slave_byteenable;
	input		char_buffer_slave_chipselect;
	input		char_buffer_slave_read;
	input		char_buffer_slave_write;
	input	[7:0]	char_buffer_slave_writedata;
	output	[7:0]	char_buffer_slave_readdata;
	output		char_buffer_slave_waitrequest;
	input	[12:0]	char_buffer_slave_address;
	input		char_control_slave_address;
	input	[3:0]	char_control_slave_byteenable;
	input		char_control_slave_chipselect;
	input		char_control_slave_read;
	input		char_control_slave_write;
	input	[31:0]	char_control_slave_writedata;
	output	[31:0]	char_control_slave_readdata;
	input		pixel_dma_master_readdatavalid;
	input		pixel_dma_master_waitrequest;
	output	[31:0]	pixel_dma_master_address;
	output		pixel_dma_master_lock;
	output		pixel_dma_master_read;
	input	[15:0]	pixel_dma_master_readdata;
	input	[1:0]	pixel_dma_slave_address;
	input	[3:0]	pixel_dma_slave_byteenable;
	input		pixel_dma_slave_read;
	input		pixel_dma_slave_write;
	input	[31:0]	pixel_dma_slave_writedata;
	output	[31:0]	pixel_dma_slave_readdata;
	input		sys_clk_clk;
	input		sys_reset_reset_n;
	output		vga_out_CLK;
	output		vga_out_HS;
	output		vga_out_VS;
	output		vga_out_BLANK;
	output		vga_out_SYNC;
	output	[7:0]	vga_out_R;
	output	[7:0]	vga_out_G;
	output	[7:0]	vga_out_B;
	input		video_pll_ref_reset_reset;
	input		video_ref_clk_clk;
endmodule
