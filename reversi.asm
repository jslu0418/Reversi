		.data
		.include "./src/data_directive_win.asm" # on windows
#		.include "./src/data_directive.asm" # on my mac

		.text
Main:		jal init_board			# init the board.
#		li $t0, 1			# Test for fill all the squares
#ploop1:	li $t1, 1
#ploop2:	jal	drawAWhitePiece
#		addi $t1, $t1, 1
#		ble  $t1, 8, ploop2
#		addi $t0, $t0, 1
#		ble  $t0, 8, ploop1
		la $s1, piecesPoss		# store address of piecesPoss array in Main process.
		li $a0, 3
		li $a1, 3
		jal drawABlackPiece             # place black in 4,4
		li $a1, 4
		jal drawAWhitePiece             # place white in 4,5
		li $a0, 4
		jal drawABlackPiece             # place black in 5,5
		li $a1, 3
		jal drawAWhitePiece             # place white in 5,4
		li $t7, 64
		li $a2, 0                       # initial a2 for white (0) since Autoplayloop will change color at first
		li $a3, 0		        # initial $a3 to record if there was already one side have no more step
AutoPlayLoop:	seq $a2, $a2, 0
		jal checkNeighbours             # find all neighbours of specified color
		jal calMaxProfit                # calculate max profit of all neighbours positions
		bne $a2, $zero, userTurn	# if $a2 != 0 (== 1) userTurn
		# user input
		lw $a0, maxProfitRow
		lw $a1, maxProfitCol

		# Show AI last move
		move	$t0, $a0			# temporarily save $a0, $a1 and $v0
		move	$t1, $v0
		move	$t2, $a1		
		li	$v0, 4
		la	$a0, AIMoveMsg
		syscall
		
		li	$v0, 11
		addi	$a0, $t0, 65			# change row number to character's ascii value (A~H)
		syscall
		addi	$a0, $t2, 49			# change col number to digit's ascii value
		syscall
		
		li	$v0, 4
		la	$a0, newLine
		syscall
		
		move	$a0, $t0
		move	$v0, $t1			# restore $a0, $a1 and $v0
		move	$a1, $t2		
		
		b	play

userTurn:	jal	userInputStack
		move	$a0, $v0
		move	$a1, $v1
play:		jal	oneStep                     	# step in the subroutine to finish placing one piece on the board

		blt	$v0, $0, userTurn		# illegal move, return to user turn
		beqz	$v0, userTurn
		
		jal	clearMaxProfit              	# erase the memory content which has been used during last calMaxProfit
		addi	$t7, $t7, -1
		bgtz	$t7, AutoPlayLoop

return:		li $v0, 10			# syscall code of return
		syscall				# return

		.include "./src/init_board.asm"
		.include "./src/cal_profit.asm"
		.include "./src/one_step.asm"
		.include "./src/draw_pieces.asm"
		.include "./src/check_around.asm"
		.include "./src/user_input.asm"
		.include "./src/read_bmp.asm"
