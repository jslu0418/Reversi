# 'one_step.asm' includes two procedures which would be call when 
#     player or PC is trying to put a new piece in a specified square.
#
# oneStep
# checkAvailable

# Real one step on board
# args in $a0, $a1, $a2 (rownum, colnum, color)
# args in $t0, $t1, $t6 (rownum, colnum, color)
oneStep:		addi $sp, $sp, -24
			sw   $s1, 20($sp)
			sw   $s2, 16($sp)
			sw   $s3, 12($sp)
			sw   $s4, 8($sp)
			sw   $s5, 4($sp)
			sw   $ra, ($sp)
			lw   $s5, maxProfit
			move $s4, $a2
			addi $sp, $sp, -8
			sw   $a0, 4($sp)
			sw   $a1, ($sp)
			jal checkAvailable              # check if this place is available for put a new piece. Also store the possible pieces which could be change color if put this new piece during this subroutine
			lw   $a0, 4($sp)
			lw   $a1, 0($sp)
			addi $sp, $sp, 8
			beqz $v0, cannotPlace           # Profix is 0 means cannot place here.
	                move $s5, $v0			# the profix from checkAvailable
                        move $s1, $v0                   # save $v0
			bnez $s4, oneStepBlack1         # if current player is black, jump to black part
			jal drawAWhitePiece             # else put a white piece here.
			b oneStepContinue1              # go to the loop for change opponent's pieces which store in ($s2)
oneStepBlack1:		jal drawABlackPiece
oneStepContinue1:	la   $s2, waitPiecesPoss
			li   $s3, 8
oneStepReversiLoop:	lw  $t0, ($s2)                  # extract coordinate information from array's element
			div $t0, $s3
			mfhi $a1
			mflo $a0
oneStepNormal:		bnez $s4, oneStepBlack2
			jal drawAWhitePiece
			b oneStepContinue2
oneStepBlack2:		jal drawABlackPiece
oneStepContinue2:	addi $s2, $s2, 4
			addi $s5, $s5, -1
			bgtz $s5, oneStepReversiLoop    # if the array is not empty, back to loop for change color.
                        move $v0, $s1                   # restore v0
cannotPlace:		lw   $s1, 20($sp)
			lw   $s2, 16($sp)
			lw   $s3, 12($sp)
			lw   $s4, 8($sp)
			lw   $s5, 4($sp)
			lw   $ra, ($sp)
	                addi $sp, $sp, 24
			jr  $ra


# This function is similar to calOneStep to great extent, but this plus a
# instruction sets to store the opponent pieces which possibly be changed.
# $s2 is the array address of which is used to store this possible positions.
# args in $a0, $a1, $a2 (rownum, colnum, color)
# For every direction, Loop make sure there are consecutive black pieces in this direction.
# return this step's profit in $v0.
checkAvailable:		addi $sp, $sp, -20
			sw   $s1, 16($sp)
			sw   $s2, 12($sp)
			sw   $s3, 8($sp)
			sw   $s5, 4($sp)
			sw   $ra, ($sp)
			la   $s1, piecesPoss
			la   $s2, waitPiecesPoss
			li   $s5, 0
			move $t0, $a0
			move $t1, $a1
			move $t2, $t0
			move $t3, $t1
#NorthWest
checkNorthWest:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -1
			blez $t2, checkWest
			add $t3, $t1, -1
			blez $t3, checkNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthWestLoop:	add $t2, $t2, -1
			add $t3, $t3, -1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkNorthWestBlack
			beq $v0, 1, checkNorthWestInc
			beq $v0, 0, checkNorthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkWest
checkNorthWestBlack:	beq $v0, 0, checkNorthWestInc
			beq $v0, 1, checkNorthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkWest
checkNorthWestInc:	addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthWestLoop
checkNorthWestFinish:	add $s5, $s5, $t5

#West
checkWest:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, -1
			blez $t3, checkNorth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkWestLoop:		add $t3, $t3, -1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkWestBlack
			beq $v0, 1, checkWestInc
			beq $v0, 0, checkWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorth
checkWestBlack:		beq $v0, 0, checkWestInc
			beq $v0, 1, checkWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorth
checkWestInc:		addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkWestLoop
checkWestFinish:	add $s5, $s5, $t5

#North
checkNorth:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -1
			blez $t2, checkSouthWest
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthLoop:		add $t2, $t2, -1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkNorthBlack
			beq $v0, 1, checkNorthInc
			beq $v0, 0, checkNorthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthWest
checkNorthBlack:	beq $v0, 0, checkNorthInc
			beq $v0, 1, checkNorthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthWest
checkNorthInc:		addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthLoop
checkNorthFinish:	add $s5, $s5, $t5

#SouthWest
checkSouthWest:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, -1
			blez $t3, checkSouth
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthWestLoop:	add $t3, $t3, -1
			add $t2, $t2, 1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkSouthWestBlack
			beq $v0, 1, checkSouthWestInc
			beq $v0, 0, checkSouthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouth
checkSouthWestBlack:	beq $v0, 0, checkSouthWestInc
			beq $v0, 1, checkSouthWestFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouth
checkSouthWestInc:	addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthWestLoop
checkSouthWestFinish:	add $s5, $s5, $t5

#South
checkSouth:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, 1
			bgt $t2, 6, checkEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthLoop:		add $t2, $t2, 1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkSouthBlack
			beq $v0, 1, checkSouthInc
			beq $v0, 0, checkSouthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkEast
checkSouthBlack:	beq $v0, 0, checkSouthInc
			beq $v0, 1, checkSouthFinish
			lw  $s2, waitPiecesPossPoint
			b   checkEast
checkSouthInc:		addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthLoop
checkSouthFinish:	add $s5, $s5, $t5

#East
checkEast:		sw  $s2, waitPiecesPossPoint
			add $t3, $t1, 1
			bgt $t3, 6, checkAvailableFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkEastLoop:		add $t3, $t3, 1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkEastBlack
			beq $v0, 1, checkEastInc
			beq $v0, 0, checkEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorthEast
checkEastBlack:		beq $v0, 0, checkEastInc
			beq $v0, 1, checkEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkNorthEast
checkEastInc:		addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkEastLoop
checkEastFinish:	add $s5, $s5, $t5

#NorthEast
checkNorthEast:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, -1
			blez $t2, checkSouthEast
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkNorthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, -1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkNorthEastBlack
			beq $v0, 1, checkNorthEastInc
			beq $v0, 0, checkNorthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthEast
checkNorthEastBlack:	beq $v0, 0, checkNorthEastInc
			beq $v0, 1, checkNorthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkSouthEast
checkNorthEastInc:	addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkNorthEastLoop
checkNorthEastFinish:	add $s5, $s5, $t5

#SouthEast
checkSouthEast:		sw  $s2, waitPiecesPossPoint
			add $t2, $t0, 1
			bgt $t2, 6, checkAvailableFinish
			li  $t5, 0
			move $t2, $t0
			move $t3, $t1
checkSouthEastLoop:	add $t3, $t3, 1
			add $t2, $t2, 1
			move $a0, $t2
			move $a1, $t3
			jal checkPieceColor
			beq $a2, 1, checkSouthEastBlack
			beq $v0, 1, checkSouthEastInc
			beq $v0, 0, checkSouthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkAvailableFinish
checkSouthEastBlack:	beq $v0, 0, checkSouthEastInc
			beq $v0, 1, checkSouthEastFinish
			lw  $s2, waitPiecesPossPoint
			b   checkAvailableFinish
checkSouthEastInc:	addi $t5, $t5, 1
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthEastLoop
checkSouthEastFinish:	add $s5, $s5, $t5

checkAvailableFinish:	move $v0, $s5
			lw   $s1, 16($sp)
			lw   $s2, 12($sp)
			lw   $s3, 8($sp)
			lw   $s5, 4($sp)
			lw   $ra, ($sp)
			addi $sp, $sp, 20
			jr $ra
