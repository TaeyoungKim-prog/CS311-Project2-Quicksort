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

    #declare high and low
    addi $a0, $zero, 0 #a0 contains low = 0
    addi $t0, $s0, -1 # n-1
    add $a1, $zero, $t0#a0 contains high = n-1


    #store address. have to store argument only if the function has passed arguments(parameter)
    addi $sp, $sp -4
    sw $ra, 4($sp)  #store return address

    jal quicksort
    
    #restore parameters and address.
    lw $ra, 4($sp)  #restore return address
    addi $sp, $sp 4

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
    #If not main, whenever we are using $s we need to save it to stack.
	addi $sp, $sp, -4
    sw $s0, 0($sp)  #store size of array, n

    #save return address and argument, as quicksort is non-leaf.
	addi $sp, $sp, -12
    sw $ra, 8($sp)  #return address
    sw $a0, 4($sp)  #argument low
    sw $a1, 0($sp)  #argument high


    lw $s0, 0($sp)  #restore size of array, n
	addi $sp, $sp, 4

partition:


# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
