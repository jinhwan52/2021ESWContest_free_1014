
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>		// Header for file open
#include <unistd.h>		// Header for file read
#include <sys/mman.h>	// Header for memory mapping
#include <sys/ipc.h>	// Header for messege queue & shared memory & semaphore
#include <sys/shm.h>	// Header for shared memory
#include <sys/time.h> 
#include <pthread.h>
#include <semaphore.h>
#include "hwlib.h"			// Header for Intel FPGA
#include "socal/socal.h"	// Header for Intel FPGA
#include "socal/hps.h"		// Header for Intel FPGA
#include "socal/alt_gpio.h"	// Header for Intel FPGA
#include "socal/alt_tmr.h"
#include "hps_0.h"			// Header of my FPGA IO
#include "jh_general.h"
#include "jh_VGA.h"
#include "jh_bitmap.h"
#include "jh_mouse.h"
#include "jh_math.c"
#include "jh_init.h"

#define FIFO_WRITE		     (*(FIFO_write_ptr))
#define FIFO_READ            (*(FIFO_read_ptr))
// WAIT looks nicer than just braces
#define WAIT	{printf("wait\n");}
// FIFO status registers
// base address is current fifo fill-level
// base+1 address is status: 
// --bit0 signals "full"
// --bit1 signals "empty"
#define WRITE_FIFO_FILL_LEVEL (*FIFO_write_status_ptr)
#define READ_FIFO_FILL_LEVEL  (*FIFO_read_status_ptr)
#define WRITE_FIFO_FULL		  ((*(FIFO_write_status_ptr+1))& 1 ) 
#define WRITE_FIFO_EMPTY	  ((*(FIFO_write_status_ptr+1))& 2 ) 
#define READ_FIFO_FULL		  ((*(FIFO_read_status_ptr+1)) & 1 )
#define READ_FIFO_EMPTY	      ((*(FIFO_read_status_ptr+1)) & 2 )
// arg a is data to be written
#define FIFO_WRITE_BLOCK(a)	  {while (WRITE_FIFO_FULL){WAIT};FIFO_WRITE=a;}
// arg a is data to be written, arg b is success/fail of write: b==1 means success
#define FIFO_WRITE_NOBLOCK(a,b) {b=!WRITE_FIFO_FULL; if(!WRITE_FIFO_FULL)FIFO_WRITE=a; }
// arg a is data read
#define FIFO_READ_BLOCK(a)	  {while (READ_FIFO_EMPTY){WAIT};a=FIFO_READ;}
// arg a is data read, arg b is success/fail of read: b==1 means success
#define FIFO_READ_NOBLOCK(a,b) {b=!READ_FIFO_EMPTY; if(!READ_FIFO_EMPTY)a=FIFO_READ;}


void fdm_accelerator(alt_u32 command, double voltage);

// Thread
void* T_save(void* threadid);				// T_control: 1
void* T_temp_display(void* threadid);		// T_control: 2
void* T_powerNimpNcem(void* threadid);
void* T_heat_display(void* threadid);
void* T_FDM_accelerator(void* threadid);
alt_u32 T_control;

typedef union {
	float number;
	struct {
		unsigned mantissa : 23; // 23 bits
		unsigned exponent : 8;	// 8 bits
		unsigned sign : 1;		// 1 bits  [MSB]
	}components;
	unsigned bit32number;		// 32 bits (4 bytes)
}ieee754;

// measure time
const double r[7] = {1, 1.166666666666667, 1.333333333333333, 1.5, 1.666666666666667, 1.833333333333333, 2};
const double dr = 0.166666666666667;
const double dz = 0.035;
const double ha = 0.000025;
const double hb = 0.0003;
const double Ta = 300;
const double Tb = 310;
const double k_a = 0.00045;
const double k_b = 0.000531;

// File 
alt_u32 file_number;
double save_data[25][900]; // 0:Time, 1:RF, 2:Electrode temperature, 3: Voltage, 4:Transmitted power[W], 
						  // 5:Load impedance, 6: FEM-electrode, 7: Cond_a, 8:Tunning, 9~16: Heat, 17~24: CEM43 
double RF_1;
double transfer_watt, load_impedance;
double temperature_error;

float fdtd_results[13][110];  // 13(row) x 110 (column)
double heat_results[8][110];
double CEM43[8];
double voltage_save;

// Cursor information
extern int cursor_x, cursor_y;

// Feedback FDM parameter
double conductive, fem_tunning;
double tunning_c, tunning_f;

// Start main thread 
int main(void) {
	printf("///////////////////////////////////\n");
	printf("///////// Program start ///////////\n");
	//	Sysmem init
	if (__init()) {
		printf("ERROR\n");
	}

	pthread_t threads_save;			// Thread for save file	(T_control: 1)	
	pthread_t threads_temperature;	// Thread for temperature1 measurement (T_control: 2)
	pthread_t threads_power;		// Thread for power measurement
	pthread_t threads_heat;			// Thread for heat distribution
	pthread_t threads_fdm;			// Thread for fdm accelerator

	// Init parameters
	int pre_cursor_x, pre_cursor_y;
	pre_cursor_x = 0;
	pre_cursor_y = 0;
	file_number = 0;
	tunning_c = 0.001;
	tunning_f = 0.00001;

	int t = 0;
	// Save pthread
	pthread_create(&threads_save, NULL, T_save, (void*)t);
	// Thermocouple pthread
	pthread_create(&threads_temperature, NULL, T_temp_display, (void*)t);
	// Power pthread
	pthread_create(&threads_power, NULL, T_powerNimpNcem, (void*)t);
	// Heat pthread
	pthread_create(&threads_heat, NULL, T_heat_display, (void*)t);
	// FDM pthread
	pthread_create(&threads_fdm, NULL, T_FDM_accelerator, (void*)t);

	//============================== 
	//		Setting Mouse, ... 
	//============================== 
	/* connect mouse */
	const char* pDevice = "/dev/input/mice";
	int fd_mouse;

	fd_mouse = open(pDevice, O_RDWR);

	if (fd_mouse == -1)
	{
		printf("ERROR Opening %s\n", pDevice);
	}

	// Needed for nonblocking read()
	int flags = fcntl(fd_mouse, F_GETFL, 0);
	fcntl(fd_mouse, F_SETFL, flags | O_NONBLOCK);

	alt_u16 MOUSE_BMP_DATA[9 * 9] = \
	{white, white, white, white, white, white, white, white, 0, \
	 white, white, white, white, white, white, white, 0, 0,		\
	 white, white, white, white, white, white, 0, 0, 0,			\
	 white, white, white, white, white, white, 0, 0, 0,			\
	 white, white, white, white, white, white, white, 0, 0,		\
	 white, white, white, white, white, white, white, white, 0, \
	 white, white, 0, 0, white, white, white, white, white,		\
	 white, 0, 0, 0, 0, white, white, white, white,				\
	 0, 0, 0, 0, 0, 0, white, white, white };

	static alt_u16 bmp_mouse_below[9 * 9];
	bmp_type bmp_mouse = { 9, 9, MOUSE_BMP_DATA };
	bmp_type below = { 9, 9, bmp_mouse_below };

	mouse_mv_type mv;
	int xold, yold, xnew, ynew, act;
	xold = 0;
	yold = 0;
		
	while (1) {
		//============================== 
		//		Reading mouse moving, ... 
		//============================== 
		act = Mouse_move(fd_mouse, &bmp_mouse, xold, yold, &below, &xnew, &ynew, &mv);
		if (act == 1) {
			if (mv.lbtn) {
				//printf("current mouse location: %d %d\n", xnew, ynew);
				cursor_x = xnew;
				cursor_y = ynew;
			}
			xold = xnew;
			yold = ynew;
		} // end if

		if (pre_cursor_x != cursor_x && pre_cursor_y != cursor_y) {
			pre_cursor_x = cursor_x;
			pre_cursor_y = cursor_y;
			if (532 < pre_cursor_x && pre_cursor_x < 604 && 184 < pre_cursor_y && pre_cursor_y < 204) {
				printf("unlock\n");
				if (*power_unlock) {
					*power_unlock = 0;
					// To solve the mouse overlap problem, plot the same box repeatly. 
					int temp_itr;
					for (temp_itr = 0; temp_itr < 100; temp_itr++) {
						VGA_box(533, 185, 603, 203, 0x0000);
						usleep(10);
					}
				}
				else {
					*power_unlock = 1;
					// To solve the mouse overlap problem, plot the same box repeatly.  
					int temp_itr;
					for (temp_itr = 0; temp_itr < 100; temp_itr++) {
						VGA_box(533, 185, 603, 203, Check);
						usleep(10);
					}
				}
			}
			else if (412 < pre_cursor_x && pre_cursor_x < 444 && 152 < pre_cursor_y && pre_cursor_y < 172) {
				printf("Target temperature is 40 C\n");
				*target_temperature = 400;
				// Check 40 C
				VGA_box_repeat(413, 153, 443, 171, Check);
				// Check 45 C
				VGA_box_repeat(453, 153, 483, 171, 0x0000);
				// Uncheck 50 C
				VGA_box_repeat(493, 153, 523, 171, 0x0000);
				// Uncheck 55 C
				VGA_box_repeat(533, 153, 563, 171, 0x0000);
				// Uncheck 60 C
				VGA_box_repeat(573, 153, 603, 171, 0x0000);
			}
			else if (452 < pre_cursor_x && pre_cursor_x < 484 && 152 < pre_cursor_y && pre_cursor_y < 172) {
				printf("Target temperature is 45 C\n");
				*target_temperature = 450;
				// Check 40 C
				VGA_box_repeat(413, 153, 443, 171, 0x0000);
				// Check 45 C
				VGA_box_repeat(453, 153, 483, 171, Check);
				// Uncheck 50 C
				VGA_box_repeat(493, 153, 523, 171, 0x0000);
				// Uncheck 55 C
				VGA_box_repeat(533, 153, 563, 171, 0x0000);
				// Uncheck 60 C
				VGA_box_repeat(573, 153, 603, 171, 0x0000);
			}
			else if (492 < pre_cursor_x && pre_cursor_x < 524 && 152 < pre_cursor_y && pre_cursor_y < 172) {
				printf("Target temperature is 50 C\n");
				*target_temperature = 500;
				// Check 40 C
				VGA_box_repeat(413, 153, 443, 171, 0x0000);
				// Uncheck 45 C
				VGA_box_repeat(453, 153, 483, 171, 0x0000);
				// Check 50 C
				VGA_box_repeat(493, 153, 523, 171, Check);
				// Uncheck 55 C
				VGA_box_repeat(533, 153, 563, 171, 0x0000);
				// Uncheck 60 C
				VGA_box_repeat(573, 153, 603, 171, 0x0000);
			}				
			else if (532 < pre_cursor_x && pre_cursor_x < 564 && 152 < pre_cursor_y && pre_cursor_y < 172) {
				printf("Target temperature is 55 C\n");
				*target_temperature = 550;
				// Check 40 C
				VGA_box_repeat(413, 153, 443, 171, 0x0000);
				// Uncheck 45 C
				VGA_box_repeat(453, 153, 483, 171, 0x0000);
				// Check 50 C
				VGA_box_repeat(493, 153, 523, 171, 0x0000);
				// Uncheck 55 C
				VGA_box_repeat(533, 153, 563, 171, Check);
				// Uncheck 60 C
				VGA_box_repeat(573, 153, 603, 171, 0x0000);
			}
			else if (572 < pre_cursor_x && pre_cursor_x < 604 && 152 < pre_cursor_y && pre_cursor_y < 172)
			{
				printf("Target temperature is 60 C\n");
				*target_temperature = 600;
				// Check 40 C
				VGA_box_repeat(413, 153, 443, 171, 0x0000);
				// Uncheck 45 C
				VGA_box_repeat(453, 153, 483, 171, 0x0000);
				// Check 50 C
				VGA_box_repeat(493, 153, 523, 171, 0x0000);
				// Uncheck 55 C
				VGA_box_repeat(533, 153, 563, 171, 0x0000);
				// Uncheck 60 C
				VGA_box_repeat(573, 153, 603, 171, Check);
			}
			else if (532 < pre_cursor_x && pre_cursor_x < 604 && 100 < pre_cursor_y && pre_cursor_y < 128) 
			{
				printf("SAVE\n");
				// Exit threads
				T_control = 1;
				pthread_join(threads_save, NULL);
				while(T_control != 0){}
				T_control = 2;
				pthread_join(threads_temperature, NULL);
				while (T_control != 0){}
				T_control = 3;
				pthread_join(threads_power, NULL);
				while (T_control != 0) {}
				T_control = 4;
				pthread_join(threads_heat, NULL);
				while (T_control != 0) {}
				T_control = 5;
				pthread_join(threads_fdm, NULL);
				while (T_control != 0) {}

				// Restart threads
				pthread_create(&threads_save, NULL, T_save, (void*)t);
				pthread_create(&threads_temperature, NULL, T_temp_display, (void*)t);
				pthread_create(&threads_power, NULL, T_powerNimpNcem, (void*)t);
				pthread_create(&threads_heat, NULL, T_heat_display, (void*)t);
				pthread_create(&threads_fdm, NULL, T_FDM_accelerator, (void*)t);

			}			
			else if (470 < pre_cursor_x && pre_cursor_x < 490 && 102 < pre_cursor_y && pre_cursor_y < 110)
			{
				char text[10];
				printf("UP\n");
				file_number = file_number + 1;
				if(file_number < 10) sprintf(text, "0%d", file_number);
				else sprintf(text, "%d", file_number);
				VGA_text(63, 14, text);
			}				
			else if (470 < pre_cursor_x && pre_cursor_x < 490 && 118 < pre_cursor_y && pre_cursor_y < 126)
			{
				char text[10];
				printf("DOWN\n");
				if (file_number == 0) file_number = 0;
				else file_number = file_number - 1;

				if (file_number < 10) sprintf(text, "0%d", file_number);
				else sprintf(text, "%d", file_number);
				VGA_text(63, 14, text);
			}
			// UP for Tune_c 
			else if (270 < pre_cursor_x && pre_cursor_x < 290 && 30 < pre_cursor_y && pre_cursor_y < 38)
			{
				char text[10];
				int temp_tunning_c;
				printf("Tune_c UP\n");
				tunning_c = tunning_c + 0.001;	// tunning_c = 0.001 at init
				temp_tunning_c = tunning_c * 1000;
				if (temp_tunning_c < 10) sprintf(text, "0%d", temp_tunning_c);
				else sprintf(text, "%d", temp_tunning_c);
				VGA_text(38, 5, text);
			}
			// Down for Tune_c 
			else if (270 < pre_cursor_x && pre_cursor_x < 290 && 46 < pre_cursor_y && pre_cursor_y < 54)
			{
				char text[10];
				int temp_tunning_c;
				printf("Tune_c DOWN\n");
				if (tunning_c <= 0) tunning_c = 0;
				else tunning_c = tunning_c - 0.001;

				temp_tunning_c = tunning_c * 1000;
				if (temp_tunning_c < 10) sprintf(text, "0%d", temp_tunning_c);
				else sprintf(text, "%d", temp_tunning_c);
				VGA_text(38, 5, text);
			}
			// UP for Tune_f 
			else if (349 < pre_cursor_x && pre_cursor_x < 362 && 30 < pre_cursor_y && pre_cursor_y < 38)
			{
				char text[10];
				int temp_tunning_f;
				printf("Tune_f UP\n");
				tunning_f = tunning_f + 0.00001;	// tunning_c = 0.0003 at init
				temp_tunning_f = tunning_f * 100000;
				if (temp_tunning_f < 10) sprintf(text, "0%d", temp_tunning_f);
				else sprintf(text, "%d", temp_tunning_f);
				VGA_text(48, 5, text);
			}
			// Down for Tune_f 
			else if (349 < pre_cursor_x && pre_cursor_x < 362 && 46 < pre_cursor_y && pre_cursor_y < 54)
			{
				char text[10];
				int temp_tunning_f;
				printf("Tune_f DOWN\n");
				if (tunning_f <= 0) tunning_f = 0;
				else tunning_f = tunning_f - 0.00001;

				temp_tunning_f = tunning_f * 100000;
				if (temp_tunning_f < 10) sprintf(text, "0%d", temp_tunning_f);
				else sprintf(text, "%d", temp_tunning_f);
				VGA_text(48, 5, text);
			}
			else if (572 < pre_cursor_x && pre_cursor_x < 594 && 24 < pre_cursor_y && pre_cursor_y < 60)
			{
				printf("HW\n");
				*HW_reset_ptr = 1;
				usleep(10000);
				*HW_reset_ptr = 0;
			}
			else if (500 < pre_cursor_x && pre_cursor_x < 556 && 24 < pre_cursor_y && pre_cursor_y < 60)
			{
				printf("STOP\n");
				*rf_on_off = 0;
			}
			else if (420 < pre_cursor_x && pre_cursor_x < 484 && 24 < pre_cursor_y && pre_cursor_y < 60) 
			{
				printf("START\n");
				// Clean box
				VGA_box(293, 101, 321, 199, 0x0000);
				int temp_itr;
				for (temp_itr = 0; temp_itr < 8; temp_itr++) {
					CEM43[temp_itr] = 0;
				}
				*rf_on_off = 1;
			}	
		}
	} 
	
	return 0;
}

/* =====================================================================
function: T_FDM_accelerator ()
purpose	: function for fdm accelerator thread
argument:
	void
return	:
	void
!!Caution
===================================================================== */

void* T_save(void* threadid) {
	printf("Start T_save thread\n");
	struct timeval t1, t2;	
	double elapsedTime;		
	alt_u32 tick = 1;
	//=============================
	//	start timer
	//=============================
	gettimeofday(&t1, NULL);

	while (1) {
		if (T_control == 1) break;
		//===============
		//	stop timer
		//===============
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec);					// sec
		elapsedTime += ((t2.tv_usec - t1.tv_usec) / 1000000.0);   // us to sec

		if (elapsedTime > tick) {
			//printf("time: %d\n", tick);
			save_data[0][tick] = tick;				// Time
			save_data[1][tick] = RF_1;				// RF on / off
			save_data[2][tick] = *temper_ptr;		// Electrode temperature
			save_data[3][tick] = voltage_save;
			save_data[4][tick] = transfer_watt;		// Transmitted RF energy [W]
			save_data[5][tick] = load_impedance;	// Load impedance [Ohm]
			save_data[6][tick] = temperature_error;	// Difference between the fdm results and the electrode temperature
			save_data[7][tick] = conductive;		// Estimated conductivity
			save_data[8][tick] = fem_tunning;		// Tunning parameter
			save_data[9][tick] = heat_results[7][55];	// 7
			save_data[10][tick] = heat_results[6][55];	// 6
			save_data[11][tick] = heat_results[5][55];	// 5
			save_data[12][tick] = heat_results[4][55];	// 4
			save_data[13][tick] = heat_results[3][55];	// 3
			save_data[14][tick] = heat_results[2][55];	// 2
			save_data[15][tick] = heat_results[1][55];	// 1
			save_data[16][tick] = heat_results[0][55];	// 0
			save_data[17][tick] = CEM43[7];				// CEM43 7
			save_data[18][tick] = CEM43[6];				// 6
			save_data[19][tick] = CEM43[5];				// 5
			save_data[20][tick] = CEM43[4];				// 4
			save_data[21][tick] = CEM43[3];				// 3
			save_data[22][tick] = CEM43[2];				// 2
			save_data[23][tick] = CEM43[1];				// 1
			save_data[24][tick] = CEM43[0];				// 0
			tick = tick + 1;
		} // end if (elapsedTime > tick) 	
	}

	FILE* fd;
	char text[30];
	sprintf(text, "results%d.dat", file_number);
	fd = fopen(text, "wb");
	if (!fd) puts("Failed to open file");
	fwrite(save_data, sizeof(double), 22500, fd);
	fclose(fd);

	T_control = 0;
	printf("Finish T_save\n");
	return 0;
}
/* =====================================================================
function: T_FDM_accelerator ()
purpose	: function for fdm accelerator thread
argument:
	void
return	:
	void
!!Caution
===================================================================== */

void* T_FDM_accelerator(void* threadid) {
	printf("Start T_FDM_accelerator thread\n");
	//=============================
	// 1. FDM setting and initiation
	//=============================
	alt_u32 i_r, i_z;
	*iteration_number_ptr = 5000;			// FDM iteration is 5000. 

	
	for (i_r = 0; i_r < 8; i_r++) {
		for (i_z = 0; i_z < 110; i_z++) {
			heat_results[i_r][i_z] = 310.0;	
		}
		CEM43[i_r] = 0;
	}

	RF_1 = 0;

	alt_u32 fpower_n, rpower_n, difference_n, add_n;
	double reflect_coef;

	double volt_volt;
	int itr_root;

	double voltage;
	
	double electrode_temperature_k = 0;
	ieee754 read_number;
	int temp_cem43;

	char text[50];

	conductive = 0.33;				// Heat equation parameter
	fem_tunning = 0;				// Heat equation parameter

	while (1) {
		if (T_control == 5) break;

		//=============================================
		// 2. Find the electrode voltage, impedance
		//=============================================
		// Check module_state_ptr
		// 1. module_state_ptr[0]
		// while ((*module_state_ptr & 0x0001) != 0x0001);		// If set RF_fpga on  (0b0001)
		// while ((*module_state_ptr & 0x0001) != 0x0000);		// If set RF_fpga off (0b0000)
		// 2. module_state_ptr[1]
		// while ((*module_state_ptr & 0x0002) != 0x0002);		// If get voltage (0b0010)
		// 3. module_state_ptr[3]
		// while ((*module_state_ptr & 0x0008) != 0x0008);		// If set en_RF (0b1000) 

		while ((*module_state_ptr & 0x0001) != 0x0001);		// RF_fpga on 
		//printf("start\n");
		if ((*module_state_ptr & 0x0008) == 0x0008) {		// RF energy is transmitted (set en_RF)
			// RF On
			RF_1 = 1;
			// If get voltage (0b0010) or If set RF_fpga off
			while (((*module_state_ptr & 0x0002) != 0x0002) && ((*module_state_ptr & 0x0008) != 0x0008));

			fpower_n = (*pwforward_ptr);
			rpower_n = (*pwreversed_ptr);
			if (fpower_n < 100) fpower_n = 0;
			if (rpower_n < 100) rpower_n = 0;
			if (fpower_n >= rpower_n) {
				difference_n = fpower_n - rpower_n;
				add_n = fpower_n + rpower_n;
			}
			else {
				difference_n = 0;
				add_n = 0;
			}

			// Transmitted power
			transfer_watt = difference_n * add_n * 0.000002209; // 

			// Find the reflection coefficient
			if (fpower_n == 0) reflect_coef = 1;
			else if (fpower_n > rpower_n) reflect_coef = (double)rpower_n / fpower_n;
			else reflect_coef = 1;		// Reflection coefficient = 1 means the load is open.

			// Find the load impedance and the electrode voltage
			if (reflect_coef != 1) {
				load_impedance = 50 * (1 + reflect_coef) / (1 - reflect_coef);

				volt_volt = transfer_watt * load_impedance;
				voltage = volt_volt;
				for (itr_root = 0; itr_root < 5; itr_root++) {
					if (voltage < 1.0) break;
					voltage = (voltage / 2) + (volt_volt / (2 * voltage));
				}
			}
			else {
				// RF Off 
				load_impedance = 0;		// It means the load is open.
				voltage = 0;
			}
		}
		else {							// RF energy is not transmitted
			RF_1 = 0;
			voltage = 0;
			transfer_watt = 0;
			load_impedance = 0;
		} // end if((*module_state_ptr & 0x0008) == 0x0008)

		voltage_save = voltage;

		//=========================================================
		// 3. Solve the voltage distribution using FDM accelerator
		//=========================================================
		if(electrode_temperature_k > 310){
			// Initiate "fdtd_results[13][110]" using the electrode voltage
			fdm_accelerator(1, voltage);		// anode = +(0.5*voltage), cathode = -(0.5*voltage)

			if (voltage != 0) {
				// Calculate the voltage distribution 
				// printf("Find voltage distribution\n");
				fdm_accelerator(2, voltage);

				// Load the FDM results
				for (i_r = 0; i_r < 13; i_r++) {
					*(command_ptr) = (4 << 10) + i_r;	// start to fifo from fpga to hps	
					for (i_z = 0; i_z < 110; i_z++) {
						read_number.bit32number = (FIFO_READ << 5);
						fdtd_results[i_r][i_z] = read_number.number;
					}
					*(command_ptr) = 0;
				}
			}
			else {
				// No voltage
				for (i_r = 0; i_r < 13; i_r++)
					for (i_z = 0; i_z < 110; i_z++) {
						fdtd_results[i_r][i_z] = 0;
					}
			}
		}
		//=========================================================
		// 3. Solve the heat distribution using FDM results
		//=========================================================
		// Calculate the heat distribution during RF on (5.2 msec)
		fdm_accelerator(3, voltage);

		// Calculate the heat distribution during RF off (10.4 msec)
		fdm_accelerator(3, 0);
		fdm_accelerator(3, 0);
		//======================================================================
		// 4. Comparing the simulation results and re-define conductivity.
		//======================================================================	
		electrode_temperature_k = *temper_ptr;
		electrode_temperature_k = 273.15 + electrode_temperature_k / 10;
		temperature_error = heat_results[7][55] - electrode_temperature_k;

		if (electrode_temperature_k > 310 && RF_1) {
			if (temperature_error >= -1 && temperature_error <= 1) {
				printf("===========Find===========\n");
				printf("Heat_results : %f, electrode_temperature : %f\n", heat_results[7][55] - 273.15, electrode_temperature_k - 273.15);
				printf("Difference : %f\n", temperature_error);
				printf("Conductivity : %f\n", conductive);
				printf("Tunning : %f\n", fem_tunning);
				for (i_r = 1; i_r < 7; i_r++) {
					if (heat_results[i_r][55] > 316.15) {
						temp_cem43 = (int)(heat_results[i_r][55] - 316.15);		// 273.15 + 43 = 316.15
						CEM43[i_r] = CEM43[i_r] + 0.0156 * (2 << temp_cem43);
						printf("CEM43[%d]: %d \n", i_r, (int)CEM43[i_r]);
					}
				}
				// print message
				sprintf(text, "Cond. = %4d", (int)(conductive*1000));
				VGA_text(5, 10, text);
				VGA_text(18, 10, "[mS/m]");
			}
			else {
				if (fem_tunning <= 0) {
					fem_tunning = 0.0001;
					conductive = conductive + tunning_c;
				}
				else if (0 < fem_tunning && fem_tunning <= 0.05) {			// 1-> 0.45
					fem_tunning = fem_tunning + temperature_error * tunning_f;
				}
				else if (fem_tunning > 0.05) {
					fem_tunning = 0.0499;
					conductive = conductive - tunning_c;
				}
				printf("Heat_results : %f, electrode_temperature : %f\n", heat_results[7][55] - 273.15, electrode_temperature_k - 273.15);
				printf("Difference : %f\n", temperature_error);
				printf("Conductivity : %f\n", conductive);
				printf("Tunning : %f\n", fem_tunning);
			}
		}
	} // end while(1)

	T_control = 0;
	return 0;
}

/* =====================================================================
function: fdm_accelerator ()
purpose	: operating FPGA accelerator
argument: 
	command: control the function (1 ~ 6)
	voltage: boundary condition of FDM
return	:
	void
!!Caution
===================================================================== */

void fdm_accelerator(alt_u32 command, double voltage)
{
	alt_u32 size_r = 13;
	
	// init (h2f)
	if (command == 1) {
		// hps2fpge_number [31:0] = [31:27 (r), 26:0 (number)],	r = 5 bits
		// command [31:0] = [13:10 (mode), 5:0 (pe number = r)]
		//	mode =	4'b0001: init, 
		//			4'b0010: computing, 
		//			4'b0100: read single M10K, 
		//			4'b1000: read all M10K, 
		//			*4'b0000: finish read operation
		//	pe_num = 0 to 12
		///////////////////////////////////////////////////////////

		//Init as 0 voltage
		alt_u32 i_r, i_z;
		ieee754 write_number;
		alt_u32 hps2fpge_number = 0;
		float boundary_interval;
		boundary_interval = 2.0 * voltage / 71.0;

		for (i_r = 0; i_r < size_r; i_r++) {
			*(command_ptr) = (1 << 10);	// 4'b0001: init 

			if (i_r < size_r - 1) {
				for (i_z = 0; i_z < 110; i_z++) {
					hps2fpge_number = (i_r << 27);
					FIFO_WRITE_BLOCK(hps2fpge_number);
				}
			}
			else { // at i_r = 12
				for (i_z = 0; i_z < 110; i_z++) {
					if (i_z > 3 && i_z < 20) write_number.number = (float)voltage;
					else if (i_z > 19 && i_z < 90) write_number.number = write_number.number - boundary_interval;
					else if (i_z > 89 && i_z < 106) write_number.number = (float)(-1.0 * voltage);
					else write_number.number = (float)0;
					hps2fpge_number = (i_r << 27) + (write_number.bit32number >> 5);
					FIFO_WRITE_BLOCK(hps2fpge_number);
				}
			}
			*(command_ptr) = 0; // 4'b0000: finish read operation
		}
	} // end if (command == 1)

	//computing FDM (f2h)
	else if (command == 2) {
		alt_u32 i_r, i_z;
		i_r = size_r - 1;
		ieee754 write_number;
		alt_u32 hps2fpge_number = 0;
		float boundary_interval;
		boundary_interval = 2.0 * voltage / 71.0;
		//
		*(command_ptr) = (1 << 10);	// 4'b0001: init
		for (i_z = 0; i_z < 110; i_z++) {
			if (i_z > 3 && i_z < 20) write_number.number = (float)voltage;
			else if (i_z > 19 && i_z < 90) write_number.number = write_number.number - boundary_interval;
			else if (i_z > 89 && i_z < 106) write_number.number = (float)(-1.0 * voltage);
			else write_number.number = (float)0;
			hps2fpge_number = (i_r << 27) + (write_number.bit32number >> 5);
			FIFO_WRITE_BLOCK(hps2fpge_number);
		}
		*(command_ptr) = 0;			// 4'b0000: finishing operation
		*(command_ptr) = (2 << 10);	// 4'b0010: computing, 
		while (!(*finishing_fdtd_ptr)) {} // wait finishing fdtd
		*(command_ptr) = 0;
				
	} // end if (command == 2)

	// Calculate the heat distribution
	else if (command == 3) {
		alt_u32 i_r, i_z;
		double dt = 0.0052;
		// a: artery
		double alpha1 = dt * 0.0001293214932321752;   // dt*k_a/(rho_a*c_a)
		double alpha2 = dt * conductive * 0.2874;		  // dt*cond_a/(rho_a*c_a)
		if (voltage == 0) alpha2 = 0;

		double heat_results2[8][110];
		double Ez, Er;
		double temp1, temp2, temp3;
		double left, right, top, bottom, center;
		
		for (i_r = 0; i_r < 8; i_r++) {
			for (i_z = 0; i_z < 110; i_z++) {
				heat_results2[i_r][i_z] = heat_results[i_r][i_z];
			}
		}

		for (i_r = 1; i_r < 7; i_r++) {
			for (i_z = 1; i_z < 109; i_z++) {
				left = heat_results2[i_r - 1][i_z];
				right = heat_results2[i_r + 1][i_z];
				top = heat_results2[i_r][i_z + 1];
				bottom = heat_results2[i_r][i_z - 1];
				center = heat_results2[i_r][i_z];

				temp1 = (right - left) / (2 * r[i_r] * dr);			//////////////// r[i_r - 1] -> r[i_r] ??????
				temp2 = (right - 2 * center + left) / (dr * dr);
				temp3 = (top - 2 * center + bottom) / (dz * dz);
				Er = (fdtd_results[i_r + 6][i_z] - fdtd_results[i_r + 4][i_z]) / (2 * dr);
				Ez = (fdtd_results[i_r + 5][i_z + 1] - fdtd_results[i_r + 5][i_z - 1]) / (2 * dz);
				heat_results[i_r][i_z] = heat_results2[i_r][i_z] + alpha1 * (temp1 + temp2 + temp3) + alpha2 * (Ez * Ez + Er * Er) - fem_tunning * (heat_results2[i_r][i_z] - 310);
			}
			heat_results[i_r][0] = heat_results[i_r][1];		// Left
			heat_results[i_r][109] = heat_results[i_r][108];	// Righ
		}
		for (i_z = 1; i_z < 110; i_z++) {
			heat_results[7][i_z] = heat_results[6][i_z]; // Outer wall
			heat_results[1][i_z] = k_b / (k_b + hb * dr) * (heat_results[2][i_z] + hb * dr * Tb / k_b); // Inner wall
		}
	} // end if (command == 3)

	//read voltage of a single raw
	else if (command == 4) {
		alt_u32 i;
		alt_u32 r_value;
		printf("Enter <r> value you want: ");
		scanf("%d", &r_value);
		*(command_ptr) = (4 << 10) + r_value;	// start to fifo from fpga to hps			
		printf("Is empty? %d 1:yes, 0: no \n", READ_FIFO_EMPTY);
		ieee754 read_number;

		for (i = 0; i < 110; i++) {
			read_number.bit32number = (FIFO_READ << 5);
			printf("return=%f %d %d\n\r", read_number.number, WRITE_FIFO_FILL_LEVEL, READ_FIFO_FILL_LEVEL);
		}
		*(command_ptr) = 0;
	} // end if (command == 4)

	// Read the heat distribution
	else if (command == 5) {
		alt_u32 i_z;
		alt_u32 r_value;
		printf("Enter <r> value you want: ");
		scanf("%d", &r_value);
		for (i_z = 0; i_z < 110; i_z++) {
			printf("return=%f\n\r", heat_results[r_value][i_z]);
		}
	} // end if (command == 5)

	// Save all data
	else if (command == 6) {
		FILE* fd;
		fd = fopen("results.dat", "wb");
		if (!fd) puts("Failed to open file");
		fwrite(fdtd_results, sizeof(float), 1430, fd);
		fclose(fd);

		fd = fopen("results_heat.dat", "wb");
		if (!fd) puts("Failed to open file");
		fwrite(heat_results, sizeof(double), 880, fd);
		fclose(fd);
	} // end if (command == 6)

} // end fdm_accelerator()

/* =====================================================================
function: T_heat_display ()
purpose	: Display heat distribution
argument:
	void
return	:
	void
!!Caution
===================================================================== */

void* T_heat_display(void* threadid) {
	
	printf("Start T_heat_display thread\n");
	int itr;
	int cent_x = 160;
	int cent_y = 300;
	int row, col, xc, yc;
	int rsqr;
	int display_on = 0;
	short pixel_color, layer_color;
	alt_u32 layer_temper[8];
	layer_temper[0] = colarbar0;

	// heat_results [K]  
	while(1){
		if (T_control == 4) break;
		for (itr = 1; itr < 8; itr++) {
			if (heat_results[itr][55] <= 310) layer_color = colarbar0;
			else if (heat_results[itr][55] <= 313) layer_color = colarbar1;
			else if (heat_results[itr][55] <= 315) layer_color = colarbar2;
			else if (heat_results[itr][55] <= 318) layer_color = colarbar3;
			else if (heat_results[itr][55] <= 320) layer_color = colarbar4;
			else if (heat_results[itr][55] <= 323) layer_color = colarbar5;
			else if (heat_results[itr][55] <= 325) layer_color = colarbar6;
			else if (heat_results[itr][55] <= 328) layer_color = colarbar7;
			else if (heat_results[itr][55] <= 330) layer_color = colarbar8;
			else layer_color = colarbar9;
			layer_temper[itr] = layer_color;
			//printf("layer %d: %f \n", itr, heat_results[itr][55]);
		}
		if (*temper_ptr > 400) display_on = 1;
		else display_on = 0;
		//printf("///////////////\n");

		if (display_on) {
			for (yc = -127; yc <= 127; yc++) {
				for (xc = -127; xc <= 127; xc++)
				{
					col = xc;
					row = yc;
					rsqr = col * col + row * row;
					// rsqr < r * r + r
					if (rsqr <= 4160) pixel_color = layer_temper[0];
					else if (rsqr <= 5402) pixel_color = layer_temper[1];
					else if (rsqr <= 6806) pixel_color = layer_temper[2];
					else if (rsqr <= 8372) pixel_color = layer_temper[3];
					else if (rsqr <= 10100) pixel_color = layer_temper[4];
					else if (rsqr <= 11990) pixel_color = layer_temper[5];
					else if (rsqr <= 14042) pixel_color = layer_temper[6];
					else if (rsqr <= 16256) pixel_color = layer_temper[7];
					else pixel_color = 0;

					col = col + cent_x;
					row = row + cent_y;
					VGA_PIXEL(col, row, pixel_color);
				}
			}
		}	
	}
	T_control = 0;
	return 0;
}

/* =====================================================================
function: T_powerNimpNcem ()
purpose	: Display transmitted power, load imedance, CEM43
argument:
	void
return	:
	void
!!Caution
===================================================================== */
void* T_powerNimpNcem(void* threadid) {
	printf("Start T_powerNimp_display thread\n");
	double pre_transfer_watt;
	double pre_load_impedance;
	double pre_cem43;
	int plot_y;
	char text[40];
	pre_transfer_watt = transfer_watt;
	pre_load_impedance = load_impedance;
	pre_cem43 = CEM43[4];

	while (1) {
		if (T_control == 3) break;
		// Plot CEM43 [0 to 9000 (150min)]
		if (pre_cem43 != CEM43[4]) {
			pre_cem43 = CEM43[4];
			if (pre_cem43 < 9000) {
				// print message
				sprintf(text, "CEM43 = %4d", (int)pre_cem43);
				VGA_text(5, 9, text);
				// Plot box
				plot_y = 200 - (int)(pre_cem43 * 0.011);
				VGA_box(293, plot_y, 321, 199, red);
			}
			else {
				VGA_text(5, 9, "CEM43 = MAX  ");
				VGA_box(293, 101, 321, 199, red);
			}
		}
		// Plot transmitted power [0 to 5 watt]
		if (pre_transfer_watt != transfer_watt) {
			pre_transfer_watt = transfer_watt;
			// print message
			sprintf(text, "Power = %4.1f", pre_transfer_watt);
			VGA_text(5, 7, text);
			// Clean box
			VGA_box(337, 101, 365, 199, 0x0000);
			// upper limit
			if (pre_transfer_watt > 5) pre_transfer_watt = 5;	
			// Plot box
			plot_y = 201 - (int)(pre_transfer_watt * 20);
			VGA_box(337, plot_y, 365, 199, yellow);
		}
		// Plot load impedance [0(open) to 200 ohm]
		if (pre_load_impedance != load_impedance) {
			pre_load_impedance = load_impedance;
			// print message
			sprintf(text, "Load  = %4d", (int)pre_load_impedance);
			VGA_text(5, 8, text); 
			// Clean box
			VGA_box(377, 101, 405, 199, 0x0000);
			// upper limit
			if (pre_load_impedance > 250) pre_load_impedance = 250;
			// Plot box
			plot_y = 201 - (int)(pre_load_impedance * 0.4);
			VGA_box(377, plot_y, 405, 199, green);
		}
	}
	T_control = 0;
	return 0;
}
/* =====================================================================
function: T_temp_display ()
purpose	: Display temperature data of two thermocouple ADC
argument: 
	void
return	:
	void
!!Caution
===================================================================== */
# define array_size 270		// Display 68 thermocouple samples (1 sample/second), At circular Queue MAX node = MAX data + 1

void* T_temp_display(void* threadid) {
	printf("Start T_temp_display thread\n");
	VGA_box(329, 247, 599, 399, 0x0000);	// clear temperature plot box
	// Measure time
	struct timeval t1, t2;
	double elapsedTime = 0;
	double tick = 1;
	double tick_increase = 0.4;
	int i, x = 0;

	// Array for temperature data
	double temp_array[array_size] = { 0, };
	int start_id = 0;
	char ablation_temp[40];
	double temp = 0;

	// Label 
	double x_start = 0;
	char x_label[10];
	VGA_text(40, 51, "   ");
	VGA_text(52, 51, "   ");
	VGA_text(63, 51, "   ");
	VGA_text(41, 51, "0");
	VGA_text(52, 51, "36");
	VGA_text(63, 51, "73");
	VGA_text(74, 51, "110");

	//=============================
	//	start timer
	//=============================

	gettimeofday(&t1, NULL);

	while (1) {
		if (T_control == 2) break;
		//===============
		//	stop timer
		//===============
		gettimeofday(&t2, NULL);
		elapsedTime = (t2.tv_sec - t1.tv_sec);					// sec
		elapsedTime += ((t2.tv_usec - t1.tv_usec) / 1000000.0);   // us to sec

		temp = (*temper_ptr);							// read temperature from FPGA, (e.g. 27 C = 270)
		// print message
		sprintf(ablation_temp, "Temp. = %3.1f", temp / 10.0);
		VGA_text(5, 6, ablation_temp);
		VGA_text(18, 6, "[C]");

		if (elapsedTime > tick) {
			// Put data to array 
			temp_array[start_id] = temp;
			start_id = ((start_id + 1) % array_size);
			// Read all data from temp_array[]
			if (tick < 1 + tick_increase * array_size) {	// Before filling the array
				for (i = 0; i < array_size; i++) {	// plot 15.4 ~ 77.0 C
					if (temp_array[i] > 154 && temp_array[i] < 770) {
						VGA_PIXEL_SIZE(330 + i, 399 - (((int)(temp_array[i]) - 154) / 4), red);
					}
				}
			}
			else {
				i = start_id;
				x = 0;
				// print x-axis label
				x_start = x_start + 0.4;
				sprintf(x_label, "%d", (int) x_start);
				VGA_text(40, 51, x_label);
				sprintf(x_label, "%d", (int)(x_start + 35));
				VGA_text(52, 51, x_label);
				sprintf(x_label, "%d", (int)(x_start + 72));
				VGA_text(63, 51, x_label);
				sprintf(x_label, "%d", (int)(x_start + 109));
				VGA_text(74, 51, x_label);
				// plot temperature profile
				VGA_box(329, 247, 599, 399, 0x0000);	// clear temperature plot box
				do {
					if (temp_array[i] > 154 && temp_array[i] < 770) {
						VGA_PIXEL_SIZE(330 + x, 399 - (((int)(temp_array[i]) - 154) / 4), red);
					}
					x++;
					i = ((i + 1) % array_size);
				} while (i != start_id);
			} // end if (tick < MAX+1)
			tick = tick + tick_increase;
		} // end if (elapsedTime > tick) 	
	} // end while(1)

	T_control = 0;
	printf("Finish T_temp_display\n");
	return 0;
}
