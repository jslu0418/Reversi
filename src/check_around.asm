# 'check_around.asm' include three procedures which are used to
#      check possible squares which can be put next step on.
#
# checkNeighbours
# chechAround
# checkASquare
# checkPieceColor

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
			lw $t0, ($s1)                   #$t6 is in-parameter of this subroutine. Check whether it is white or black then put corresponding value in $t0
			beq  $t6, 1, checkNeighbourBlack
			bne  $t0, 1, checkNeighbourFinish
			b    checkNeighbourContinue
checkNeighbourBlack:	bne  $t0, 0, checkNeighbourFinish

checkNeighbourContinue:	addi $t0, $s4, 9		#add fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
			div $t0, $s3
			mfhi $t1
			mflo $t0
			bnez $t1, checkNeighbourNormal  #if y is 0, use following two instruction to let y = 8 and x = x-1
			li  $t1, 8
			addi $t0, $t0, -1
checkNeighbourNormal:	jal checkAround                 #invoke subroutine to find neighbour empty place of One specified piece.
checkNeighbourFinish:	addi $s5, $s5, 4
			addi $s2, $s2, -1
			addi $s4, $s4, 1
			bgtz $s2, checkNeighbourLoop
			lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra                          #quit from this subroutine


# check empty neighbour around a piece
# args in $t0, $t1 (rownum, colnum)
checkAround:	la  $s1, piecesPoss
		addi $sp, $sp, -4
		sw   $ra, ($sp)
		move $t3, $t1
		add $t2, $t0, 1			#x+1, y
		jal checkASquare                #check square's status in ($t2, $t3)
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
		jr  $ra                         #quit from this subroutine


# check if a square is empty
# args in $t2, $t3 (rownum, colnum)
checkASquare:	blt $t2, 1, checkFinish		#boundary check
		blt $t3, 1, checkFinish
		bgt $t2, 8, checkFinish
		bgt $t3, 8, checkFinish
		sll $t4, $t2, 3
		add $t4, $t4, $t3
		addi $t4, $t4, -9		#minus fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
		sll $t4, $t4, 2
		add $t4, $t4, $s1
		lw $t5, ($t4)
		bgez $t5, checkFinish
		li $t5, 2			#2 for an empty neighbour but wait for calculate profit.
		sw $t5, ($t4)
checkFinish:	jr $ra


# args in $t2, $t3 (rownum, colnum), return $t4
checkPieceColor:	li  $t4, -1
			blez $t2, checkPieceColorFinish         #boundary check
			bgt $t2, 8, checkPieceColorFinish
			blez $t3, checkPieceColorFinish
			bgt $t3, 8, checkPieceColorFinish
			sll $t4, $t2, 3
			add $t4, $t4, $t3
			addi $t4, $t4, -9
			sll $t4, $t4, 2
			add $t4, $t4, $s1
			lw  $t4, ($t4)
checkPieceColorFinish:	jr  $ra

