
#ifndef __JHMOUSE_H_
#define __JHMOUSE_H_

extern volatile alt_u32* vga_char_ptr;		// Resistor address of VGA_charater in hardare
extern volatile alt_u32* vga_pixel_ptr;		// Resistor address of VGA_pixel in hardare
extern pthread_mutex_t vga_pixel_lock;

int cursor_x, cursor_y;

/* struct for mouse movement */
typedef struct mouse_move
{
	int lbtn;	// 1: left button pressed, 0: unpreesed
	int rbtn;	// 1: right button pressed, 0: unpressed
	alt_8 xmove;	// x-axis movement (delta x)
	alt_8 ymove;	// y-axis movement (delta y)
}mouse_mv_type;

/* =====================================================================
function: VGA_rd_pix ()
purpose	: Read memory from video SRAM 
argument:
	x: x-axis coordinate, (16 bit and consecutive address format)
	y: y-axis coordinate
reture	: color
!!Caution
	It needs extern variable <vga_pixel_ptr>.
	Mutex luck for <vga_pixel_ptr>
===================================================================== */
alt_u16 VGA_rd_pix(x, y)
{
	alt_u16 color;
	alt_u32 offset;
	alt_u32 color_two_pixel;

	offset = ((y) * 640 + (x));
	pthread_mutex_lock(&vga_pixel_lock);
	color_two_pixel = *(vga_pixel_ptr + (offset >> 1));	// pointer load 4 byte (=two pixels information)
	pthread_mutex_unlock(&vga_pixel_lock);
	if (offset % 2) { 		// odd pixel
		color = (alt_u16)(color_two_pixel>>16);
	}
	else{					// even pixel
		color = (alt_u16)color_two_pixel;
	}

	return color;
}

/* =====================================================================
function: VGA_wr_bmp ()
purpose	: Write bitmap to video SRAM (display VGA) 
argument:
	x: x-axis coordinate, (16 bit and consecutive address format)
	y: y-axis coordinate
	bmp: pointer to the bitmap structure
	trans: whether to draw bitmap or save previous image
		0: draw black pixels in the backgound bitmap 
		1: not draw black pixels in the background bitmap
reture	: Void
!!Caution
	It needs extern variable <vga_pixel_ptr>.
	Mutex luck for <vga_pixel_ptr>
===================================================================== */
void VGA_wr_bmp(int x, int y, bmp_type *bmp, int tran)
{
	int i, j;
	alt_u16 color;
	for (j = 0; j < bmp->height; j++) {
		for (i = 0; i < bmp->width; i++) {
			color = bmp->pdata[(j * bmp->width) + i];
			if (tran == 0 || color != 0)
				VGA_PIXEL(i + x, j + y, color);
		} // end for loop i
	} // end for loop j
}

/* =====================================================================
function: VGA_rd_bmp ()
purpose	: Read a bitmap from video SRAM starting at (x,y)
argument:
	x: x-axis coordinate, (16 bit and consecutive address format)
	y: y-axis coordinate
	bmp: pointer to the bitmap structure
return	: Void
!!Caution
	It needs extern variable <vga_pixel_ptr>.
===================================================================== */
void VGA_rd_bmp(int x, int y, bmp_type* bmp)
{
	int i, j;
	alt_u16 color;

	for (j = 0; j < bmp->height; j++) {
		for (i = 0; i < bmp->width; i++) {
			color = VGA_rd_pix(i+x,j+y);
			bmp->pdata[(j * bmp->width) + i] = color;
		} // end for loop i
	} // end for loop j
}

/* =====================================================================
function: VGA_move_bmp ()
purpose	: Move bmp image from (xold,yold) to (xnew, ynew)
argument:
	xold: x-axis coordinate before moving, (16 bit and consecutive address format)
	yold: y-axis coordinate before moving
	below: A image covered by a 'bmp' at (xold, yold)
	xnew: x-axis coordinate after moving, (16 bit and consecutive address format)
	ynew: y-axis coordinate after moving
	bmp: pointer to the bitmap structure
return	: Void
!!Caution
	It needs extern variable <vga_pixel_ptr>.
===================================================================== */
void VGA_move_bmp(int xold, int yold, bmp_type* below, 
				  int xnew, int ynew, bmp_type* bmp)
{
	VGA_wr_bmp(xold, yold, below, 0);	// The imaage covered by 'bmp' is ploted 
	VGA_rd_bmp(xnew, ynew, below);		// Save new image that will be covered by the moved 'bmp'
	VGA_wr_bmp(xnew, ynew, bmp, 1);		// Plot 'bmp' in new position.
}

/* =====================================================================
function: Mouse_init ()
purpose	: At first, it displays a mouse pointer 
argument:
	x: x-axis coordinate  (16 bit and consecutive address format)
	y: y-axis coordinate 
	mouse: Bitmap image of a mouse
	below: A image covered by a 'bmp' at (xold, yold)
return	: 
	0: Operation
	-1: illegal operation
!!Caution
	It needs extern variable <vga_pixel_ptr>.
===================================================================== */
void Mouse_init(int x, int y, bmp_type *MOUSE_BMP, bmp_type *below)
{
	VGA_rd_bmp(x, y, below);
	VGA_wr_bmp(x, y, MOUSE_BMP, 1);
}


int Mouse_move(int fd_mouse, bmp_type* MOUSE_BMP, int xold, int yold, bmp_type *below, int *xnew, int *ynew, mouse_mv_type *mv)
{
	int bytes;
	unsigned char data[3];

	// Read Mouse     
	bytes = read(fd_mouse, data, sizeof(data));

	if (bytes > 0){
		mv->lbtn = data[0] & 0x1;
		mv->rbtn = data[0] & 0x2;
		mv->xmove = data[1];
		mv->ymove = data[2];
		
		*xnew = xold + mv->xmove;	
		if (*xnew > (639 - MOUSE_BMP->width))
			*xnew = 639 - MOUSE_BMP->width;
		if (*xnew < 0)
			*xnew = 0;
		*ynew = yold - mv->ymove;	// ymove is reversed 
		if (*ynew > (479 - MOUSE_BMP->height))
			*ynew = 479 - MOUSE_BMP->height;
		if (*ynew < 0)
			*ynew = 0;
		VGA_move_bmp(xold, yold, below, *xnew, *ynew, MOUSE_BMP);
		return(1);
	}
	else 
		return (0);
}

#endif // !jh_mouse