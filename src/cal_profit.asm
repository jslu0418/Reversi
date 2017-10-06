# 'cal_profit.asm' includes several procedures which are about calculation for profit
# clearMaxProfit
# calOneStep
# calMaxProfit
# calNoStep

clearMaxProfit:	li $t6, 0
		sw $t6, maxProfit
		sw $t6, maxProfitRow
		sw $t6, maxProfitRow
		jr $ra
	

# Calculte profit in a specified step.
# args in $t0, $t1, $t6, (rownum, colnum, color)
# For every direction, Loop make sure there are consecutive black pieces in this direction.
# return this step's profit in $s5.
calOneStep:		la   $s1, piecesPoss
			addi $sp, $sp, -4
			sw $ra, ($sp)
			li   $s5, 0                     # s5 save max profit
			move $t2, $t0
			move $t3, $t1
#NorthWest                                              # Every direction's logic is similar with this.
calNorthWest:		add $t2, $t0, -2
			blez $t2, calWest               # x-2 < 0 means there is no enough space in North, jump tp West
			add $t3, $t1, -2
			blez $t3, calNorth              # y-2 < 0, cannot go West
			li  $t5, 0                      # t5 store consecutive white pieces' number in this direction.
			move $t2, $t0
			move $t3, $t1
calNorthWestLoop:	add $t2, $t2, -1
			add $t3, $t3, -1
			jal checkPieceColor
			beq $t6, 1, calNorthWestBlack   # if current player is black, jump to calNorthWestBlack, cuz following 2 steps will assume current player is white
			beq $t4, 1, calNorthWestInc     # current checking place is black, let $t5 = $t5 + 1 and forward in this direction
			beq $t4, 0, calNorthWestFinish  # encounter a piece with same color with self. Need to finish this direction
			b   calWest                     # if never encounter a piece with the color with self. This direction profit must be 0, go to next direction
calNorthWestBlack:	beq $t4, 0, calNorthWestInc     # similar with above steps but treat self as black color
			beq $t4, 1, calNorthWestFinish
			b   calWest
calNorthWestInc:	addi $t5, $t5, 1
			b   calNorthWestLoop
calNorthWestFinish:	add $s5, $s5, $t5               # add this direction's profit to Sum

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

# When there's no more steps, calculate two sides' num
calNoStep:		lw $t0, maxPiecesNum
			li $t1, 0
			li $t2, 0
			la $t3, piecesPoss
calNumLoop:		lw $t4, ($t3)
			beqz $t4, calNumWhiteInc
			beq  $t4, 1, calNumBlackInc
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
