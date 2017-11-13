# 'data_directive.asm' includes the pre-defined data directive codes.
#		.data

#user_input
promtCoor:	.asciiz "\nPlease enter a board loaction (starting with a letter): "
invalidInput:	.asciiz "\nInvalid coordinates. please try again.\n"
coordinates:	.asciiz "YX"
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
turntoblack:	.asciiz	"White has no more step, turn to Black\n"
turntowhite:	.asciiz	"Black has no more step, turn to White\n"
gameover:	.asciiz	"Game Over, Score is Black "
score:		.asciiz " : White "
labelA:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\A.bmp"
labelB:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\B.bmp"
labelC:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\C.bmp"
labelD:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\D.bmp"
labelE:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\E.bmp"
labelF:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\F.bmp"
labelG:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\G.bmp"
labelH:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\H.bmp"
label1:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\1.bmp"
label2:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\2.bmp"
label3:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\3.bmp"
label4:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\4.bmp"
label5:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\5.bmp"
label6:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\6.bmp"
label7:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\7.bmp"
label8:		.asciiz "C:\\Users\\jxl173630\\Downloads\\Reversi\\src\\Labels\\8.bmp"
# labelA:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/A.bmp"
# labelB:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/B.bmp"
# labelC:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/C.bmp"
# labelD:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/D.bmp"
# labelE:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/E.bmp"
# labelF:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/F.bmp"
# labelG:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/G.bmp"
# labelH:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/H.bmp"
# label1:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/1.bmp"
# label2:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/2.bmp"
# label3:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/3.bmp"
# label4:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/4.bmp"
# label5:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/5.bmp"
# label6:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/6.bmp"
# label7:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/7.bmp"
# label8:		.asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/Reversi/src/Labels/8.bmp"
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
