# Skeleton C project for MSX
Will create a "hello world" program running on MSX Z80 platform and emulated hardware. Following packages are required:

## Building and Installation

You'll need the following dependencies:
* build-essential
* binutils
* sdcc
* openmsx

```
sudo apt-get install build-essential binutils sdcc openmsx
```

## Compiling

```
make all      ;Compile and build
make compile  ;Just compile the project
make build    ;Build the final file (ROM|COM)
make emulator ;Launch the final file with openMSX
```

Check the makefile to select the correct startup file (ROM/COM). Current supported startup list:

- ROM 16kb (init: 0x4000)
- ROM 16kb (init: 0x8000)
- ROM 32Kb (init: 0x4000)
- MSX-DOS COM file (simple main)
- MSX-DOS COM file (main with arguments)
