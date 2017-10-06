# 'draw_pieces.asm' includes two procedures used to draw a white or a black piece
#
# drawAWhitePiece
# drawABlackPiece

# Draw a white piece on board
# args in $t0, $t1 (rownum, colnum)
drawAWhitePiece:	add $t2, $t0, -1
			sll $t3, $t2, 6			# $t3 = $t2 * 64
			sub $t2, $t3, $t2		# $t2 = $t3 - $t2 = $t2 * 63
			sll $t2, $t2, 11		# $t2 = $t2 * 63 * 2048 = $t2 * 129024
			add $t2, $t2, 16384
			add $t3, $t1, -1
			sll $t4, $t3, 6			# $t4 = $t3 * 64
			sub $t3, $t4, $t3		# $t3 = $t4 - $t3 = $t3 * 63
			sll $t3, $t3, 2			# $t3 = $t3 * 63 * 4 = $t3 * 252
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
			sll  $t2, $t0, 3
			add  $t2, $t2, $t1
			addi $t2, $t2, -9
			sll  $t2, $t2, 2
			la  $t3, piecesPoss
			add $t2, $t2, $t3
			li  $t3, 0
			sw  $t3, ($t2)
			jr  $ra


# Draw a black piece on board
# args in $t0, $t1 (rownum, colnum)
drawABlackPiece:	add $t2, $t0, -1
			# mul $t2, $t2, 129024		#address increament of a row of squares plus a row of split lines
			sll $t3, $t2, 6			# $t3 = $t2 * 64
			sub $t2, $t3, $t2		# $t2 = $t3 - $t2 = $t2 * 63
			sll $t2, $t2, 11		# $t2 = $t2 * 63 * 2048 = $t2 * 129024
			add $t2, $t2, 16384		#address increament of a row of split line
			add $t3, $t1, -1
			# mul $t3, $t3, 252		#address increament of a col of squares plus a row of split lines
			sll $t4, $t3, 6			# $t4 = $t3 * 64
			sub $t3, $t4, $t3		# $t3 = $t4 - $t3 = $t3 * 63
			sll $t3, $t3, 2			# $t3 = $t3 * 63 * 4 = $t3 * 252
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
                        sll  $t2, $t0, 3
	                add  $t2, $t2, $t1
	                addi $t2, $t2, -9
                        sll  $t2, $t2, 2
			la  $t3, piecesPoss
			add $t2, $t2, $t3
			li  $t3, 1
			sw  $t3, ($t2)
			jr  $ra
