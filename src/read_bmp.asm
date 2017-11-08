.data

bitmap: .asciiz "/Users/judy/GraduateStudy/UTD/Fall2017/CS3340.501-ComputerArchitecture/Project/yellow.bmp"
buffer: .byte  0:375

.text

main:
li $a0, 125
li $a1, 98
li $a2, 256
li $a3, 256
jal printbitmap
li $v0, 10
syscall

# a0, a1 (size of picture)
# a2, a3( start  row, col)
printbitmap: 
addi $sp, $sp, -4
sw $ra, ($sp)
move $s2, $a0
move $s3, $a1
move $s4, $a2
move $s5, $a3

li  $v0, 13
la $a0, bitmap
li $a1,0
li $a2, 0
syscall
move $s6, $v0

li $s0, 0x10040000
addi $s4, $s4, -1
sll $s4, $s4, 11
add $s0, $s0, $s4

li $v0, 14
move $a0, $s6
la $a1, buffer
li $a2, 54
syscall


move $t0, $s3			#set the height of the picture
sloop: li $v0, 14
move $a0, $s6
la $a1, buffer			

				#set loop of weight of the picture
sll $a2, $s2, 2
sub $a2, $a2, $s2
addi $a2, $a2, 1		# b&w picture
syscall
sll $t1, $s2, 2
sub $t1, $t1, $s2 		#array index
li $t2, 0

addi $t3, $t0, -1
sll $t3, $t3, 11
add $s1, $s0, $t3

addi $t3, $s5, -1
sll $t3, $t3, 2
add $s1, $s1, $t3

sloop2: 		#
lbu $t4, buffer($t2)
addi $t2, $t2, 1
lbu $t5, buffer($t2)
addi $t2, $t2, 1
lbu $t6, buffer($t2)
sll $t6, $t6, 16
sll $t5, $t5,8

or $t4, $t4, $t5
or $t4, $t4, $t6

sw $t4, ($s1)
add $s1, $s1, 4
addi $t2, $t2, 1
bne $t2, $t1, sloop2

addi $t0, $t0, -1
bne $t0, $zero, sloop

li $v0, 16
move $a0, $s6
syscall
lw $ra, ($sp)
addi $sp, $sp, 4
jr $ra
