// VGA_subsystem_mm_interconnect_0.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module VGA_subsystem_mm_interconnect_0 (
		input  wire        Sys_Clk_clk_clk,                                              //                                            Sys_Clk_clk.clk
		input  wire        Pixel_DMA_Addr_Translation_reset_reset_bridge_in_reset_reset, // Pixel_DMA_Addr_Translation_reset_reset_bridge_in_reset.reset
		input  wire [1:0]  Pixel_DMA_Addr_Translation_master_address,                    //                      Pixel_DMA_Addr_Translation_master.address
		output wire        Pixel_DMA_Addr_Translation_master_waitrequest,                //                                                       .waitrequest
		input  wire [3:0]  Pixel_DMA_Addr_Translation_master_byteenable,                 //                                                       .byteenable
		input  wire        Pixel_DMA_Addr_Translation_master_read,                       //                                                       .read
		output wire [31:0] Pixel_DMA_Addr_Translation_master_readdata,                   //                                                       .readdata
		input  wire        Pixel_DMA_Addr_Translation_master_write,                      //                                                       .write
		input  wire [31:0] Pixel_DMA_Addr_Translation_master_writedata,                  //                                                       .writedata
		output wire [1:0]  video_pixel_DMA_avalon_control_slave_address,                 //                   video_pixel_DMA_avalon_control_slave.address
		output wire        video_pixel_DMA_avalon_control_slave_write,                   //                                                       .write
		output wire        video_pixel_DMA_avalon_control_slave_read,                    //                                                       .read
		input  wire [31:0] video_pixel_DMA_avalon_control_slave_readdata,                //                                                       .readdata
		output wire [31:0] video_pixel_DMA_avalon_control_slave_writedata,               //                                                       .writedata
		output wire [3:0]  video_pixel_DMA_avalon_control_slave_byteenable               //                                                       .byteenable
	);

	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_waitrequest;   // video_pixel_DMA_avalon_control_slave_translator:uav_waitrequest -> Pixel_DMA_Addr_Translation_master_translator:uav_waitrequest
	wire  [31:0] pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdata;      // video_pixel_DMA_avalon_control_slave_translator:uav_readdata -> Pixel_DMA_Addr_Translation_master_translator:uav_readdata
	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_debugaccess;   // Pixel_DMA_Addr_Translation_master_translator:uav_debugaccess -> video_pixel_DMA_avalon_control_slave_translator:uav_debugaccess
	wire   [3:0] pixel_dma_addr_translation_master_translator_avalon_universal_master_0_address;       // Pixel_DMA_Addr_Translation_master_translator:uav_address -> video_pixel_DMA_avalon_control_slave_translator:uav_address
	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_read;          // Pixel_DMA_Addr_Translation_master_translator:uav_read -> video_pixel_DMA_avalon_control_slave_translator:uav_read
	wire   [3:0] pixel_dma_addr_translation_master_translator_avalon_universal_master_0_byteenable;    // Pixel_DMA_Addr_Translation_master_translator:uav_byteenable -> video_pixel_DMA_avalon_control_slave_translator:uav_byteenable
	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdatavalid; // video_pixel_DMA_avalon_control_slave_translator:uav_readdatavalid -> Pixel_DMA_Addr_Translation_master_translator:uav_readdatavalid
	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_lock;          // Pixel_DMA_Addr_Translation_master_translator:uav_lock -> video_pixel_DMA_avalon_control_slave_translator:uav_lock
	wire         pixel_dma_addr_translation_master_translator_avalon_universal_master_0_write;         // Pixel_DMA_Addr_Translation_master_translator:uav_write -> video_pixel_DMA_avalon_control_slave_translator:uav_write
	wire  [31:0] pixel_dma_addr_translation_master_translator_avalon_universal_master_0_writedata;     // Pixel_DMA_Addr_Translation_master_translator:uav_writedata -> video_pixel_DMA_avalon_control_slave_translator:uav_writedata
	wire   [2:0] pixel_dma_addr_translation_master_translator_avalon_universal_master_0_burstcount;    // Pixel_DMA_Addr_Translation_master_translator:uav_burstcount -> video_pixel_DMA_avalon_control_slave_translator:uav_burstcount

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (2),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (4),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.USE_READRESPONSE            (0),
		.USE_WRITERESPONSE           (0),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (0),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) pixel_dma_addr_translation_master_translator (
		.clk                    (Sys_Clk_clk_clk),                                                                      //                       clk.clk
		.reset                  (Pixel_DMA_Addr_Translation_reset_reset_bridge_in_reset_reset),                         //                     reset.reset
		.uav_address            (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount         (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read               (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write              (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest        (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid      (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable         (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata           (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata          (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock               (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess        (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address             (Pixel_DMA_Addr_Translation_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest         (Pixel_DMA_Addr_Translation_master_waitrequest),                                        //                          .waitrequest
		.av_byteenable          (Pixel_DMA_Addr_Translation_master_byteenable),                                         //                          .byteenable
		.av_read                (Pixel_DMA_Addr_Translation_master_read),                                               //                          .read
		.av_readdata            (Pixel_DMA_Addr_Translation_master_readdata),                                           //                          .readdata
		.av_write               (Pixel_DMA_Addr_Translation_master_write),                                              //                          .write
		.av_writedata           (Pixel_DMA_Addr_Translation_master_writedata),                                          //                          .writedata
		.av_burstcount          (1'b1),                                                                                 //               (terminated)
		.av_beginbursttransfer  (1'b0),                                                                                 //               (terminated)
		.av_begintransfer       (1'b0),                                                                                 //               (terminated)
		.av_chipselect          (1'b0),                                                                                 //               (terminated)
		.av_readdatavalid       (),                                                                                     //               (terminated)
		.av_lock                (1'b0),                                                                                 //               (terminated)
		.av_debugaccess         (1'b0),                                                                                 //               (terminated)
		.uav_clken              (),                                                                                     //               (terminated)
		.av_clken               (1'b1),                                                                                 //               (terminated)
		.uav_response           (2'b00),                                                                                //               (terminated)
		.av_response            (),                                                                                     //               (terminated)
		.uav_writeresponsevalid (1'b0),                                                                                 //               (terminated)
		.av_writeresponsevalid  ()                                                                                      //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (2),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (4),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.USE_READRESPONSE               (0),
		.USE_WRITERESPONSE              (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) video_pixel_dma_avalon_control_slave_translator (
		.clk                    (Sys_Clk_clk_clk),                                                                      //                      clk.clk
		.reset                  (Pixel_DMA_Addr_Translation_reset_reset_bridge_in_reset_reset),                         //                    reset.reset
		.uav_address            (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_address),       // avalon_universal_slave_0.address
		.uav_burstcount         (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_burstcount),    //                         .burstcount
		.uav_read               (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_read),          //                         .read
		.uav_write              (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_write),         //                         .write
		.uav_waitrequest        (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid      (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdatavalid), //                         .readdatavalid
		.uav_byteenable         (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_byteenable),    //                         .byteenable
		.uav_readdata           (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_readdata),      //                         .readdata
		.uav_writedata          (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_writedata),     //                         .writedata
		.uav_lock               (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_lock),          //                         .lock
		.uav_debugaccess        (pixel_dma_addr_translation_master_translator_avalon_universal_master_0_debugaccess),   //                         .debugaccess
		.av_address             (video_pixel_DMA_avalon_control_slave_address),                                         //      avalon_anti_slave_0.address
		.av_write               (video_pixel_DMA_avalon_control_slave_write),                                           //                         .write
		.av_read                (video_pixel_DMA_avalon_control_slave_read),                                            //                         .read
		.av_readdata            (video_pixel_DMA_avalon_control_slave_readdata),                                        //                         .readdata
		.av_writedata           (video_pixel_DMA_avalon_control_slave_writedata),                                       //                         .writedata
		.av_byteenable          (video_pixel_DMA_avalon_control_slave_byteenable),                                      //                         .byteenable
		.av_begintransfer       (),                                                                                     //              (terminated)
		.av_beginbursttransfer  (),                                                                                     //              (terminated)
		.av_burstcount          (),                                                                                     //              (terminated)
		.av_readdatavalid       (1'b0),                                                                                 //              (terminated)
		.av_waitrequest         (1'b0),                                                                                 //              (terminated)
		.av_writebyteenable     (),                                                                                     //              (terminated)
		.av_lock                (),                                                                                     //              (terminated)
		.av_chipselect          (),                                                                                     //              (terminated)
		.av_clken               (),                                                                                     //              (terminated)
		.uav_clken              (1'b0),                                                                                 //              (terminated)
		.av_debugaccess         (),                                                                                     //              (terminated)
		.av_outputenable        (),                                                                                     //              (terminated)
		.uav_response           (),                                                                                     //              (terminated)
		.av_response            (2'b00),                                                                                //              (terminated)
		.uav_writeresponsevalid (),                                                                                     //              (terminated)
		.av_writeresponsevalid  (1'b0)                                                                                  //              (terminated)
	);

endmodule
