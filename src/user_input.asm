.data
	promtRow:	.asciiz "Please enter a board loaction (starting with a lettter): "

	invalidInput:	.asciiz "Invalid coordinates. please try again.\n"
	
	row:		.asciiz ""
	column:		.word 0
	
	#Return values in v0 and v1. v0 = row. v1 = column
.text

	userInput:
		addi $s2, $0, 7			#NUMBER LIMIT FOR ROWS AND COLUMNS (0-7. 8 ROWS AND 8 COLUMNS) 
		li $v0, 4
		la $a0 promtRow
		syscall				#print row string
		
		la $a0, row			#save string in "number"
		li $a1, 2			#limit user input to one letter
		li $v0, 8			
		syscall				#promt user
		
		add $v0, $0,$0

		li $v0, 5
		syscall				#promt user
		sw $v0, column
		
		#inpuit validation
		#column
		lw $s1, column
		addi $t0, $0, 8			#largest number the user can input
		bgt $s1, $t0, badInput		#if user input > 8, then badInput
		
		addi $t0, $0, 1
		blt $s1, $t0, badInput		#if userInput < 1, then bad input
		addi $s1, $s1, -1		#user inout -1 (max 7)					################## (assuming we havent added the labels to the board) goes from 0 to 7
		sw $s1, column
		
		
		#row
		lw $s0, row			#load user input into t1
		addi $t0, $0, 65
		blt $s0, $t0, badInput		#if input < 65(A), invalid
		
		addi $t0, $0, 104
		bgt $s0, $t0, badInput		#if input > 104(h), invalid
		
		addi $t0, $0, 96
		bgt $s0, $t0, lowerCase
		
		upperCase:			#change the letter to integer if uppercase
			addi $s0, $s0, -65
			bgt $s0, $s2, badInput
			j validateCoordinates
		
		lowerCase:
			addi $s0, $s0, -97	
			bgt $s0, $s2, badInput	#if new integer value is bigger than 7, then bad input
			j validateCoordinates
		
	badInput:				#change the letter to integer if lowercase
		li $v0, 4
		la $a0 invalidInput
		syscall
		j userInput
	
	validateCoordinates:
		#addi $s0, $s0, 1									################## (assuming we added the labels to the board) goes from 0 to 7
		sw $s0, row				#store new integer value.
		
		
		
		add $v0, $s0, $0
		add $v1, $s1, $0
		#jr $ra	
