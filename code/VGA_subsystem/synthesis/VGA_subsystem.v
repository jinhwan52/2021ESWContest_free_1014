// VGA_subsystem.v

// Generated using ACDS version 16.1 196

`timescale 1 ps / 1 ps
module VGA_subsystem (
		input  wire        char_buffer_slave_byteenable,   //   char_buffer_slave.byteenable
		input  wire        char_buffer_slave_chipselect,   //                    .chipselect
		input  wire        char_buffer_slave_read,         //                    .read
		input  wire        char_buffer_slave_write,        //                    .write
		input  wire [7:0]  char_buffer_slave_writedata,    //                    .writedata
		output wire [7:0]  char_buffer_slave_readdata,     //                    .readdata
		output wire        char_buffer_slave_waitrequest,  //                    .waitrequest
		input  wire [12:0] char_buffer_slave_address,      //                    .address
		input  wire        char_control_slave_address,     //  char_control_slave.address
		input  wire [3:0]  char_control_slave_byteenable,  //                    .byteenable
		input  wire        char_control_slave_chipselect,  //                    .chipselect
		input  wire        char_control_slave_read,        //                    .read
		input  wire        char_control_slave_write,       //                    .write
		input  wire [31:0] char_control_slave_writedata,   //                    .writedata
		output wire [31:0] char_control_slave_readdata,    //                    .readdata
		input  wire        pixel_dma_master_readdatavalid, //    pixel_dma_master.readdatavalid
		input  wire        pixel_dma_master_waitrequest,   //                    .waitrequest
		output wire [31:0] pixel_dma_master_address,       //                    .address
		output wire        pixel_dma_master_lock,          //                    .lock
		output wire        pixel_dma_master_read,          //                    .read
		input  wire [15:0] pixel_dma_master_readdata,      //                    .readdata
		input  wire [1:0]  pixel_dma_slave_address,        //     pixel_dma_slave.address
		input  wire [3:0]  pixel_dma_slave_byteenable,     //                    .byteenable
		input  wire        pixel_dma_slave_read,           //                    .read
		input  wire        pixel_dma_slave_write,          //                    .write
		input  wire [31:0] pixel_dma_slave_writedata,      //                    .writedata
		output wire [31:0] pixel_dma_slave_readdata,       //                    .readdata
		input  wire        sys_clk_clk,                    //             sys_clk.clk
		input  wire        sys_reset_reset_n,              //           sys_reset.reset_n
		output wire        vga_out_CLK,                    //             vga_out.CLK
		output wire        vga_out_HS,                     //                    .HS
		output wire        vga_out_VS,                     //                    .VS
		output wire        vga_out_BLANK,                  //                    .BLANK
		output wire        vga_out_SYNC,                   //                    .SYNC
		output wire [7:0]  vga_out_R,                      //                    .R
		output wire [7:0]  vga_out_G,                      //                    .G
		output wire [7:0]  vga_out_B,                      //                    .B
		input  wire        video_pll_ref_reset_reset,      // video_pll_ref_reset.reset
		input  wire        video_ref_clk_clk               //       video_ref_clk.clk
	);

	wire         video_alpha_blender_0_avalon_blended_source_valid;                  // video_alpha_blender_0:output_valid -> video_dual_clock_FIFO:stream_in_valid
	wire  [29:0] video_alpha_blender_0_avalon_blended_source_data;                   // video_alpha_blender_0:output_data -> video_dual_clock_FIFO:stream_in_data
	wire         video_alpha_blender_0_avalon_blended_source_ready;                  // video_dual_clock_FIFO:stream_in_ready -> video_alpha_blender_0:output_ready
	wire         video_alpha_blender_0_avalon_blended_source_startofpacket;          // video_alpha_blender_0:output_startofpacket -> video_dual_clock_FIFO:stream_in_startofpacket
	wire         video_alpha_blender_0_avalon_blended_source_endofpacket;            // video_alpha_blender_0:output_endofpacket -> video_dual_clock_FIFO:stream_in_endofpacket
	wire         video_character_buffer_with_dma_0_avalon_char_source_valid;         // video_character_buffer_with_dma_0:stream_valid -> video_alpha_blender_0:foreground_valid
	wire  [39:0] video_character_buffer_with_dma_0_avalon_char_source_data;          // video_character_buffer_with_dma_0:stream_data -> video_alpha_blender_0:foreground_data
	wire         video_character_buffer_with_dma_0_avalon_char_source_ready;         // video_alpha_blender_0:foreground_ready -> video_character_buffer_with_dma_0:stream_ready
	wire         video_character_buffer_with_dma_0_avalon_char_source_startofpacket; // video_character_buffer_with_dma_0:stream_startofpacket -> video_alpha_blender_0:foreground_startofpacket
	wire         video_character_buffer_with_dma_0_avalon_char_source_endofpacket;   // video_character_buffer_with_dma_0:stream_endofpacket -> video_alpha_blender_0:foreground_endofpacket
	wire         vga_pixel_fifo_avalon_dc_buffer_source_valid;                       // VGA_pixel_FIFO:stream_out_valid -> VGA_pixel_rgb_resampler:stream_in_valid
	wire  [15:0] vga_pixel_fifo_avalon_dc_buffer_source_data;                        // VGA_pixel_FIFO:stream_out_data -> VGA_pixel_rgb_resampler:stream_in_data
	wire         vga_pixel_fifo_avalon_dc_buffer_source_ready;                       // VGA_pixel_rgb_resampler:stream_in_ready -> VGA_pixel_FIFO:stream_out_ready
	wire         vga_pixel_fifo_avalon_dc_buffer_source_startofpacket;               // VGA_pixel_FIFO:stream_out_startofpacket -> VGA_pixel_rgb_resampler:stream_in_startofpacket
	wire         vga_pixel_fifo_avalon_dc_buffer_source_endofpacket;                 // VGA_pixel_FIFO:stream_out_endofpacket -> VGA_pixel_rgb_resampler:stream_in_endofpacket
	wire         video_dual_clock_fifo_avalon_dc_buffer_source_valid;                // video_dual_clock_FIFO:stream_out_valid -> video_vga_controller_0:valid
	wire  [29:0] video_dual_clock_fifo_avalon_dc_buffer_source_data;                 // video_dual_clock_FIFO:stream_out_data -> video_vga_controller_0:data
	wire         video_dual_clock_fifo_avalon_dc_buffer_source_ready;                // video_vga_controller_0:ready -> video_dual_clock_FIFO:stream_out_ready
	wire         video_dual_clock_fifo_avalon_dc_buffer_source_startofpacket;        // video_dual_clock_FIFO:stream_out_startofpacket -> video_vga_controller_0:startofpacket
	wire         video_dual_clock_fifo_avalon_dc_buffer_source_endofpacket;          // video_dual_clock_FIFO:stream_out_endofpacket -> video_vga_controller_0:endofpacket
	wire         video_pixel_dma_avalon_pixel_source_valid;                          // video_pixel_DMA:stream_valid -> VGA_pixel_FIFO:stream_in_valid
	wire  [15:0] video_pixel_dma_avalon_pixel_source_data;                           // video_pixel_DMA:stream_data -> VGA_pixel_FIFO:stream_in_data
	wire         video_pixel_dma_avalon_pixel_source_ready;                          // VGA_pixel_FIFO:stream_in_ready -> video_pixel_DMA:stream_ready
	wire         video_pixel_dma_avalon_pixel_source_startofpacket;                  // video_pixel_DMA:stream_startofpacket -> VGA_pixel_FIFO:stream_in_startofpacket
	wire         video_pixel_dma_avalon_pixel_source_endofpacket;                    // video_pixel_DMA:stream_endofpacket -> VGA_pixel_FIFO:stream_in_endofpacket
	wire         vga_pixel_rgb_resampler_avalon_rgb_source_valid;                    // VGA_pixel_rgb_resampler:stream_out_valid -> video_alpha_blender_0:background_valid
	wire  [29:0] vga_pixel_rgb_resampler_avalon_rgb_source_data;                     // VGA_pixel_rgb_resampler:stream_out_data -> video_alpha_blender_0:background_data
	wire         vga_pixel_rgb_resampler_avalon_rgb_source_ready;                    // video_alpha_blender_0:background_ready -> VGA_pixel_rgb_resampler:stream_out_ready
	wire         vga_pixel_rgb_resampler_avalon_rgb_source_startofpacket;            // VGA_pixel_rgb_resampler:stream_out_startofpacket -> video_alpha_blender_0:background_startofpacket
	wire         vga_pixel_rgb_resampler_avalon_rgb_source_endofpacket;              // VGA_pixel_rgb_resampler:stream_out_endofpacket -> video_alpha_blender_0:background_endofpacket
	wire         vga_pll_vga_clk_clk;                                                // VGA_PLL:vga_clk_clk -> [rst_controller_001:clk, video_dual_clock_FIFO:clk_stream_out, video_vga_controller_0:clk]
	wire         rst_controller_reset_out_reset;                                     // rst_controller:reset_out -> [VGA_pixel_FIFO:reset_stream_in, VGA_pixel_FIFO:reset_stream_out, VGA_pixel_rgb_resampler:reset, video_alpha_blender_0:reset, video_character_buffer_with_dma_0:reset, video_dual_clock_FIFO:reset_stream_in, video_pixel_DMA:reset]
	wire         rst_controller_001_reset_out_reset;                                 // rst_controller_001:reset_out -> [video_dual_clock_FIFO:reset_stream_out, video_vga_controller_0:reset]
	wire         vga_pll_reset_source_reset;                                         // VGA_PLL:reset_source_reset -> rst_controller_001:reset_in0

	VGA_subsystem_VGA_PLL vga_pll (
		.ref_clk_clk        (video_ref_clk_clk),          //      ref_clk.clk
		.ref_reset_reset    (video_pll_ref_reset_reset),  //    ref_reset.reset
		.vga_clk_clk        (vga_pll_vga_clk_clk),        //      vga_clk.clk
		.reset_source_reset (vga_pll_reset_source_reset)  // reset_source.reset
	);

	VGA_subsystem_VGA_pixel_FIFO vga_pixel_fifo (
		.clk_stream_in            (sys_clk_clk),                                          //         clock_stream_in.clk
		.reset_stream_in          (rst_controller_reset_out_reset),                       //         reset_stream_in.reset
		.clk_stream_out           (sys_clk_clk),                                          //        clock_stream_out.clk
		.reset_stream_out         (rst_controller_reset_out_reset),                       //        reset_stream_out.reset
		.stream_in_ready          (video_pixel_dma_avalon_pixel_source_ready),            //   avalon_dc_buffer_sink.ready
		.stream_in_startofpacket  (video_pixel_dma_avalon_pixel_source_startofpacket),    //                        .startofpacket
		.stream_in_endofpacket    (video_pixel_dma_avalon_pixel_source_endofpacket),      //                        .endofpacket
		.stream_in_valid          (video_pixel_dma_avalon_pixel_source_valid),            //                        .valid
		.stream_in_data           (video_pixel_dma_avalon_pixel_source_data),             //                        .data
		.stream_out_ready         (vga_pixel_fifo_avalon_dc_buffer_source_ready),         // avalon_dc_buffer_source.ready
		.stream_out_startofpacket (vga_pixel_fifo_avalon_dc_buffer_source_startofpacket), //                        .startofpacket
		.stream_out_endofpacket   (vga_pixel_fifo_avalon_dc_buffer_source_endofpacket),   //                        .endofpacket
		.stream_out_valid         (vga_pixel_fifo_avalon_dc_buffer_source_valid),         //                        .valid
		.stream_out_data          (vga_pixel_fifo_avalon_dc_buffer_source_data)           //                        .data
	);

	VGA_subsystem_VGA_pixel_rgb_resampler vga_pixel_rgb_resampler (
		.clk                      (sys_clk_clk),                                             //               clk.clk
		.reset                    (rst_controller_reset_out_reset),                          //             reset.reset
		.stream_in_startofpacket  (vga_pixel_fifo_avalon_dc_buffer_source_startofpacket),    //   avalon_rgb_sink.startofpacket
		.stream_in_endofpacket    (vga_pixel_fifo_avalon_dc_buffer_source_endofpacket),      //                  .endofpacket
		.stream_in_valid          (vga_pixel_fifo_avalon_dc_buffer_source_valid),            //                  .valid
		.stream_in_ready          (vga_pixel_fifo_avalon_dc_buffer_source_ready),            //                  .ready
		.stream_in_data           (vga_pixel_fifo_avalon_dc_buffer_source_data),             //                  .data
		.stream_out_ready         (vga_pixel_rgb_resampler_avalon_rgb_source_ready),         // avalon_rgb_source.ready
		.stream_out_startofpacket (vga_pixel_rgb_resampler_avalon_rgb_source_startofpacket), //                  .startofpacket
		.stream_out_endofpacket   (vga_pixel_rgb_resampler_avalon_rgb_source_endofpacket),   //                  .endofpacket
		.stream_out_valid         (vga_pixel_rgb_resampler_avalon_rgb_source_valid),         //                  .valid
		.stream_out_data          (vga_pixel_rgb_resampler_avalon_rgb_source_data)           //                  .data
	);

	VGA_subsystem_video_alpha_blender_0 video_alpha_blender_0 (
		.clk                      (sys_clk_clk),                                                        //                    clk.clk
		.reset                    (rst_controller_reset_out_reset),                                     //                  reset.reset
		.foreground_data          (video_character_buffer_with_dma_0_avalon_char_source_data),          // avalon_foreground_sink.data
		.foreground_startofpacket (video_character_buffer_with_dma_0_avalon_char_source_startofpacket), //                       .startofpacket
		.foreground_endofpacket   (video_character_buffer_with_dma_0_avalon_char_source_endofpacket),   //                       .endofpacket
		.foreground_valid         (video_character_buffer_with_dma_0_avalon_char_source_valid),         //                       .valid
		.foreground_ready         (video_character_buffer_with_dma_0_avalon_char_source_ready),         //                       .ready
		.background_data          (vga_pixel_rgb_resampler_avalon_rgb_source_data),                     // avalon_background_sink.data
		.background_startofpacket (vga_pixel_rgb_resampler_avalon_rgb_source_startofpacket),            //                       .startofpacket
		.background_endofpacket   (vga_pixel_rgb_resampler_avalon_rgb_source_endofpacket),              //                       .endofpacket
		.background_valid         (vga_pixel_rgb_resampler_avalon_rgb_source_valid),                    //                       .valid
		.background_ready         (vga_pixel_rgb_resampler_avalon_rgb_source_ready),                    //                       .ready
		.output_ready             (video_alpha_blender_0_avalon_blended_source_ready),                  //  avalon_blended_source.ready
		.output_data              (video_alpha_blender_0_avalon_blended_source_data),                   //                       .data
		.output_startofpacket     (video_alpha_blender_0_avalon_blended_source_startofpacket),          //                       .startofpacket
		.output_endofpacket       (video_alpha_blender_0_avalon_blended_source_endofpacket),            //                       .endofpacket
		.output_valid             (video_alpha_blender_0_avalon_blended_source_valid)                   //                       .valid
	);

	VGA_subsystem_video_character_buffer_with_dma_0 video_character_buffer_with_dma_0 (
		.clk                  (sys_clk_clk),                                                        //                       clk.clk
		.reset                (rst_controller_reset_out_reset),                                     //                     reset.reset
		.ctrl_address         (char_control_slave_address),                                         // avalon_char_control_slave.address
		.ctrl_byteenable      (char_control_slave_byteenable),                                      //                          .byteenable
		.ctrl_chipselect      (char_control_slave_chipselect),                                      //                          .chipselect
		.ctrl_read            (char_control_slave_read),                                            //                          .read
		.ctrl_write           (char_control_slave_write),                                           //                          .write
		.ctrl_writedata       (char_control_slave_writedata),                                       //                          .writedata
		.ctrl_readdata        (char_control_slave_readdata),                                        //                          .readdata
		.buf_byteenable       (char_buffer_slave_byteenable),                                       //  avalon_char_buffer_slave.byteenable
		.buf_chipselect       (char_buffer_slave_chipselect),                                       //                          .chipselect
		.buf_read             (char_buffer_slave_read),                                             //                          .read
		.buf_write            (char_buffer_slave_write),                                            //                          .write
		.buf_writedata        (char_buffer_slave_writedata),                                        //                          .writedata
		.buf_readdata         (char_buffer_slave_readdata),                                         //                          .readdata
		.buf_waitrequest      (char_buffer_slave_waitrequest),                                      //                          .waitrequest
		.buf_address          (char_buffer_slave_address),                                          //                          .address
		.stream_ready         (video_character_buffer_with_dma_0_avalon_char_source_ready),         //        avalon_char_source.ready
		.stream_startofpacket (video_character_buffer_with_dma_0_avalon_char_source_startofpacket), //                          .startofpacket
		.stream_endofpacket   (video_character_buffer_with_dma_0_avalon_char_source_endofpacket),   //                          .endofpacket
		.stream_valid         (video_character_buffer_with_dma_0_avalon_char_source_valid),         //                          .valid
		.stream_data          (video_character_buffer_with_dma_0_avalon_char_source_data)           //                          .data
	);

	VGA_subsystem_video_dual_clock_FIFO video_dual_clock_fifo (
		.clk_stream_in            (sys_clk_clk),                                                 //         clock_stream_in.clk
		.reset_stream_in          (rst_controller_reset_out_reset),                              //         reset_stream_in.reset
		.clk_stream_out           (vga_pll_vga_clk_clk),                                         //        clock_stream_out.clk
		.reset_stream_out         (rst_controller_001_reset_out_reset),                          //        reset_stream_out.reset
		.stream_in_ready          (video_alpha_blender_0_avalon_blended_source_ready),           //   avalon_dc_buffer_sink.ready
		.stream_in_startofpacket  (video_alpha_blender_0_avalon_blended_source_startofpacket),   //                        .startofpacket
		.stream_in_endofpacket    (video_alpha_blender_0_avalon_blended_source_endofpacket),     //                        .endofpacket
		.stream_in_valid          (video_alpha_blender_0_avalon_blended_source_valid),           //                        .valid
		.stream_in_data           (video_alpha_blender_0_avalon_blended_source_data),            //                        .data
		.stream_out_ready         (video_dual_clock_fifo_avalon_dc_buffer_source_ready),         // avalon_dc_buffer_source.ready
		.stream_out_startofpacket (video_dual_clock_fifo_avalon_dc_buffer_source_startofpacket), //                        .startofpacket
		.stream_out_endofpacket   (video_dual_clock_fifo_avalon_dc_buffer_source_endofpacket),   //                        .endofpacket
		.stream_out_valid         (video_dual_clock_fifo_avalon_dc_buffer_source_valid),         //                        .valid
		.stream_out_data          (video_dual_clock_fifo_avalon_dc_buffer_source_data)           //                        .data
	);

	VGA_subsystem_video_pixel_DMA video_pixel_dma (
		.clk                  (sys_clk_clk),                                       //                     clk.clk
		.reset                (rst_controller_reset_out_reset),                    //                   reset.reset
		.master_readdatavalid (pixel_dma_master_readdatavalid),                    // avalon_pixel_dma_master.readdatavalid
		.master_waitrequest   (pixel_dma_master_waitrequest),                      //                        .waitrequest
		.master_address       (pixel_dma_master_address),                          //                        .address
		.master_arbiterlock   (pixel_dma_master_lock),                             //                        .lock
		.master_read          (pixel_dma_master_read),                             //                        .read
		.master_readdata      (pixel_dma_master_readdata),                         //                        .readdata
		.slave_address        (pixel_dma_slave_address),                           //    avalon_control_slave.address
		.slave_byteenable     (pixel_dma_slave_byteenable),                        //                        .byteenable
		.slave_read           (pixel_dma_slave_read),                              //                        .read
		.slave_write          (pixel_dma_slave_write),                             //                        .write
		.slave_writedata      (pixel_dma_slave_writedata),                         //                        .writedata
		.slave_readdata       (pixel_dma_slave_readdata),                          //                        .readdata
		.stream_ready         (video_pixel_dma_avalon_pixel_source_ready),         //     avalon_pixel_source.ready
		.stream_startofpacket (video_pixel_dma_avalon_pixel_source_startofpacket), //                        .startofpacket
		.stream_endofpacket   (video_pixel_dma_avalon_pixel_source_endofpacket),   //                        .endofpacket
		.stream_valid         (video_pixel_dma_avalon_pixel_source_valid),         //                        .valid
		.stream_data          (video_pixel_dma_avalon_pixel_source_data)           //                        .data
	);

	VGA_subsystem_video_vga_controller_0 video_vga_controller_0 (
		.clk           (vga_pll_vga_clk_clk),                                         //                clk.clk
		.reset         (rst_controller_001_reset_out_reset),                          //              reset.reset
		.data          (video_dual_clock_fifo_avalon_dc_buffer_source_data),          //    avalon_vga_sink.data
		.startofpacket (video_dual_clock_fifo_avalon_dc_buffer_source_startofpacket), //                   .startofpacket
		.endofpacket   (video_dual_clock_fifo_avalon_dc_buffer_source_endofpacket),   //                   .endofpacket
		.valid         (video_dual_clock_fifo_avalon_dc_buffer_source_valid),         //                   .valid
		.ready         (video_dual_clock_fifo_avalon_dc_buffer_source_ready),         //                   .ready
		.VGA_CLK       (vga_out_CLK),                                                 // external_interface.export
		.VGA_HS        (vga_out_HS),                                                  //                   .export
		.VGA_VS        (vga_out_VS),                                                  //                   .export
		.VGA_BLANK     (vga_out_BLANK),                                               //                   .export
		.VGA_SYNC      (vga_out_SYNC),                                                //                   .export
		.VGA_R         (vga_out_R),                                                   //                   .export
		.VGA_G         (vga_out_G),                                                   //                   .export
		.VGA_B         (vga_out_B)                                                    //                   .export
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~sys_reset_reset_n),             // reset_in0.reset
		.clk            (sys_clk_clk),                    //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller_001 (
		.reset_in0      (vga_pll_reset_source_reset),         // reset_in0.reset
		.clk            (vga_pll_vga_clk_clk),                //       clk.clk
		.reset_out      (rst_controller_001_reset_out_reset), // reset_out.reset
		.reset_req      (),                                   // (terminated)
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
