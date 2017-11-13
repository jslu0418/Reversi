# 'draw_pieces.asm' includes two procedures used to draw a white or a black piece
#
# drawAWhitePiece
# drawABlackPiece

# Draw a white piece on board
# args in $a0, $a1 (rownum, colnum)
drawAWhitePiece:	sll $t0, $a0, 6			# $t0 = $a0 * 64
			sll $t1, $a0, 3			# $t1 = $a0 * 8
			sub $t0, $t0, $t1		# $t0 = $a0 * 56
			sll $t0, $t0, 11		# $t0 = $t0 * 56 * 2048 = $a0 * 114688
			add $t0, $t0, 16384
			sll $t1, $a1, 6 		# $t1 = $a1 * 64
			sll $t2, $a1, 3
			sub $t1, $t1, $t2		# $t1 = $a1 * 56
			sll $t1, $t1, 2			# $t1 = $t1 * 56 * 4 = $a1 * 224
			add $t1, $t1, 32
			add $t0, $t0, $t1
			add $t0, $s0, $t0
			addi $t0, $t0, 114688
			addi $t0, $t0, 224
			lw  $t1, pixelsNum
			la  $t2, pixelsOffsets
drawWhitePieceLoop:	lw  $t3, 0($t2)
			addi $t2, $t2, 4
			add $t4, $t0, $t3
			sw  $s7, ($t4)
			addi $t1, $t1, -1
			bgtz $t1, drawWhitePieceLoop
			sll  $t0, $a0, 3		#t0=a0*8
			add  $t0, $t0, $a1		#t0=a0+a1
			sll  $t0, $t0, 2		#t0=t0*4
			la  $t1, piecesPoss
			add $t0, $t0, $t1
			li  $t1, 0
			sw  $t1, ($t0)
			jr  $ra


# Draw a black piece on board
# args in $t0, $t1 (rownum, colnum)
drawABlackPiece:	sll $t0, $a0, 6			# $t0 = $a0 * 64
			sll $t1, $a0, 3			# $t1 = $a0 * 8
			sub $t0, $t0, $t1		# $t0 = $a0 * 56
			sll $t0, $t0, 11		# $t0 = $t0 * 56 * 2048 = $a0 * 114688
			add $t0, $t0, 16384
			sll $t1, $a1, 6 		# $t1 = $a1 * 64
			sll $t2, $a1, 3
			sub $t1, $t1, $t2		# $t1 = $a1 * 56
			sll $t1, $t1, 2			# $t1 = $t1 * 56 * 4 = $a1 * 224
			add $t1, $t1, 32
			add $t0, $t0, $t1
			add $t0, $s0, $t0
			addi $t0, $t0, 114688
			addi $t0, $t0, 224
			lw  $t1, pixelsNum
			la  $t2, pixelsOffsets
drawBlackPieceLoop:	lw  $t3, 0($t2)
			addi $t2, $t2, 4
			add $t4, $t0, $t3
			sw  $s6, ($t4)
			addi $t1, $t1, -1
			bgtz $t1, drawBlackPieceLoop
			sll  $t0, $a0, 3		#t0=a0*8
			add  $t0, $t0, $a1		#t0=a0+a1
			sll  $t0, $t0, 2		#t0=t0*4
			la  $t1, piecesPoss
			add $t0, $t0, $t1
			li  $t1, 1
			sw  $t1, ($t0)
			jr  $ra
