# PROGRAM: Hello, World!

	.data		# Data declaration section
    array: .space 400

    out_string: .asciiz "\nEnter number of elements to be sorted: "
    out_string_two: .asciiz "\n"
    .text
	
.globl main

main:	# Start of code section
	li $v0, 4
	la $a0, out_string
	syscall		

	li $v0, 5
	syscall		
    add $t0, $v0, $zero #t0 now stores number, n of elements A will have.
    add $s0, $t0, $zero #store n for later use
    add $t1, $t0, $zero #t1 stores i = n.
    add $t2, $zero, $zero #initialize as the first position of array
    jal addNumbersToArray

    add $t1, $s0, $zero #t1 stores i = n.
    add $t2, $zero, $zero #initialize as the first position of array
    jal printNumbersOfArray


addNumbersToArray: # loop that iterates 5 times
    li $v0, 5
	syscall	
    add $t0, $zero, $v0 #gets number x to put it in array
    
    sw   $t0, array($t2) #store x into array. address = $t2 + address of ARRAY
    addi $t2, $t2, 4 #increment $t2 address by four for next index 
    
    addi	$t1, $t1, -1		# i = i - 1
    bne $t1, $zero, addNumbersToArray # if i is not zero continue loop
    jr $ra  #when i = 0 exit loop and go back to main
    
printNumbersOfArray: # loop that iterates 5 times
    lw   $t0, array($t2) #Loads from the array at each iteration.  
    addi $t2, $t2, 4 #increment $t2 address by four for next index 
    
    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
	la $a0, out_string_two
	syscall		

    addi	$t1, $t1, -1		# i = i - 1
    bne $t1, $zero, printNumbersOfArray # if i is not zero continue loop
    jr $ra  #when i = 0 exit loop and go back to main
    


quicksort:	# quick sort.
	


# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
