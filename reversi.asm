		.data
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
gameover:	.asciiz	"Game Over, Score is Black "
score:		.asciiz " : White "

		.text
init:		la   $t0, piecesPoss
		lw   $t1, maxPiecesNum
		li   $t2, -1
setInitColor:	sw   $t2, ($t0)			# -1
		addi $t1, $t1, -1
		addi $t0, $t0, 4
		bgtz $t1, setInitColor
		la   $t0, piecesPoss		#set first 4 pieces' color in array.
		li   $t2, 1			#1 for black
		sw   $t2, 108($t0)
		sw   $t2, 144($t0)
		li   $t2, 0			#0 for white
		sw   $t2, 112($t0)
		sw   $t2, 140($t0)
		lw   $s6, black
		lw   $s7, white
CalPixelOffset:	la   $t0, pixelsOffsets		#calculate offsets of all pixels in a circle, radius is 27
		li   $t6, 0
		li   $t1, 0
		li   $t3, 27
loop1:		li   $t2, 0
loop2:		sub  $t4, $t2, $t3
		sub  $t5, $t1, $t3
		mul  $t4, $t4, $t4
		mul  $t5, $t5, $t5
		add  $t4, $t4, $t5
		bgt  $t4, 729, nextnode 	#over the radius, nextnode
 		mul  $t5, $t2, 4		#else, calculate and store the offset
		mul  $t4, $t1, 2048
		add  $t4, $t4, $t5
		sw   $t4, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1		
nextnode:	addi $t2, $t2, 1
		ble  $t2, 54, loop2
		addi $t1, $t1, 1
		ble  $t1, 54, loop1
		sw   $t6, pixelsNum

drawBoard:	lw   $s0, baseAddress
		lw   $s1, baseOffset		#base offset.
		lw   $s4, numOPIC		#load the num of squares in column.
		addi $s1, $s1, 16384
		
drawRow:	lw   $s3, squareSize		#loop squareSize time, for draw continuous 55 row(the height of a square).		

drawSquares:	lw   $s2, numOPIR		#loop numOPIR to control the time of drawASquare in every single row.
		addi $s1, $s1, 32

drawSquare:	lw   $t0, yellow		#the yellow code
		lw   $t1, squareSize		#load the width of a square

drawRowInSquare:	add  $t2, $s0, $s1		#load the address which we are gonna fill a yellow pixel
			sw   $t0, ($t2)			#store the yellow code
			addi $s1, $s1, 4		#increase offset by num of bytes in a word
			addi $t1, $t1, -1		#decrease count of loop
			bgtz $t1, drawRowInSquare	#back to drawRowInSquare if didn't finish a horizontal pixels line of a square
			addi $s1, $s1, 32		#increase offset by num of bytes in a splitSize*byteOfOneWord(8*4)
			addi $s2, $s2, -1
			bgtz $s2, drawSquare		#back to drawSquare if already finish all squares in a row
			addi $s3, $s3, -1
			bgtz $s3, drawSquares		#back to drawSquares if a row of pixels has been drawn
			addi $s4, $s4, -1
			addi $s1, $s1, 16384		#addrIncOfRow, for the split between rows of squares(totalwidth*splitSize*bytesOfAWord).	
			bgtz $s4, drawRow


Main:		
#		li $t0, 1			#Test for fill all the squares
#ploop1:	li $t1, 1			
#ploop2:	jal	drawAWhitePiece
#		addi $t1, $t1, 1
#		ble  $t1, 8, ploop2
#		addi $t0, $t0, 1
#		ble  $t0, 8, ploop1
		la $s1, piecesPoss		#store address of piecesPoss array in Main process.
		li $t0, 4
		li $t1, 4
		jal drawABlackPiece
		li $t1, 5
		jal drawAWhitePiece
		li $t0, 5
		jal drawABlackPiece
		li $t1, 4
		jal drawAWhitePiece
		li $t7, 64
AutoPlayLoop:	li $t6, 1
		jal checkNeighbours
		jal calMaxProfit
		lw $t0, maxProfitRow
		lw $t1, maxProfitCol
		jal oneStep
		jal clearMaxProfit
		li $t6, 0
		jal checkNeighbours
		jal calMaxProfit
		lw $t0, maxProfitRow
		lw $t1, maxProfitCol
		jal oneStep
		jal clearMaxProfit
		addi $t7, $t7, -1
		bgtz $t7, AutoPlayLoop

return:		li $v0, 10			#syscall code of return
		syscall				#return


clearMaxProfit:	li $t6, 0
		sw $t6, maxProfit
		sw $t6, maxProfitRow
		sw $t6, maxProfitRow
		jr $ra

# Check all empty neighbour of white pieces
# args $t6 (color)
checkNeighbours: 	li $s5, 0
			addi $sp, $sp, -4
			sw $ra, ($sp)
			lw $s2, maxPiecesNum
			li $s3, 8
			li $s4, 0
checkNeighbourLoop:	la $s1, piecesPoss
			add $s1, $s1, $s5
			lw $t0, ($s1)
			beq  $t6, 1, checkNeighbourBlack
			bne  $t0, 1, checkNeighbourFinish
			b    checkNeighbourContinue
checkNeighbourBlack:	bne  $t0, 0, checkNeighbourFinish			
checkNeighbourContinue:	addi $t0, $s4, 9		#add fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
			div $t0, $s3
			mfhi $t1
			mflo $t0
			bnez $t1, checkNeighbourNormal
			li  $t1, 8
			addi $t0, $t0, -1
checkNeighbourNormal:	jal checkAround
checkNeighbourFinish:	addi $s5, $s5, 4
			addi $s2, $s2, -1
			addi $s4, $s4, 1
			bgtz $s2, checkNeighbourLoop
			lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra


# check empty neighbour around a piece
# args in $t0, $t1 (rownum, colnum)
checkAround:	la  $s1, piecesPoss 
		addi $sp, $sp, -4
		sw   $ra, ($sp)
		move $t3, $t1
		add $t2, $t0, 1			#x+1, y
		jal checkASquare
		add $t2, $t0, -1		#x-1, y
		jal checkASquare
		add $t3, $t1, 1			#x-1, y+1
		jal checkASquare
		add $t3, $t1, -1		#x-1, y-1
		jal checkASquare
		add $t2, $t0, 1			#x+1, y-1
		jal checkASquare
		move $t2, $t0			#x, y-1
		jal checkASquare
		add $t3, $t1, 1			#x, y+1
		jal checkASquare
		add $t2, $t0, 1			#x+1, y+1
		jal checkASquare
		lw  $ra, ($sp)
		addi $sp, $sp, 4
		jr  $ra

			
# check if a square is empty
# args in $t2, $t3 (rownum, colnum)
checkASquare:	blt $t2, 1, checkFinish		#boundary check
		blt $t3, 1, checkFinish
		bgt $t2, 8, checkFinish
		bgt $t3, 8, checkFinish
		mul $t4, $t2, 8
		add $t4, $t4, $t3
		addi $t4, $t4, -9		#minus fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
		mul $t4, $t4, 4
		add $t4, $t4, $s1
		lw $t5, ($t4)
		bgez $t5, checkFinish
		li $t5, 2			#2 for an empty neighbour but wait for calculate profit.
		sw $t5, ($t4)
checkFinish:	jr $ra


# Calculte profit in a specified step.
# args in $t0, $t1, $t6, (rownum, colnum, color)
# For every direction, Loop make sure there are consecutive black pieces in this direction.
# return this step's profit in $s5.
calOneStep:		la   $s1, piecesPoss
			addi $sp, $sp, -4
			sw $ra, ($sp)
			li   $s5, 0
			move $t2, $t0
			move $t3, $t1
#NorthWest
calNorthWest:		add $t2, $t0, -2
			blez $t2, calWest
			add $t3, $t1, -2
			blez $t3, calNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calNorthWestLoop:	add $t2, $t2, -1
			add $t3, $t3, -1
			jal checkPieceColor
			beq $t6, 1, calNorthWestBlack
			beq $t4, 1, calNorthWestInc
			beq $t4, 0, calNorthWestFinish
			b   calWest
calNorthWestBlack:	beq $t4, 0, calNorthWestInc
			beq $t4, 1, calNorthWestFinish
			b   calWest	
calNorthWestInc:	addi $t5, $t5, 1
			b   calNorthWestLoop
calNorthWestFinish:	add $s5, $s5, $t5

#West	
calWest:		add $t3, $t1, -2
			blez $t3, calNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calWestLoop:		add $t3, $t3, -1
			jal checkPieceColor
			beq $t6, 1, calWestBlack
			beq $t4, 1, calWestInc
			beq $t4, 0, calWestFinish
			b   calNorth
calWestBlack:		beq $t4, 0, calWestInc
			beq $t4, 1, calWestFinish
			b   calNorth	
calWestInc:		addi $t5, $t5, 1
			b   calWestLoop
calWestFinish:		add $s5, $s5, $t5

#North		
calNorth:		add $t2, $t0, -2
			blez $t2, calSouthWest
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calNorthLoop:		add $t2, $t2, -1
			jal checkPieceColor
			beq $t6, 1, calNorthBlack
			beq $t4, 1, calNorthInc
			beq $t4, 0, calNorthFinish
			b   calSouthWest
calNorthBlack:		beq $t4, 0, calNorthInc
			beq $t4, 1, calNorthFinish
			b   calSouthWest
calNorthInc:		addi $t5, $t5, 1
			b   calNorthLoop
calNorthFinish:		add $s5, $s5, $t5

#SouthWest
calSouthWest:		add $t3, $t1, -2
			blez $t3, calSouth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calSouthWestLoop:	add $t3, $t3, -1
			add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, calSouthWestBlack
			beq $t4, 1, calSouthWestInc
			beq $t4, 0, calSouthWestFinish
			b   calSouth
calSouthWestBlack:	beq $t4, 0, calSouthWestInc
			beq $t4, 1, calSouthWestFinish
			b   calSouth
calSouthWestInc:	addi $t5, $t5, 1
			b   calSouthWestLoop
calSouthWestFinish:	add $s5, $s5, $t5

#South
calSouth:		add $t2, $t0, 2
			bgt $t2, 8, calEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calSouthLoop:		add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, calSouthBlack
			beq $t4, 1, calSouthInc
			beq $t4, 0, calSouthFinish
			b   calEast
calSouthBlack:		beq $t4, 0, calSouthInc
			beq $t4, 1, calSouthFinish
			b   calEast
calSouthInc:		addi $t5, $t5, 1
			b   calSouthLoop
calSouthFinish:		add $s5, $s5, $t5

#East		
calEast:		add $t3, $t1, 2
			bgt $t3, 8, calFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calEastLoop:		add $t3, $t3, 1
			jal checkPieceColor
			beq $t6, 1, calEastBlack
			beq $t4, 1, calEastInc
			beq $t4, 0, calEastFinish
			b   calNorthEast
calEastBlack:		beq $t4, 0, calEastInc
			beq $t4, 1, calEastFinish
			b   calNorthEast
calEastInc:		addi $t5, $t5, 1
			b   calEastLoop
calEastFinish:		add $s5, $s5, $t5

#NorthEast
calNorthEast:		add $t2, $t0, -2
			blez $t2, calSouthEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calNorthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, -1
			jal checkPieceColor
			beq $t6, 1, calNorthEastBlack
			beq $t4, 1, calNorthEastInc
			beq $t4, 0, calNorthEastFinish
			b   calSouthEast
calNorthEastBlack:	beq $t4, 0, calNorthEastInc
			beq $t4, 1, calNorthEastFinish
			b   calSouthEast
calNorthEastInc:	addi $t5, $t5, 1
			b   calNorthEastLoop
calNorthEastFinish:	add $s5, $s5, $t5

#SouthEast		
calSouthEast:		add $t2, $t0, 2
			bgt $t2, 8, calFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
calSouthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, calSouthEastBlack
			beq $t4, 1, calSouthEastInc
			beq $t4, 0, calSouthEastFinish
			b   calFinish
calSouthEastBlack:	beq $t4, 0, calSouthEastInc
			beq $t4, 1, calSouthEastFinish
			b   calFinish
calSouthEastInc:	addi $t5, $t5, 1
			b   calSouthEastLoop
calSouthEastFinish:	add $s5, $s5, $t5

calFinish:		lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra
			

# Calculate Max profit in single step. 
#  As long as computer always represent White, 
#  this part we only consider self is white.
#  Add situation which current player is black.

calMaxProfit:		la  $s1, piecesPoss
			addi $sp, $sp, -4
			sw $ra, ($sp)
			lw  $s2, maxPiecesNum
			li  $s3, 8
			li  $s4, 0
calMaxProfitLoop:	lw  $t0, ($s1)
			bne  $t0, 2, calMaxProfitFinish
			li   $t0, -1
			sw   $t0, ($s1)			#restore the element value to -1 (empty)
			addi $t0, $s4, 9		#add fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
			div $t0, $s3
			mfhi $t1			#extract quotient(num of row to $t0)
			mflo $t0			#extract remainer(num of col to $t0)
			bnez $t1, calMaxProfitNormal
			li   $t1, 8
			addi $t0, $t0, -1
calMaxProfitNormal:	addi $sp, $sp, -4
			sw   $s1, ($sp)
			jal calOneStep
			lw   $s1, ($sp)
			addi $sp, $sp, 4
			lw   $t2, maxProfit
			ble  $s5, $t2, calMaxProfitFinish
			sw   $s5, maxProfit
			sw   $t0, maxProfitRow
			sw   $t1, maxProfitCol
calMaxProfitFinish:	addi $s1, $s1, 4
			addi $s2, $s2, -1
			addi $s4, $s4, 1
			bgtz $s2, calMaxProfitLoop
			lw $s5, maxProfit
			beqz $s5, calNoStep
			lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra

calNoStep:		lw $t0, maxPiecesNum
			li $t1, 0
			li $t2, 0
			la $t3, piecesPoss
calNumLoop:		lw $t4, ($t3)
			beqz $t4, calNumWhiteInc
			beq  $t4, 1 calNumBlackInc
			addi $t0, $t0, -1
			addi $t3, $t3, 4
			bgtz $t0, calNumLoop
			b    calNoStepFinish
calNumBlackInc:		addi $t1, $t1, 1
			addi $t0, $t0, -1
			addi $t3, $t3, 4
			bgtz $t0, calNumLoop
			b    calNoStepFinish
calNumWhiteInc:		addi $t2, $t2, 1
			addi $t0, $t0, -1
			addi $t3, $t3, 4
			bgtz $t0, calNumLoop
calNoStepFinish:	la $a0, gameover
			li $v0, 4
			syscall
			move $a0, $t1
			li $v0, 1
			syscall
			la $a0, score
			li $v0, 4
			syscall
			move $a0, $t2
			li $v0, 1
			syscall
			li $v0, 10
			syscall
			

# args in $t2, $t3 (rownum, colnum), return $t4
checkPieceColor:	li  $t4, -1
			blez $t2, checkPieceColorFinish
			bgt $t2, 8, checkPieceColorFinish
			blez $t3, checkPieceColorFinish
			bgt $t3, 8, checkPieceColorFinish
			mul $t4, $t2, 8
			add $t4, $t4, $t3
			addi $t4, $t4, -9
			mul $t4, $t4, 4
			add $t4, $t4, $s1
			lw  $t4, ($t4)
checkPieceColorFinish:	jr  $ra
						

# Draw a white piece on board
# args in $t0, $t1 (rownum, colnum)
drawAWhitePiece:	add $t2, $t0, -1
			mul $t2, $t2, 129024
			add $t2, $t2, 16384
			add $t3, $t1, -1
			mul $t3, $t3, 252
			add $t3, $t3, 32
			add $t2, $t2, $t3
			add $t2, $s0, $t2
			lw  $t3, pixelsNum
			la  $t4, pixelsOffsets
drawWhitePieceLoop:	lw  $t5, 0($t4)
			addi $t4, $t4, 4
			add $t6, $t2, $t5
			sw  $s7, ($t6)
			addi $t3, $t3, -1
			bgtz $t3, drawWhitePieceLoop
			mul  $t2, $t0, 8
			add  $t2, $t2, $t1
			addi $t2, $t2, -9
			mul  $t2, $t2, 4
			la  $t3, piecesPoss
			add $t2, $t2, $t3
			li  $t3, 0
			sw  $t3, ($t2)
			jr  $ra


# Draw a black piece on board
# args in $t0, $t1 (rownum, colnum)
drawABlackPiece:	add $t2, $t0, -1
			mul $t2, $t2, 129024		#address increament of a row of squares plus a row of split lines
			add $t2, $t2, 16384		#address increament of a row of split line
			add $t3, $t1, -1
			mul $t3, $t3, 252		#address increament of a col of squares plus a row of split lines
			add $t3, $t3, 32		#address increament of a col of split line
			add $t2, $t2, $t3
			add $t2, $s0, $t2
			lw  $t3, pixelsNum
			la  $t4, pixelsOffsets
drawBlackPieceLoop:	lw  $t5, 0($t4)
			addi $t4, $t4, 4
			add $t6, $t2, $t5
			sw  $s6, ($t6)
			addi $t3, $t3, -1
			bgtz $t3, drawBlackPieceLoop
			mul  $t2, $t0, 8
			add  $t2, $t2, $t1
			addi $t2, $t2, -9
			mul  $t2, $t2, 4
			la  $t3, piecesPoss
			add $t2, $t2, $t3
			li  $t3, 1
			sw  $t3, ($t2)
			jr  $ra

# Real one step on board
# args in $t0, $t1, $t6 (rownum, colnum, color)
oneStep:           	addi $sp, $sp, -4
			sw  $ra, ($sp)
			move $s4, $t6
			jal checkAvailable
			beqz $s5, cannotPlace
			bnez $s4, oneStepBlack1
			jal drawAWhitePiece
			b oneStepContinue1
oneStepBlack1:		jal drawABlackPiece
oneStepContinue1:	la   $s2, waitPiecesPoss
			li   $s3, 8
oneStepReversiLoop:	lw  $t0, ($s2)
			div $t0, $s3
			mfhi $t1
			mflo $t0
			bnez $t1, oneStepNormal
			li   $t1, 8
			addi $t0, $t0, -1
oneStepNormal:		bnez $s4, oneStepBlack2
			jal drawAWhitePiece
			b oneStepContinue2
oneStepBlack2:		jal drawABlackPiece			
oneStepContinue2:	addi $s2, $s2, 4
			addi $s5, $s5, -1
			bgtz $s5, oneStepReversiLoop
cannotPlace:		lw  $ra, ($sp)
			addi $sp, $sp, 4
			jr  $ra


# This function is similar to calOneStep to great extent, but this plus a 
# instruction sets to store the opponent pieces which possibly be changed.
# args in $t0, $t1, $t6 (rownum, colnum, color)
# For every direction, Loop make sure there are consecutive black pieces in this direction.
# return this step's profit in $s5.
checkAvailable:		la   $s1, piecesPoss
			la   $s2, waitPiecesPoss
			addi $sp, $sp, -4
			sw   $ra, ($sp)
			li   $s5, 0
			move $t2, $t0
			move $t3, $t1
#NorthWest
checkNorthWest:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -2
			blez $t2, checkWest
			add $t3, $t1, -2
			blez $t3, checkNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthWestLoop:	add $t2, $t2, -1
			add $t3, $t3, -1
			jal checkPieceColor
			beq $t6, 1, checkNorthWestBlack
			beq $t4, 1, checkNorthWestInc
			beq $t4, 0, checkNorthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkWest
checkNorthWestBlack:	beq $t4, 0, checkNorthWestInc
			beq $t4, 1, checkNorthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkWest
checkNorthWestInc:	addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthWestLoop
checkNorthWestFinish:	add $s5, $s5, $t5

#West	
checkWest:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, -2
			blez $t3, checkNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkWestLoop:		add $t3, $t3, -1
			jal checkPieceColor
			beq $t6, 1, checkWestBlack
			beq $t4, 1, checkWestInc
			beq $t4, 0, checkWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorth
checkWestBlack:		beq $t4, 0, checkWestInc
			beq $t4, 1, checkWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorth
checkWestInc:		addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkWestLoop
checkWestFinish:	add $s5, $s5, $t5

#North		
checkNorth:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -2
			blez $t2, checkSouthWest
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthLoop:		add $t2, $t2, -1
			jal checkPieceColor
			beq $t6, 1, checkNorthBlack
			beq $t4, 1, checkNorthInc
			beq $t4, 0, checkNorthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthWest
checkNorthBlack:	beq $t4, 0, checkNorthInc
			beq $t4, 1, checkNorthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthWest
checkNorthInc:		addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthLoop
checkNorthFinish:	add $s5, $s5, $t5

#SouthWest
checkSouthWest:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, -2
			blez $t3, checkSouth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthWestLoop:	add $t3, $t3, -1
			add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, checkSouthWestBlack
			beq $t4, 1, checkSouthWestInc
			beq $t4, 0, checkSouthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouth
checkSouthWestBlack:	beq $t4, 0, checkSouthWestInc
			beq $t4, 1, checkSouthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouth
checkSouthWestInc:	addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthWestLoop
checkSouthWestFinish:	add $s5, $s5, $t5

#South
checkSouth:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, 2
			bgt $t2, 8, checkEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthLoop:		add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, checkSouthBlack
			beq $t4, 1, checkSouthInc
			beq $t4, 0, checkSouthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkEast
checkSouthBlack:	beq $t4, 0, checkSouthInc
			beq $t4, 1, checkSouthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkEast
checkSouthInc:		addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthLoop
checkSouthFinish:	add $s5, $s5, $t5

#East		
checkEast:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, 2
			bgt $t3, 8, checkAvailableFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkEastLoop:		add $t3, $t3, 1
			jal checkPieceColor
			beq $t6, 1, checkEastBlack
			beq $t4, 1, checkEastInc
			beq $t4, 0, checkEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorthEast
checkEastBlack:		beq $t4, 0, checkEastInc
			beq $t4, 1, checkEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorthEast
checkEastInc:		addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkEastLoop
checkEastFinish:	add $s5, $s5, $t5

#NorthEast
checkNorthEast:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -2
			blez $t2, checkSouthEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, -1
			jal checkPieceColor
			beq $t6, 1, checkNorthEastBlack
			beq $t4, 1, checkNorthEastInc
			beq $t4, 0, checkNorthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthEast
checkNorthEastBlack:	beq $t4, 0, checkNorthEastInc
			beq $t4, 1, checkNorthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthEast
checkNorthEastInc:	addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthEastLoop
checkNorthEastFinish:	add $s5, $s5, $t5

#SouthEast		
checkSouthEast:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, 2
			bgt $t2, 8, checkAvailableFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, 1
			jal checkPieceColor
			beq $t6, 1, checkSouthEastBlack
			beq $t4, 1, checkSouthEastInc
			beq $t4, 0, checkSouthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkAvailableFinish
checkSouthEastBlack:	beq $t4, 0, checkSouthEastInc
			beq $t4, 1, checkSouthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkAvailableFinish
checkSouthEastInc:	addi $t5, $t5, 1
			mul $s3, $t2, 8
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthEastLoop
checkSouthEastFinish:	add $s5, $s5, $t5

checkAvailableFinish:	lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra
