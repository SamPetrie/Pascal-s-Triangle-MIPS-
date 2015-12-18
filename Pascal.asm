.data 0x0

newline: .asciiz "\n"
space: .asciiz " "
here: .asciiz "here"

.text 0x3000
.globl main
main:

ori     $sp, $0, 0x2ffc     # Initialize stack pointer to the top word below .text
                            # The first value on stack will actually go at 0x2ff8
                            #   because $sp is decremented first.
addi    $fp, $sp, -4        # Set $fp to the start of main's stack frame

li $v0, 5
syscall					#number of lines to print stored in $v0

ori $t0, $v0, 0				#number of lines

ori $t1, $0, 0				#i = 0
ori $t2, $0, 0				#j = 0

LWhile:

	beq $t1, $t0, endmain
	
	sub $t3, $t0, $t1
	addi $t3, $t3, -1
	
	j Spacesfor
	
Spacesfor:
	 
	beq $t3, $t2, endSpaces		#j = lines-1-i
	
	li $v0, 4			#print space
	la $a0, space
	syscall
	
	addi $t2, $t2, 1		#j++
	
	j Spacesfor
	
endSpaces:
	ori $t2, $0, 0
	j Pascalfor
	
Pascalfor:
	bgt $t2, $t1, endpfor
	
	ori $a0, $t1, 0			#$a0 = i
	ori $a1, $t2, 0			#$a1 = j
	
	jal pascal
	
	ori $a0, $v0, 0			#move result to $a0
	
	li $v0, 1
	syscall				#print int
	
	li $v0, 4
	la $a0, space
	syscall				#print a space
	
	addi $t2, $t2, 1		#j++
	
	j Pascalfor
	
endpfor:

	li $v0, 4			#print new line
	la $a0, newline
	syscall
	
	addi $t1, $t1, 1		#i++
	ori $t2, $0, 0
	
	j LWhile
	
endmain:
	ori     $v0, $0, 10     	# System call code 10 for exit
	syscall 

.globl pascal
pascal:
addi $sp, $sp, -20
sw $s0, 16($sp)
sw $s1, 12($sp)
sw $s2, 8($sp)
sw $ra, 4($sp)
sw $fp, 0($sp)


addiu $fp, $sp, 4

	beq $a1, $0, case0		#j = 0
	beq $a1, $a0, case0		#j = i
	
	addi $s0, $a0, 0
	addi $s1, $a1, 0
	
	addi $a0, $a0, -1		#i - 1
	addi $a1, $a1, -1
	
	jal pascal
	add $s2, $v0, $0
	
	addi $a0, $s0, -1		#j-1
	add $a1, $s1, $0
	jal pascal
	add $v0, $s2, $v0
	
	j endpascal
	
case0:
	ori $v0, $0, 1
	
	j endpascal
	
endpascal:
	lw $fp, 0($sp)
	lw $ra, 4($sp)
	lw $s2, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	addi $sp, $sp, 20
	jr $ra
