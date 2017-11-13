# Reversi
A team project repository for 3340
## Usage
This program needs to be run under original Mars4_5.jar. And it uses bitmap display in the tools' menu to show the board. Before starting this program, set the bitmap's parameter to (unit width and height to 1, display width and height to 512, and base address to 0x10040000 (heap data). Remember to connect to MIPS.
## Notes
In the first three lines of reversi.asm, comment the second line if you are using Unix or Linux. Otherwise comment the third line. In both scenario you may need to customize the lables files' paths in data_directive_win.asm or data_directive.asm (depends on which file you will use).
