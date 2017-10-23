# Khoa L. D. Ho 
# KLH170130
# CS 3340 - 501 by Prof. Nguyen



.data
newLine:		# store the ascii character for new line.
	.asciiz "\n"
inputPrompt:
	.asciiz "\nPlease enter the coordinate for your move: \n"
invalidCoordMsg:
	.asciiz "\nInvalid input coordinate! Please retry with a different coordinate.\n"
illegalMoveMsg1:
	.asciiz "\nYour move is not allowed! The chosen coordinate is already occupied. Please retry with a different move.\n"
illegalMoveMsg2:
	.asciiz "\nYour move is not allowed! You must move to take the opponent's piece(s) when any such move is possible. Please retry with a different move.\n"
inputCoord: 
	.asciiz "XY"
inputRow:
	.word 0
inputColumn:
	.word 0
	
.text
inputingMove:
	# user is expected to enter input as a string of 2 characters,
	# including 1 digit between 1 and 8, and 1 letter between A and H, or between a and h.
	# the order of the two does not matter, i.e. A1 and 1A is understood as the same
	
	inputtingStart:
	la	$a0, inputPrompt	# print the prompt for input 
	li	$v0, 4			
	syscall				
	
	li	$a0, inputCoord		# read the string of input (2 characters + null-terminate)
	li	$a1, 3
	li	$v0, 8
	syscall
	
	# processing coordinate
	lbu	$t0, (inputCoord)		# loab byte at inputCoord data address
	blt	$t0, 49, invalidCoord		# first coord is < 1 (as ascii character), invalid
	blt	$t0, 57, digitAlpha		# first coord is digit <= 8, valid, check second coord
	blt	$t0, 65, invalidCoord		# first coord was not number, is < A, invalid
	blt	$t0, 73, upperAlphaDigit	# first coord is upper letter <= H, valid, check second coord
	blt	$t0, 97, invalidCoord		# first coord was not number, not upper letter <= H, is < a, invalid
	blt	$t0, 105, lowerAlphaDigit	# first coord is lower letter <= h, valid, check second coord
	j	invalidCoord			# first coord is not lower letter <=h, invalid
	
	# first coord is digit (1-8) (row), expect second coord to be letter (A-H or a-h)
	digitAlpha:
	addi	$t0, $t0, -48			# convert numeric string to number
	sw	$t0, inputRow			# valid coord, store row's number
	# check second coord as letter
	lbu	$t0, 1(inputCoord)		# load byte, address offset by 1 byte starting at inputCoord data address
	blt	$t0, 65, invalidCoord		# second coord is < A, invalid
	blt	$t0, 73, digitUpperAlpha	# second coord is upper letter <= H, valid
	blt	$t0, 97, invalid Coord		# second coord was not upper letter <= H, is < a, invalid
	blt	$t0, 105, digitLowerAlpha	# second coord is lower letter <= h, valid
	j	invalidCoord			# second coord is not lower letter <= h, invalid
	digitLowerAlpha:
	addi	$t0, $t0, -32			# convert lower letter to upper letter
	digitUpperAlpha:
	addi	$t0, $t0, -64			# convert upper letter to number with A = 1, B =2, etc.
	sw	$t0, inputColumn		# valid coord, store column's number
	j	validateMove			# valid coord input, validating move's legality
	
	
	# first coord is letter (A-H or a-h) (column), expect second coord to be digit (1-8)
	lowerAlphaDigit:
	addi	$t0, $t0, -32			# convert lower letter to upper letter
	upperAlphaDigit:
	addi	$t0, $t0, -64			# convert upper letter to number with A = 1, B =2, etc.
	sw	$t0, inputColumn		# valid coord, store column's number
	# check second coord as digit
	lbu	$t0, 1(inputCoord)		# load byte, address offset by 1 byte starting at inputCoord data address	
	blt	$t0, 49, invalidCoord		# second coord < 1, invalid
	bgt	$t0, 56, invalidCoord		# second coord is > 8, invalid
	sw	$t0, inputRow			# valid coord, store row's number
	j	validateMove			# valid coord input, validating move's legality
	
	# invalid coordinate, inform the user and retry to get input
	invalidCoord:
	la	$a0, invalidCoordMsg		# print the message for invalid coord
	li	$v0, 4			
	syscall				
	j	inputtingStart			# jump back to inputtingStart (loop to get valid input)
	
	
	# valid input, proceed to check if move is legal
	validateMove:
	
	