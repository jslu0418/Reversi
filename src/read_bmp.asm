.text

# a0: width, a1: height
# a2: filepath, a3: pos, row*512+col
readandprintbmp: 	addi $sp, $sp, -36	# get space from stack
			sw $ra, ($sp)		# store registers
			sw $s0, 4($sp)		# store registers
			sw $s1, 8($sp)		# store registers
			sw $s2, 12($sp)		# store registers
			sw $s3, 16($sp)		# store registers
			sw $s4, 20($sp)		# store registers
			sw $s5, 24($sp)		# store registers
			sw $s6, 28($sp)		# store registers
			sw $s7, 32($sp)		# store registers
			add $s2, $zero, $a0	# move args
			add $s3, $zero, $a1	# move args
			add $s4, $zero, $a2	# move args
			lw   $t0, displaysize	# set bitmap display size
			div  $a3, $t0		# get row and col from quotient and remainder
			mflo $s5		# row of pos
			mfhi $s6		# col of pos
			li  $v0, 13		# syscode for openfile
			add $a0, $zero, $s4	# set filename
			li $a1, 0		# read only
			li $a2, 0		# unuseful code in Mars
			syscall
			add $s7, $zero, $v0	# get file descripter
			sll $s5, $s5, 11	# change to base address for specified pos
			add $s0, $s0, $s5	# add base address to specified pos to base address of bitmap display
			li $v0, 14		# syscode for read file
			add $a0, $zero, $s7	# set file descripter
			la $a1, readbuffer	# set read buffer
			li $a2, 54		# skip for bmp header
			syscall
			add $t0, $zero, $s3	# bmp height for loop time
loop_row: 		la  $a1, readbuffer	# read buffer
			add $a0, $zero, $s7	# filename
			li $v0, 14		# syscode for reading file
			sll $a2, $s2, 2		# bmp width for loop time
			sub $a2, $a2, $s2	# a2 = s2 * 3 (byte size for pixels in a row of bmp file)
			#addi $a2, $a2, 1	# this is for b&w graph
			syscall
			sll $t1, $s2, 2		# t1 = s2 * 4 set for inner loop times
			sub $t1, $t1, $s2 	# t1 = s2 * 3 (byte size for pixels in a row) array index
			li  $t2, 0		# inner loop counter
			addi $t3, $t0, -1	# after a loop row num = row num - 1 draw in reversed order
			sll $t3, $t3, 11	# t3 = t3 * 2048 (byte size for pixel in a total row
			add $s1, $s0, $t3	# adjust base offset
			sll $t3, $s6, 2		# t3 = col num * 4, get position in a row
			add $s1, $s1, $t3	# adjust base offset
loop_col: 		lbu $t4, readbuffer($t2)# read one byte color
			addi $t2, $t2, 1	# inc
			lbu $t5, readbuffer($t2)# read one byte color
			addi $t2, $t2, 1	# inc
			lbu $t6, readbuffer($t2)# read one byte color		
			sll $t5, $t5, 8		# shift 1 byte
			or  $t4, $t4, $t5	# concat
			sll $t6, $t6, 16	# shift 2 byte
			or  $t4, $t4, $t6	# concat
			sw $t4, ($s1)		# write to bitmap display
			add $s1, $s1, 4		# adjust base offset to next pixel
			addi $t2, $t2, 1	# inc counter
			bne $t2, $t1, loop_col	# if not finish one row back to loop
			addi $t0, $t0, -1	# dec row counter
			bne $t0, $zero, loop_row	# if not finish total back to loop
			move $a0, $s7			# file descripter
			li $v0, 16			# close file syscode
			syscall				# close file
			lw $ra, ($sp)			# restore registers
			lw $s0, 4($sp)			# restore registers
			lw $s1, 8($sp)			# restore registers
			lw $s2, 12($sp)			# restore registers
			lw $s3, 16($sp)			# restore registers
			lw $s4, 20($sp)			# restore registers
			lw $s5, 24($sp)			# restore registers
			lw $s6, 28($sp)			# restore registers
			lw $s7, 32($sp)			# restore registers
			addi $sp, $sp, 36		# restore stack pointer
			jr $ra				# return to main
