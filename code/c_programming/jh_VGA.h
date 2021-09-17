
#ifndef __JHVGA_H_
#define __JHVGA_H_

#define colarbar0	((14<<5) + 30)
#define colarbar1   ((1<<11) +	(43<<5) + 31)
#define colarbar2	((43<<5) + 31)
#define colarbar3	((63<<5) + 22)
#define colarbar4	((63<<5) + 13)
#define colarbar5   ((11<<11) +	(63<<5)) 
#define colarbar6   ((22<<11) + (63<<5))
#define colarbar7   ((31<<11) + (63<<5))
#define colarbar8   ((31<<11) + (43<<5) + 1)
#define colarbar9   ((30<<11) + (14<<5))

#define white		(31+(63<<5)+(31<<11))
#define red			((31<<11))
#define green		((63<<5))
#define blue		(31)
#define yellow		((63<<5)+(31<<11))
#define purple		(16+(16<<5)+(16<<11))
#define Check		(1+(43<<5)+(31<<11))
#define SWAP(X,Y) do{ \
int temp=X; X=Y; Y=temp; \
} while(0) 
#define VGA_PIXEL(x,y,color) do{ \
int *pixel_ptr ;\
pthread_mutex_lock(&vga_pixel_lock); \
pixel_ptr = (int*)((char *)vga_pixel_ptr + (((y)*640+(x))<<1)) ; \
pthread_mutex_unlock(&vga_pixel_lock); \
*(short *)pixel_ptr = (color); \
} while(0)
#define VGA_PIXEL_SIZE(x,y,color) do{ \
int *pixel_ptr ;\
int VGA_PIXEL_SIZE_i, VGA_PIXEL_SIZE_j; \
for (VGA_PIXEL_SIZE_i=(x-1); VGA_PIXEL_SIZE_i<(x+1); VGA_PIXEL_SIZE_i++) \
{	\
	for (VGA_PIXEL_SIZE_j=(y-1); VGA_PIXEL_SIZE_j<(y+1); VGA_PIXEL_SIZE_j++) \
	{	\
		pthread_mutex_lock(&vga_pixel_lock); \
		pixel_ptr = (int*)((char*)vga_pixel_ptr + (((VGA_PIXEL_SIZE_j) * 640 + (VGA_PIXEL_SIZE_i)) << 1)); \
		*(short *)pixel_ptr = (color); \
		pthread_mutex_unlock(&vga_pixel_lock); \
	}	\
}	\
} while(0)

extern volatile alt_u32* vga_char_ptr;
extern volatile alt_u32* vga_pixel_ptr;
extern pthread_mutex_t vga_char_lock;
extern pthread_mutex_t vga_pixel_lock;

/* =====================================================================
function: VGA_text ()
purpose	: Send a string of text to the VGA monitor
argument:
	x: x-axis coordinate (16 bit and consecutive address format)
	y: y-axis coordinate
	text_ptr: text string
reture	: Void
!!Caution
	It needs extern variable <vga_char_ptr>.
===================================================================== */
void VGA_text(int x, int y, char* text_ptr)
{
	int offset;
	pthread_mutex_lock(&vga_char_lock);
	volatile char* character_buffer = (char*)vga_char_ptr;	// VGA character buffer

	//Assume that the text string fits on one line 

	offset = (y << 7) + x;
	while (*(text_ptr))
	{
		// write to the character buffer
		*(character_buffer + offset) = *(text_ptr);
		++text_ptr;
		++offset;
	}
	pthread_mutex_unlock(&vga_char_lock);
}

/* =====================================================================
function: VGA_box ()
purpose	: Draw a filled rectangle on the VGA monitor
argument:
	x1: left top, x-axis coordinate (16 bit and consecutive address format)
	y1: left top, y-axis coordinate
	x2: right bottom, x-axis coordinate
	y2: right bottom, y-axis coordinate
	pixel_color: Box color
reture	: Void
!!Caution
	It needs extern variable <vga_char_ptr>.
===================================================================== */
void VGA_box(int x1, int y1, int x2, int y2, short pixel_color)
{
	int row, col;

	// y1 < y2
	for (row = y1; row <= y2; row++)
	{
		// x1 < x2
		for (col = x1; col <= x2; ++col)
		{
			VGA_PIXEL(col, row, pixel_color);
		}
	}
}

/* =====================================================================
function: VGA_box_repeat ()
purpose	: Draw a filled rectangle on the VGA monitor
argument:
	x1: left top, x-axis coordinate (16 bit and consecutive address format)
	y1: left top, y-axis coordinate
	x2: right bottom, x-axis coordinate
	y2: right bottom, y-axis coordinate
	pixel_color: Box color
reture	: Void
!!Caution
	It needs extern variable <vga_char_ptr>.
===================================================================== */
void VGA_box_repeat(int x1, int y1, int x2, int y2, short pixel_color)
{
	int row, col;
	int temp_itr;
	// y1 < y2
	for (temp_itr = 0; temp_itr < 10; temp_itr++) {
		for (row = y1; row <= y2; row++)
		{
			// x1 < x2
			for (col = x1; col <= x2; ++col)
			{
				VGA_PIXEL(col, row, pixel_color);
			}
		}
		usleep(10);
	}
}

void VGA_Hline(int x1, int y1, int x2, short pixel_color)
{
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1 > 639) x1 = 639;
	if (y1 > 479) y1 = 479;
	if (x2 > 639) x2 = 639;
	if (x1 < 0) x1 = 0;
	if (y1 < 0) y1 = 0;
	if (x2 < 0) x2 = 0;
	if (x1 > x2) SWAP(x1, x2);
	// line
	row = y1;
	for (col = x1; col <= x2; ++col) 
	{
		VGA_PIXEL(col, row, pixel_color);
	}
}

void VGA_Vline(int x1, int y1, int y2, short pixel_color)
{
	int row, col;

	/* check and fix box coordinates to be valid */
	if (x1 > 639) x1 = 639;
	if (y1 > 479) y1 = 479;
	if (y2 > 479) y2 = 479;
	if (x1 < 0) x1 = 0;
	if (y1 < 0) y1 = 0;
	if (y2 < 0) y2 = 0;
	if (y1 > y2) SWAP(y1, y2);
	// line
	col = x1;
	for (row = y1; row <= y2; row++) 
	{
		VGA_PIXEL(col, row, pixel_color);
	}
}

/* =====================================================================
function: VGA_circle ()
purpose	: Draw a filled circle on the VGA monitor
argument:
	cent_x: center of a circle, x-axis coordinate
	cent_y: center of a circle, y-axis coordinate
	min_r : minimum radius of a circle
	max_r : maximum radius of a circle
	pixel_color: Box color
reture	: Void
!!Caution
	It needs extern variable <vga_char_ptr>.
===================================================================== */
void VGA_circle(int cent_x, int cent_y, int min_r, int max_r, short pixel_color) 
{
	int row, col, xc, yc;
	int min_rsqr, max_rsqr;

	min_rsqr = min_r * min_r;
	max_rsqr = max_r * max_r;

	for (yc = -max_r; yc <= max_r; yc++)
		for (xc = -max_r; xc <= max_r; xc++)
		{
			col = xc;
			row = yc;
			if (col * col + row * row >= min_rsqr + min_r && col * col + row * row <= max_rsqr + max_r) {
				col = col + cent_x;
				row = row + cent_y;
				//check for valid 640x480
				if (col > 639) col = 639;
				if (row > 479) row = 479;
				if (col < 0) col = 0;
				if (row < 0) row = 0;
				VGA_PIXEL(col, row, pixel_color);
			}
		}
}

#endif // 