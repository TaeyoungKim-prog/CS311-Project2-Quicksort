# PROGRAM: Hello, World!

	.data		# Data declaration section

	out_string: .asciiz "\nHello, World!\n"
    p: .word 0

	.text

main:	# Start of code section
	
    #make 1664525
    lui $t0, 25
    ori $t0, $t0, 26125 #t0 = 1664525
    #make 22695477
    lui $t1,346
    ori $t1, $t1, 20021 #t1 = 22695477

    li $v0, 1
	move $a0, $t1
	syscall	
    li $v0, 1
	move $a0, $t0
	syscall	

	li $v0, 10
	syscall

    li $v0, 4
	la $a0, out_string
	syscall		

    li $v0, 9
    li $a0, 1	
    syscall
	addi $v0, $v0, 2
    sw $v0, p

	addi	$t0, $t0, 8			# $t0 = $t1 + 0
	sw $t0, p

	lw $t1, p

	li $v0, 1
	move $a0, $t1
	syscall	

	

# BLANK LINE AT THE END TO KEEP SPIM HAPPY!