# 'data_directive.asm' includes the pre-defined data directive codes.
#		.data

#user_input
newLine:	.asciiz "\n"
promtCoor:	.asciiz "\nPlease enter a board coordinate (starting with a letter): "
invalidInput:	.asciiz "\nInvalid coordinates. please try again.\n"
coordinates:	.asciiz "YX"
AIMoveMsg:
		.asciiz "\nAI's last move was: "
userMoveMsg:	
		.asciiz "\nYour last move was: "
illegalMoveOccupiedMsg:
		.asciiz "\nIllegal move. The chosen coordinate is occupied. Please retry.\n"		
illegalMoveNoProfitMsg:
		.asciiz "\nIllegal move. The chosen coordinate will not flip any piece. You must move to flip at least one piece when flippable piece(s) exists.\n"
WelcomeMsg:	.asciiz "Welcome to Reversi by Team Ex-Caliber.\nYou will play as the black pieces against the AI.\nReference the game manual to set up the game board and row/column labels\nusing the bitmap display in order to play, as well as for gameplay instructions.\nGood luck!\n" 
compWin:	.asciiz "\nAI wins!"
userWin:	.asciiz "\nUser wins!"
tie:		.asciiz "\nTied game!"
endEarly:	.asciiz "\nThere are no moves for either player. The game ends early."

		.align   2
red:		.word	0x00FF0000
yellow:		.word	0x00C75B12
black:		.word	0x00202020
white:		.word	0x00FFFFFF
squareSize:	.word	48
splitSize:	.word	8
addrIncOfRow:	.word	16384			#address increment of a row of split line
addrIncOfCol:	.word	32			#address increment of a col of split line
addrIncOfRSPS:	.word	114688			#address increment of a row of squares plus a row of split lines
addrIncOfCSPS:	.word	224			#address increment of a col of squares plus a row of split lines
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
turntoblack:	.asciiz	"\nWhite (AI) has no more moves, switch to User.\n"
turntowhite:	.asciiz	"\nBlack (User) has no more moves, switch to AI.\n"
gameover:	.asciiz	"\nGame Over, Score is Black "
score:		.asciiz " : White "
labelA:		.asciiz "src/Labels/A.bmp"
labelB:		.asciiz "src/Labels/B.bmp"
labelC:		.asciiz "src/Labels/C.bmp"
labelD:		.asciiz "src/Labels/D.bmp"
labelE:		.asciiz "src/Labels/E.bmp"
labelF:		.asciiz "src/Labels/F.bmp"
labelG:		.asciiz "src/Labels/G.bmp"
labelH:		.asciiz "src/Labels/H.bmp"
label1:		.asciiz "src/Labels/1.bmp"
label2:		.asciiz "src/Labels/2.bmp"
label3:		.asciiz "src/Labels/3.bmp"
label4:		.asciiz "src/Labels/4.bmp"
label5:		.asciiz "src/Labels/5.bmp"
label6:		.asciiz "src/Labels/6.bmp"
label7:		.asciiz "src/Labels/7.bmp"
label8:		.asciiz "src/Labels/8.bmp"
readbuffer: 	.byte  0:145
		.align 2
row_labels:	.word	labelA
		.word   labelB
		.word   labelC
		.word   labelD
		.word   labelE
		.word   labelF
		.word   labelG
		.word   labelH
col_labels:	.word   label1
		.word   label2
		.word   label3
		.word   label4
		.word   label5
		.word   label6
		.word   label7
		.word   label8
displaysize:	.word   512 	# display size
