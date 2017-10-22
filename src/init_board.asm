# 'init_board.asm' defines the procedure that draw the initial board.
#		.text
init_board:	addi $sp, $sp, -16
		sw   $s1, 12($sp)
		sw   $s2, 8($sp)
		sw   $s3, 4($sp)
		sw   $s4, ($sp)
		la   $t0, piecesPoss
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
 		sll  $t5, $t2, 2		#else, calculate and store the offset
		sll  $t4, $t1, 11
		add  $t4, $t4, $t5
		sw   $t4, ($t0)
		addi $t0, $t0, 4
		addi $t6, $t6, 1
nextnode:	addi $t2, $t2, 1                #increase the coordinate y
		ble  $t2, 54, loop2             # back to loop2 if y <= 54
		addi $t1, $t1, 1                #increase the coordinate x
		ble  $t1, 54, loop1             # back to loop1 if x <= 54
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

drawRowInSquare:add  $t2, $s0, $s1		#load the address which we are gonna fill a yellow pixel
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
		bgtz $s4, drawRow               #back to drawRow if didn't finish all rows of squares
		lw   $s1, 12($sp)
		lw   $s2, 8($sp)
		lw   $s3, 4($sp)
		lw   $s4, ($sp)
		addi $sp, $sp, 16
		jr   $ra			#back to main
