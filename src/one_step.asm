# 'one_step.asm' includes two procedures which would be call when 
#     player or PC is trying to put a new piece in a specified square.
#
# oneStep
# checkAvailable

# Real one step on board
# args in $t0, $t1, $t6 (rownum, colnum, color)
oneStep:           	addi $sp, $sp, -4
			sw  $ra, ($sp)
			move $s4, $t6
			jal checkAvailable              # check if this place is available for put a new piece. Also store the possible pieces which could be change color if put this new piece during this subroutine
			beqz $s5, cannotPlace           # Profix is 0 means cannot place here.
			bnez $s4, oneStepBlack1         # if current player is black, jump to black part
			jal drawAWhitePiece             # else put a white piece here.
			b oneStepContinue1              # go to the loop for change opponent's pieces which store in ($s2)
oneStepBlack1:		jal drawABlackPiece
oneStepContinue1:	la   $s2, waitPiecesPoss
			li   $s3, 8
oneStepReversiLoop:	lw  $t0, ($s2)                  # extract coordinate information from array's element
			div $t0, $s3
			mfhi $t1
			mflo $t0
			bnez $t1, oneStepNormal         # deal with situation of y=0
			li   $t1, 8
			addi $t0, $t0, -1
oneStepNormal:		bnez $s4, oneStepBlack2
			jal drawAWhitePiece
			b oneStepContinue2
oneStepBlack2:		jal drawABlackPiece
oneStepContinue2:	addi $s2, $s2, 4
			addi $s5, $s5, -1
			bgtz $s5, oneStepReversiLoop    # if the array is not empty, back to loop for change color.
cannotPlace:		lw  $ra, ($sp)
			addi $sp, $sp, 4
			jr  $ra


# This function is similar to calOneStep to great extent, but this plus a
# instruction sets to store the opponent pieces which possibly be changed.
# $s2 is the array address of which is used to store this possible positions.
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
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
			sll $s3, $t2, 3
			add $s3, $s3, $t3
			sw  $s3, ($s2)
			addi $s2, $s2, 4
			b   checkSouthEastLoop
checkSouthEastFinish:	add $s5, $s5, $t5

checkAvailableFinish:	lw $ra, ($sp)
			addi $sp, $sp, 4
			jr $ra
