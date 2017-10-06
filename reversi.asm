		.data
		.include "./src/data_directive.asm"

		.text
Main:		jal init_board			#init the board.
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
		jal drawABlackPiece             #place black in 4,4
		li $t1, 5
		jal drawAWhitePiece             #place white in 4,5
		li $t0, 5
		jal drawABlackPiece             #place black in 5,5
		li $t1, 4
		jal drawAWhitePiece             #place white in 5,4
		li $t7, 64
AutoPlayLoop:	li $t6, 1
		jal checkNeighbours             #find all neighbours of specified color
		jal calMaxProfit                #calculate max profit of all neighbours positions
		lw $t0, maxProfitRow
		lw $t1, maxProfitCol
		jal oneStep                     #step in the subroutine to finish placing one piece on the board
		jal clearMaxProfit              #erase the memory content which has been used during last calMaxProfit
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

		.include "./src/init_board.asm"
		.include "./src/cal_profit.asm"
		.include "./src/one_step.asm"
		.include "./src/draw_pieces.asm"
		.include "./src/check_around.asm"

