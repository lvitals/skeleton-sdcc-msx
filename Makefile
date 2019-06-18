CC = sdcc
ASM = sdasz80
PLATFORM = -mz80

MACHINE = Philips_NMS_8255

EMULATOR = openmsx -machine $(MACHINE) -ext msxdos2 -diska emulation/disk/ -script emulation/boot.tcl

STARTUPDIR = startups
INCLUDEDIR = includes
LIBDIR = libs
SRCDIR = src

# See startup files for the correct ADDR_CODE and ADDR_DATA
# 0x0107 to use crt0msx_msxdos.s
# 0x0178 to use crt0msx_msxdos_advanced.s

CRT0 = crt0msx_msxdos.s
ADDR_CODE = 0x0107

# CRT0 = crt0msx_msxdos_advanced.s
# ADDR_CODE = 0x0178

ADDR_DATA = 0

VERBOSE = -V
CCFLAGS = $(VERBOSE) $(PLATFORM) --code-loc $(ADDR_CODE) --data-loc $(ADDR_DATA) \
          --no-std-crt0 --opt-code-size --out-fmt-ihx
OBJECTS = $(CRT0) putchar.s getchar.s dos.s conio.c
SOURCES = main.c
OUTFILE = main.com

.PHONY: all compile build clean emulator

all: clean compile build

compile: $(OBJECTS) $(SOURCES)

$(CRT0):
		@echo "Compiling $(CRT0)"
		@$(ASM) -o $(notdir $(@:.s=.rel)) $(STARTUPDIR)/$(CRT0)
%.s:
		@echo "Compiling $@"
		@[ -f $(LIBDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(LIBDIR)/$@ || true
		@[ -f $(SRCDIR)/$@ ] && $(ASM) -o $(notdir $(@:.s=.rel)) $(SRCDIR)/$@ || true
%.c:
		@echo "Compiling $@"
		@[ -f $(LIBDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(LIBDIR)/$@ || true
		@[ -f $(SRCDIR)/$@ ] && $(CC) $(VERBOSE) $(PLATFORM) -I$(INCLUDEDIR) -c -o $(notdir $(@:.c=.rel)) $(SRCDIR)/$@ || true

$(SOURCES):
		$(CC) -I$(INCLUDEDIR) $(CCFLAGS) \
				$(addsuffix .rel, $(basename $(notdir $(OBJECTS)))) \
				$(SRCDIR)/$(SOURCES)

build: main.ihx
		@echo "Building $(OUTFILE)..."
		objcopy -I ihex main.ihx -O binary emulation/disk/${OUTFILE}
		@echo "Done."

clean:
		@echo "Cleaning ...."
		rm -f *.asm *.bin *.cdb *.ihx *.lk *.lst *.map *.mem *.omf *.rst *.rel *.sym *.noi *.hex *.lnk *.dep
		rm -f emulation/disk/$(OUTFILE)

test:
		$(build)
		mkdir -p ~/.openMSX/share/systemroms/
		cp emulation/machines/$(MACHINE)/* ~/.openMSX/share/systemroms/
		cp emulation/extensions/msxdos22/* ~/.openMSX/share/systemroms/
		$(EMULATOR)
