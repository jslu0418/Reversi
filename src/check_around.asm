# 'check_around.asm' include three procedures which are used to
#      check possible squares which can be put next step on.
#
# checkNeighbours
# chechAround
# checkASquare
# checkPieceColor

# Check all empty neighbour of white pieces
# args $a2 (color)
checkNeighbours: 	li $s5, 0
			addi $sp, $sp, -24
			sw $ra, ($sp)
			sw $s1, 4($sp)
			sw $s2, 8($sp)
			sw $s3, 12($sp)
			sw $s4, 16($sp)
			sw $s5, 20($sp)
			lw $s2, maxPiecesNum
			li $s3, 8
			li $s4, 0
checkNeighbourLoop:	la $s1, piecesPoss
			add $s1, $s1, $s5
			lw  $t0, ($s1)                   #$a0 is in-parameter of this subroutine. Check whether it is white or black then put corresponding value in $t0
			beq  $a2, 1, checkNeighbourBlack
			bne  $t0, 1, checkNeighbourFinish
			b    checkNeighbourContinue
checkNeighbourBlack:	bne  $t0, 0, checkNeighbourFinish

checkNeighbourContinue:	addi $t0, $s4, 0		#add fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
			div $t0, $s3
			mfhi $a1
			mflo $a0
			#bnez $t1, checkNeighbourNormal  #if y is 0, use following two instruction to let y = 8 and x = x-1
			#li  $t1, 8
			#addi $t0, $t0, -1
checkNeighbourNormal:	jal checkAround                 #invoke subroutine to find neighbour empty place of One specified piece.
checkNeighbourFinish:	addi $s5, $s5, 4
			addi $s2, $s2, -1
			addi $s4, $s4, 1
			bgtz $s2, checkNeighbourLoop
			lw $ra, ($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $s5, 20($sp)
			addi $sp, $sp, 24
			jr $ra                          #quit from this subroutine


# check empty neighbour around a piece
# args in $a0, $a1 (rownum, colnum)
checkAround:	la  $s1, piecesPoss
		addi $sp, $sp, -4
		sw   $ra, ($sp)
		move $t0, $a0
		move $t1, $a1
		add $a0, $t0, 1			#x+1, y
		jal checkASquare                #check square's status in ($t2, $t3)
		add $a0, $t0, -1		#x-1, y
		move $a1, $t1
		jal checkASquare
		add $a1, $t1, 1			#x-1, y+1
		add $a0, $t0, -1
		jal checkASquare
		add $a1, $t1, -1		#x-1, y-1
		add $a0, $t0, -1
		jal checkASquare
		add $a0, $t0, 1			#x+1, y-1
		jal checkASquare
		move $a0, $t0			#x, y-1
		add $a1, $t1, -1
		jal checkASquare
		add $a1, $t1, 1			#x, y+1
		move $a0, $t0
		jal checkASquare
		add $a0, $t0, 1			#x+1, y+1
		add $a1, $t1, 1
		jal checkASquare
		lw  $ra, ($sp)
		addi $sp, $sp, 4
		jr  $ra                         #quit from this subroutine


# check if a square is empty
# args in $a0, $a1 (rownum, colnum)
checkASquare:	blt $a0, 0, checkFinish		#boundary check
		blt $a1, 0, checkFinish
		bgt $a0, 7, checkFinish
		bgt $a1, 7, checkFinish
		sll $a0, $a0, 3
		add $a0, $a0, $a1
		#addi $t4, $t4, -9		#minus fixed value,  cuz 1*8+1=9 and (1,1) is first element of array.
		sll $a0, $a0, 2
		add $a0, $a0, $s1
		lw  $a1, ($a0)
		bgez $a1, checkFinish
		li $a1, 2			#2 for an empty neighbour but wait for calculate profit.
		sw $a1, ($a0)
checkFinish:	jr $ra


# args in $a0, $a1 (rownum, colnum), return $v0
checkPieceColor:	li  $v0, -1
			bltz $a0, checkPieceColorFinish         #boundary check
			bgt $a0, 8, checkPieceColorFinish
			bltz $a1, checkPieceColorFinish
			bgt $a1, 8, checkPieceColorFinish
			sll $a0, $a0, 3
			add $a0, $a0, $a1
			#addi $t4, $t4, -9
			sll $a0, $a0, 2
			add $a0, $a0, $s1
			lw  $v0, ($a0)
checkPieceColorFinish:	jr  $ra

