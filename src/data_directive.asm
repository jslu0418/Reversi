# 'data_directive.asm' includes the pre-defined data directive codes.
#		.data

#user_input
promtCoor:	.asciiz "\nPlease enter a board loaction (starting with a letter): "
invalidInput:	.asciiz "\nInvalid coordinates. please try again.\n"
coordinates:	.asciiz "YX"
		.align   2	
red:		.word	0x00FF0000
yellow:		.word	0x00FFFF00
black:		.word	0x00202020
white:		.word	0x00FFFFFF
squareSize:	.word	55
splitSize:	.word	8
addrIncOfRow:	.word	16384			#address increment of a row of split line
addrIncOfCol:	.word	32			#address increment of a col of split line
addrIncOfRSPS:	.word	129024			#address increment of a row of squares plus a row of split lines
addrIncOfCSPS:	.word	252			#address increment of a col of squares plus a row of split lines
numOPIR:	.word	8			#num of squares in row
numOPIC:	.word	8			#num of squares in column
baseAddress:	.word	0x10040000
baseOffset:	.word	0
pixelsOffsets:	.word   0:2375 			#num of pixels in a piece(a circle)
pixelsNum:	.word	2375			#Forge num, will be replaced.
piecesPoss:	.word	0:64			#array of every pieces on board(record the color)
waitPiecesPossPoint:	.word 0x00000000	#temporarily store waitPiecesPossPoint's address
waitPiecesPoss:	.word   0:64			#array of pieces possibly prepared to change color(use 0-63 to save co-ordinate
maxPiecesNum:	.word	64			#num of max pieces
maxProfit:	.word   0			#store the max profit from calculation
maxProfitRow:	.word	0
maxProfitCol:	.word	0
turntoblack:	.asciiz	"White has no more step, turn to Black\n"
turntowhite:	.asciiz	"Black has no more step, turn to White\n"
gameover:	.asciiz	"Game Over, Score is Black "
score:		.asciiz " : White "
		.align 2
