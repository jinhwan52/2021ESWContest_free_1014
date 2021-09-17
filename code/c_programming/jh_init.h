#ifndef __JHinit_H_
#define __JHinit_H_

#define HW_REGS_BASE ( ALT_STM_OFST )	// ALT_STM_OFST = 0xfc000000
#define HW_REGS_SPAN ( 0x04000000 )		// 64 MB
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )
// The register connecting to h2f_axi_master must start at 0xC0000000 (SDRAM_BASE)  
#define FPGA_CHAR_BASE       ( 0xC9000000 )
#define FPGA_CHAR_END        ( 0xC9001FFF )
#define FPGA_CHAR_SPAN       ( 0x00002000 )
#define SDRAM_BASE           ( 0xC0000000 )
#define SDRAM_END            ( 0xC3FFFFFF )
#define SDRAM_SPAN			 ( 0x04000000 )
#define ONCHIP_RAM1_BASE	 ( 0xC8000000 )	//0xC8000000~C80000ff - On chip ram 1, 0xC8000100~C80001ff - On chip ram 2,
#define ONCHIP_RAM1_SPAN	 ( 0x200 )		// 0x100 = 256
#define ONCHIP_RAM1_END      ( 0xC80001ff )
#define FIFO_HPS_TO_FPGA_IN_BASE  ( 0xC4000000 )
#define FIFO_HPS_TO_FPGA_IN_SPAN  ( 0x1000 )
#define FIFO_HPS_TO_FPGA_IN_END   ( 0xC4000fff )

#define USER_IO_DIR     (0x01000000)
#define BIT_LED         (0x01000000)
#define BUTTON_MASK     (0x02000000)

// Virtual to real address pointers (h2f_lw_axi_master)
void* virtual_base;
volatile alt_u32* number32_ptr = NULL;
volatile alt_u32* HW_reset_ptr = NULL;
volatile alt_u32* SW_reg_ptr = NULL;
volatile alt_u32* temper_ptr = NULL;
volatile alt_u32* temper_ptr2 = NULL;
volatile alt_u32* pwforward_ptr = NULL;
volatile alt_u32* pwreversed_ptr = NULL;
volatile alt_u32* rf_on_off = NULL;
volatile alt_u32* command_ptr = NULL;
volatile alt_u32* target_temperature = NULL;
volatile alt_u32* select_thermcouple = NULL;
volatile alt_u32* electrode_voltage_ptr = NULL;
volatile alt_u32* iteration_number_ptr = NULL;
volatile alt_u32* finishing_fdtd_ptr = NULL;
volatile alt_u32* module_state_ptr = NULL;
volatile alt_u32* power_unlock = NULL;
volatile alt_u32* FIFO_write_status_ptr = NULL;
volatile alt_u32* FIFO_read_status_ptr = NULL;


// Virtual to real address pointers (h2f_axi_master)
void* vga_char_virtual_base;
volatile alt_u32* vga_char_ptr = NULL;
void* vga_pixel_virtual_base;
volatile alt_u32* vga_pixel_ptr = NULL;
void* onchip_ram1_base;
volatile alt_u32* onchip_ram1_ptr = NULL;
void* h2p_virtual_base;
volatile alt_u32* FIFO_write_ptr = NULL;
volatile alt_u32* FIFO_read_ptr = NULL;

volatile int tick=0;	// for HPS_timer interrupt

// Mutex for lock = pixel, char
pthread_mutex_t vga_pixel_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t vga_char_lock = PTHREAD_MUTEX_INITIALIZER;

// /dev/mem file id 
int fd;

int __init() {

	//======================================================= 
	//		Get FPGA addresses using low-level functions
	//=======================================================
	// Open /dev/mem	
	if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1) {
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return(1);
	}

	// Get virtual address that maps to physical	
	virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);
	if (virtual_base == MAP_FAILED) {
		printf("ERROR: mmap() failed...1\n");
		close(fd);
		return(1);
	}
	// HW_reset
	HW_reset_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + HW_RESET_BASE) & (alt_u32)(HW_REGS_MASK)); // ALT_LWFPGASLVS_OFST = 0xff200000
	// SW address 
	SW_reg_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + SW_BASE) & (alt_u32)(HW_REGS_MASK)); 
	// nuber32 register address 
	number32_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + NUMBER32_BASE) & (alt_u32)(HW_REGS_MASK)); 
	// Temperature1 address 
	temper_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + O_TEMPERATURE_BASE) & (alt_u32)(HW_REGS_MASK));
	// Temperature2 address 
	temper_ptr2 = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + O_TEMPERATURE2_BASE) & (alt_u32)(HW_REGS_MASK));
	// Forward power address 
	pwforward_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + O_PW_FORWARD_BASE) & (alt_u32)(HW_REGS_MASK));
	// Reversed power address 
	pwreversed_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + O_PW_REVERSED_BASE) & (alt_u32)(HW_REGS_MASK));
	// RF on and off
	rf_on_off = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + RF_ON_OFF_BASE) & (alt_u32)(HW_REGS_MASK));
	// Command to read or write data to PE
	command_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + COMMAND_FROM_HPS_BASE) & (alt_u32)(HW_REGS_MASK));
	// Target temperature value
	target_temperature = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + SP_BASE) & (alt_u32)(HW_REGS_MASK));
	// Select thermocouple. 0: thermocouple1, 1: thermocouple2
	select_thermcouple = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + THERMOCOUPLES_SEL_BASE) & (alt_u32)(HW_REGS_MASK));
	// Electrode voltage
	electrode_voltage_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + ELECTRODE_VOLTAGE_BASE) & (alt_u32)(HW_REGS_MASK));
	// iteration_number
	iteration_number_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + ITERATION_NUMBER_BASE) & (alt_u32)(HW_REGS_MASK));
	// fpga FDTD finishing flag
	finishing_fdtd_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + FINISH_FDTD_BASE) & (alt_u32)(HW_REGS_MASK));
	// state of FPGA modules
	module_state_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + MODULE_CSR_BASE) & (alt_u32)(HW_REGS_MASK));
	// Unlock the power limit
	power_unlock = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + POWER_UNLOCK_BASE) & (alt_u32)(HW_REGS_MASK));
	// FIFO status registor of hps to fpga
	FIFO_write_status_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + FIFO_HPS_TO_FPGA_IN_CSR_BASE) & (alt_u32)(HW_REGS_MASK));
	// FIFO status registor of fpga to hps
	FIFO_read_status_ptr = virtual_base + ((alt_u32)(ALT_LWFPGASLVS_OFST + FIFO_FPGA_TO_HPS_OUT_CSR_BASE) & (alt_u32)(HW_REGS_MASK));
	

	// Get VGA char addr
	vga_char_virtual_base = mmap(NULL, FPGA_CHAR_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FPGA_CHAR_BASE);
	if (vga_char_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap2() failed...2\n");
		close(fd);
		return(1);
	}
	vga_char_ptr = (unsigned int*)(vga_char_virtual_base);

	// Get VGA pixel addr 
	vga_pixel_virtual_base = mmap(NULL, SDRAM_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, SDRAM_BASE);
	if (vga_pixel_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap3() failed...3\n");
		close(fd);
		return(1);
	}
	vga_pixel_ptr = (unsigned int*)(vga_pixel_virtual_base);

	// Get Onchip ram1 addr (for the forward voltage)
	onchip_ram1_base = mmap(NULL, ONCHIP_RAM1_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, ONCHIP_RAM1_BASE);
	if (onchip_ram1_base == MAP_FAILED) {
		printf("ERROR: mmap3() failed...3\n");
		close(fd);
		return(1);
	}
	onchip_ram1_ptr = (unsigned int*)(onchip_ram1_base);
	
	// FIFO write addr 
	h2p_virtual_base = mmap(NULL, FIFO_HPS_TO_FPGA_IN_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, FIFO_HPS_TO_FPGA_IN_BASE);

	if (h2p_virtual_base == MAP_FAILED) {
		printf("ERROR: mmap3() failed...\n");
		close(fd);
		return(1);
	}
	// Get the address that maps to the FIFO read/write ports
	FIFO_write_ptr = (unsigned int*)(h2p_virtual_base);
	FIFO_read_ptr = (unsigned int*)(h2p_virtual_base + 0x10); //0x10

	// Set the direction of the HPS GPIO1: LED output. 
	alt_setbits_word((virtual_base + ((uint32_t)(ALT_GPIO1_SWPORTA_DDR_ADDR) & (uint32_t)(HW_REGS_MASK))), USER_IO_DIR);
	// Off the LED
	alt_clrbits_word((virtual_base + ((uint32_t)(ALT_GPIO1_SWPORTA_DR_ADDR) & (uint32_t)(HW_REGS_MASK))), BIT_LED);

	// ===========================Initialize display ==============================
	// 1. Display text on the monitor
	// 2. Clear the screen	
	// 3. Set the interrupt mask
	// 4. Enable the timer by writing a 1 to the timer1 enable bit
	//=============================================================================
	//Display text on the monitor
	char clear_text[80] = "                                            ";
	VGA_text(2, 6, clear_text);

	char text_top_row[40] = "POSTECH, Jinhwan Baik";
	VGA_text(2, 2, text_top_row);			// 80 characters by 60 lines, characters need 2 rooms.

	// Clear the screen	
	VGA_box(0, 0, 639, 479, 0x0000);	// 640 x 480 screen

	// Colorbar
	int start_x, start_y, intval_x, intval_y;
	start_x = 40; start_y = 105;
	intval_x = 20; intval_y = 20;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar0); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar1); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar2); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar3); start_x = start_x + intval_x; 
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar4); start_x = start_x + intval_x; 
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar5); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar6); start_x = start_x + intval_x; 
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar7); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar8); start_x = start_x + intval_x;
	VGA_box(start_x, start_y, start_x + intval_x, start_y + intval_y, colarbar9); start_x = start_x + intval_x;
	
	VGA_text(4, 16, "37C");
	VGA_text(29, 16, "60C");

	// Message
	VGA_text(5, 6, "Temp. =       ");
	VGA_text(18, 6, "[C]");
	VGA_text(5, 7, "Power =       ");
	VGA_text(18, 7, "[W]");
	VGA_text(5, 8, "Load  =       ");
	VGA_text(18, 8, "[Ohm]");
	VGA_text(5, 9, "CEM43 =       ");
	VGA_text(18, 9, "[sec]");
	VGA_text(5, 10, "Cond. =      ");
	VGA_text(18, 10, "[mS/m]");

	// Temperature box xy-axis
	VGA_Hline(328, 400, 600, white);
	VGA_Vline(328, 400, 246, white);
	VGA_text(54, 53, "Time [sec]");
	VGA_text(38, 30, "[C]");
	VGA_text(39, 49, "15");
	VGA_text(39, 46, "25");
	VGA_text(39, 43, "35");
	VGA_text(39, 40, "45");
	VGA_text(39, 37, "55");
	VGA_text(39, 34, "65");

	// CEM43
	VGA_Hline(292, 100, 322, white);
	VGA_Vline(292, 100, 200, white);
	VGA_Hline(292, 200, 322, white);
	VGA_Vline(322, 100, 200, white);
	VGA_text(36, 26, "CEM43");

	// Transmitted watt box xy-axis
	VGA_Hline(336, 100, 366, white);
	VGA_Vline(336, 100, 200, white);
	VGA_Hline(336, 200, 366, white);
	VGA_Vline(366, 100, 200, white);
	VGA_text(42, 26, "ZERO");

	// Impedance
	VGA_Hline(376, 100, 406, white);
	VGA_Vline(376, 100, 200, white);
	VGA_Hline(376, 200, 406, white);
	VGA_Vline(406, 100, 200, white);
	VGA_text(47, 26, "OPEN");

	

	///////////////////////////////
	//		Plot Box icons
	//////////////////////////////
	// Box for unlock ->  532 < x < 604, 200 < y < 220
	int text_x, text_y; // coordinate of a text
	int box_x, box_y;
	text_x = 67;	 
	text_y = 24;	 
	box_x = 8 * text_x - 4;		// 67 * 8 - 4 = 532
	box_y = 8 * text_y - 8;		// 24 * 8 - 8 = 184
	VGA_Hline(box_x, box_y, box_x + 72, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 72, white);
	VGA_Vline(box_x + 72, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, " UNLOCK");

	// Box for 45C -> 412 < x < 444, 152 < y < 172
	text_x = 52;
	text_y = 20;
	box_x = 8 * text_x - 4;		// 52 * 8 - 4 = 412
	box_y = 8 * text_y - 8;		// 20 * 8 - 8 = 152
	VGA_Hline(box_x, box_y, box_x + 32, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 32, white);
	VGA_Vline(box_x + 32, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, "40C");

	// Box for 45C -> 452 < x < 484, 152 < y < 172
	text_x = 57;  
	text_y = 20;	 
	box_x = 8 * text_x - 4;		// 57 * 8 - 4 = 452
	box_y = 8 * text_y - 8;		// 20 * 8 - 8 = 152
	VGA_Hline(box_x, box_y, box_x + 32, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 32, white);
	VGA_Vline(box_x + 32, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, "45C");

	// Box for 50C -> 492 < x < 524, 152 < y < 172
	text_x = 62;	
	text_y = 20;	 
	box_x = 8 * text_x - 4;		// 62 * 8 - 4 = 492
	box_y = 8 * text_y - 8;		// 20 * 8 - 8 = 152
	VGA_Hline(box_x, box_y, box_x + 32, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 32, white);
	VGA_Vline(box_x + 32, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, "50C");
	
	// Box for 55C -> 532 < x < 564, 152 < y < 172
	text_x = 67;	 
	text_y = 20;	 
	box_x = 8 * text_x - 4;		// 67 * 8 - 4 = 532
	box_y = 8 * text_y - 8;		// 20 * 8 - 8 = 152
	VGA_Hline(box_x, box_y, box_x + 32, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 32, white);
	VGA_Vline(box_x + 32, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, "55C");

	// Box for 60C -> 572 < x < 604, 152 < y < 172
	text_x = 72;	 
	text_y = 20;	 
	box_x = 8 * text_x - 4;		// 72 * 8 - 4 = 572
	box_y = 8 * text_y - 8;		// 20 * 8 - 8 = 152
	VGA_Hline(box_x, box_y, box_x + 32, white);
	VGA_Vline(box_x, box_y, box_y + 20, white);
	VGA_Hline(box_x, box_y + 20, box_x + 32, white);
	VGA_Vline(box_x + 32, box_y, box_y + 20, white);
	VGA_text(text_x, text_y, "60C");

	// Box for SAVE -> 532 < x < 604, 100 < y < 128
	text_x = 67;	 
	text_y = 14;	 
	box_x = 8 * text_x - 4;		// 67 * 8 - 4 = 532
	box_y = 8 * text_y - 12;	// 14 * 8 - 12 = 100
	VGA_Hline(box_x, box_y, box_x + 72, white);
	VGA_Vline(box_x, box_y, box_y + 28, white);
	VGA_Hline(box_x, box_y + 28, box_x + 72, white);
	VGA_Vline(box_x + 72, box_y, box_y + 28, white);
	VGA_text(text_x, text_y, "  SAVE ");

	// Box for file number -> 500 < x < 524, 100 < y < 128
	text_x = 63;	 
	text_y = 14;	 
	box_x = 8 * text_x - 4;		// 63 * 8  - 4 = 500
	box_y = 8 * text_y - 12;	// 14 * 8 - 12 = 100
	VGA_Hline(box_x, box_y, box_x + 24, white);
	VGA_Vline(box_x, box_y, box_y + 28, white);
	VGA_Hline(box_x, box_y + 28, box_x + 24, white);
	VGA_Vline(box_x + 24, box_y, box_y + 28, white);
	VGA_text(text_x, text_y, "00");

	// up -> 470 < x < 490, 102 < y < 110
	VGA_box(478, 102, 482, 104, white);
	VGA_box(475, 104, 485, 106, white);
	VGA_box(473, 106, 487, 108, white);
	VGA_box(470, 108, 490, 110, white);

	// down -> 470 < x < 490, 118 < y < 126
	VGA_box(470, 118, 490, 120, white);
	VGA_box(473, 120, 487, 122, white);
	VGA_box(475, 122, 485, 124, white);
	VGA_box(478, 124, 482, 126, white);

	// Box for Reset -> 572 < x < 594, 24 < y < 60
	text_x = 72;
	text_y = 5;
	box_x = 8 * text_x - 4;		// 72 * 8 - 4 = 572
	box_y = 8 * text_y - 16;	// 5 * 8 - 16 = 24
	VGA_Hline(box_x, box_y, box_x + 22, white);
	VGA_Vline(box_x, box_y, box_y + 36, white);
	VGA_Hline(box_x, box_y + 36, box_x + 22, white);
	VGA_Vline(box_x + 22, box_y, box_y + 36, white);
	VGA_text(text_x, text_y, "HW");
	VGA_box(573, 25, 593, 59, purple);

	// Box for Stop -> 500 < x < 556, 24 < y < 60
	text_x = 63;	 
	text_y = 5;		 
	box_x = 8 * text_x - 4;		// 63 * 8 - 4 = 500
	box_y = 8 * text_y - 16;	// 5 * 8 - 16 = 24
	VGA_Hline(box_x, box_y, box_x + 56, white);
	VGA_Vline(box_x, box_y, box_y + 36, white);
	VGA_Hline(box_x, box_y + 36, box_x + 56, white);
	VGA_Vline(box_x + 56, box_y, box_y + 36, white);
	VGA_text(text_x, text_y, " STOP ");
	VGA_box(501, 25, 555, 59, blue);

	// Box for Start -> 420 < x < 484, 24 < y < 60
	text_x = 53;	 
	text_y = 5;		 
	box_x = 8 * text_x - 4;		// 53 * 8 - 4 = 420
	box_y = 8 * text_y - 16;	// 5 * 8 - 16 = 24
	VGA_Hline(box_x, box_y, box_x + 64, white);
	VGA_Vline(box_x, box_y, box_y + 36, white);
	VGA_Hline(box_x, box_y + 36, box_x + 64, white);
	VGA_Vline(box_x + 64, box_y, box_y + 36, white);
	VGA_text(text_x, text_y, " START ");
	VGA_box(421, 25, 483, 59, red);

	// Box for Tune_c -> 300 < x < 324, 28 < y < 56
	text_x = 38;
	text_y = 5;
	box_x = 8 * text_x - 4;		// 38 * 8  - 4 = 300
	box_y = 8 * text_y - 12;	// 5 * 8 - 12 = 28
	VGA_Hline(box_x, box_y, box_x + 24, white);
	VGA_Vline(box_x, box_y, box_y + 28, white);
	VGA_Hline(box_x, box_y + 28, box_x + 24, white);
	VGA_Vline(box_x + 24, box_y, box_y + 28, white);
	VGA_text(text_x, text_y, "01");
	VGA_text(text_x - 4, text_y - 3, "Tune_c");

	// up -> 270 < x < 290, 30 < y < 38
	VGA_box(278, 30, 282, 32, white);
	VGA_box(275, 32, 285, 34, white);
	VGA_box(273, 34, 287, 36, white);
	VGA_box(270, 36, 290, 38, white);

	// down -> 270 < x < 290, 46 < y < 54
	VGA_box(270, 46, 290, 48, white);
	VGA_box(273, 48, 287, 50, white);
	VGA_box(275, 50, 285, 52, white);
	VGA_box(278, 52, 282, 54, white);

	// Box for Tune_f -> 380 < x < 404, 28 < y < 56
	text_x = 48;
	text_y = 5;
	box_x = 8 * text_x - 4;		// 48 * 8  - 4 = 380
	box_y = 8 * text_y - 12;	// 5 * 8 - 12 = 28
	VGA_Hline(box_x, box_y, box_x + 24, white);
	VGA_Vline(box_x, box_y, box_y + 28, white);
	VGA_Hline(box_x, box_y + 28, box_x + 24, white);
	VGA_Vline(box_x + 24, box_y, box_y + 28, white);
	VGA_text(text_x, text_y, "01");
	VGA_text(text_x - 4, text_y - 3, "Tune_f");

	// up -> 349 < x < 362, 30 < y < 38
	VGA_box(358, 30, 362, 32, white);
	VGA_box(355, 32, 365, 34, white);
	VGA_box(352, 34, 367, 36, white);
	VGA_box(349, 36, 370, 38, white);

	// down -> 349 < x < 362, 46 < y < 54
	VGA_box(349, 46, 370, 48, white);
	VGA_box(352, 48, 367, 50, white);
	VGA_box(355, 50, 365, 52, white);
	VGA_box(358, 52, 362, 54, white);

	//////////////////////////////
	//		Default setting 
	//////////////////////////////
	// Target electrode temperature is 40.0 C.
	*target_temperature = 400;				
	VGA_box(413, 153, 443, 171, Check);

	// Plot heat distribution
	int row, col, xc, yc, rsqr;
	short pixel_color;
	for (yc = -127; yc <= 127; yc++) {
		for (xc = -127; xc <= 127; xc++)
		{
			col = xc;
			row = yc;
			rsqr = col * col + row * row;
			if (rsqr <= 16256) pixel_color = colarbar0;
			else pixel_color = 0;

			col = col + 160;
			row = row + 300;
			VGA_PIXEL(col, row, pixel_color);
		}
	}

	return (0);
}

#endif // jh_init
