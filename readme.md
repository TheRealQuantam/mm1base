# Mega Man 1 Base

Fork of the [Mega Man 1 Disassembly] (https://github.com/TheRealQuantam/mm1dasm/) with added features to make it a better base for new Mega Man romhacks.

Currently implemented new features:
- Conversion to MMC3
    - 2 swappable 8 KB PRG banks
    - Programmable scanline IRQ for special effects
- Drastically reorganized ROM structure
    - ROM size expanded to 256 KB
    - Core gameplay loop, enemy handlers, and boss handlers broken out into their own 8 KB banks, each with 2-4 KB free space for new code to be added
    - New ROM structure reduces the number of bank swaps per frame, slightly reducing lag
	- __NOTE__: Because of the drastic reorganization many things are in different places than in the original game ROM. This means most patches for the original ROM will __not__ work without modification.

This project is still experimental and further changes are expected, as well as bug fixes if bugs are discovered.

Features to be added in the future:
- Built-in lag reduction, including incorporation of mm1spritelag
- Built-in mm1ft for FamiTracker music support

# Building
This disassembly is for the [cc65 toolchain](https://cc65.github.io/), and requires make (e.g. for Windows: [MinGW](https://sourceforge.net/projects/mingw/)). Banks 0-3, as well as the level data portion of banks 4/5, are taken from a copy of the original game ROM. From the command line:
- US: `make BASE_ROM=path_to_original_mm_rom us`
- Japan: `make BASE_ROM=path_to_original_rm_rom japan`

Rest of readme to be written.
