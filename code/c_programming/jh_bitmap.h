#ifndef __JHBITMAP_H_
#define __JHBITMAP_H_


/* struct for bit map */
typedef struct tage_bmp {
	int width;
	int height;
	alt_u16* pdata;
}bmp_type;

/* =====================================================================
function: fskip ()
purpose	: Skip n bypte of a file 
argument:
	fp: file pointer 
	nbyte: byte number
reture	: Void
===================================================================== */
void fskip(FILE* fp, int nbyte) {
	int i;
	for (i = 0; i < nbyte; i++)
		fgetc(fp);
}

/* =====================================================================
function: fget8 ()
purpose	: Get a 8 bit-type data from a file
argument:
	fp: file pointer
reture	: A 8 bit-type data from a file
===================================================================== */
alt_u8 fget8(FILE* fp) {
	return((alt_u8)fgetc(fp));
}

/* =====================================================================
function: fget16 ()
purpose	: Get a 16 bit data from a file
argument:
	fp: file pointer
reture	: A 16 bit data from a file
===================================================================== */
alt_u16 fget16(FILE* fp) {
	alt_u16 b0, b1, r;

	b0 = (alt_u16)fgetc(fp);
	b1 = (alt_u16)fgetc(fp);
	r = (b1 << 8) + b0;
	return(r);
}

/* =====================================================================
function: fget32 ()
purpose	: Get a 32 bit data from a file
argument:
	fp: file pointer
reture	: A 32 bit data from a file
===================================================================== */
alt_u32 fget32(FILE* fp) {
	alt_u32 b0, b1, b2, b3, r;

	b0 = (alt_u32)fgetc(fp);
	b1 = (alt_u32)fgetc(fp);
	b2 = (alt_u32)fgetc(fp);
	b3 = (alt_u32)fgetc(fp);
	r = (b3 << 24) + (b2 << 16) + (b1 << 8) + b0;
	return(r);
}

#endif // !jh_bitmap.h