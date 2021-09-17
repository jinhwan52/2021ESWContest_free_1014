#
TARGET = vga_hps_jh

#
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm

build: $(TARGET)
$(TARGET): main.o 
	$(CC) $(LDFLAGS)   $^ -o $@	-lpthread		# $^ is names of all the prerequisites , $@ is 'now target name'
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@			# $< is the name of the fist prerequisite.

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 

main.o: main.c jh_VGA.h jh_general.h jh_bitmap.h jh_mouse.h \
jh_init.h 