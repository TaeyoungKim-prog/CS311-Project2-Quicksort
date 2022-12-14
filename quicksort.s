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
    addi $sp, $sp -8
    sw $ra, 0($sp)  #store return address
    sw $s0, 4($sp)  #store n

    jal quicksort
    
    #restore parameters and address.
    lw $s0, 4($sp)  #restore n
    lw $ra, 0($sp)  #restore return address
    addi $sp, $sp 8

    li $v0, 4
	la $a0, out_string_two
	syscall		

    add $t1, $s0, $zero #t1 stores i = n.
    add $t2, $zero, $zero #initialize as the first position of array

    jal printNumbersOfArray

    li $v0, 10
	syscall


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
    #if low<high is false end quicksort
    slt $t0, $a0, $a1
    beq $t0, $zero, ra

    #declare mid_left,mid_right.

    move $t8, $zero #mid_left
    move $t9, $zero, #mid_right

    #save return address and argument, as quicksort is non-leaf.
	addi $sp, $sp, -12
    sw $ra, 8($sp)  #return address
    sw $a0, 4($sp)  #argument low
    sw $a1, 0($sp)  #argument high

    jal partition #(low,high, midleft, midright)

    #load return address and argument, as quicksort is non-leaf.
    lw $a1, 0($sp)  #argument high
    lw $a0, 4($sp)  #argument low
    lw $ra, 8($sp)  #return address
	addi $sp, $sp, 12

    #save return address and argument, as quicksort is non-leaf.
    addi $sp, $sp, -20
    sw $ra, 16($sp)  #return address
    sw $a0, 12($sp)  #argument low
    sw $a1, 8($sp)  #argument high
    sw $t8, 4($sp) #mid_left*
    sw $t9, 0($sp) #mid_right*

    #change high to mid_left -1
    addi $t8, $t8, -1
    move $a1, $t8

    jal quicksort # (low, midleft-1)

    #load return address and argument, as quicksort is non-leaf.
    lw $t9, 0($sp) #mid_right*
    lw $t8, 4($sp) #mid_left*
    lw $a1, 8($sp)  #argument high
    lw $a0, 12($sp)  #argument low
    lw $ra, 16($sp)  #return address
    addi $sp, $sp, 20
    
    #save return address and argument, as quicksort is non-leaf.
    addi $sp, $sp, -20
    sw $ra, 16($sp)  #return address
    sw $a0, 12($sp)  #argument low
    sw $a1, 8($sp)  #argument high
    sw $t8, 4($sp) #mid_left*
    sw $t9, 0($sp) #mid_right*

    #mid_right+1 into low
    addi $t9, $t9, 1
    move $a0, $t9

    jal quicksort #( midright+1, high)

    #load return address and argument, as quicksort is non-leaf.
    lw $t9, 0($sp) #mid_right*
    lw $t8, 4($sp) #mid_left*
    lw $a1, 8($sp)  #argument high
    lw $a0, 12($sp)  #argument low
    lw $ra, 16($sp)  #return address
    addi $sp, $sp, 20

    jr		$ra					# jump to $ra
    

partition:

    move 	$s0, $zero		# $s0 = pivot = 0
    move 	$s1, $zero		# $s1 = i = 0
    move 	$s2, $a0		# $s2 = mid_left = low
    move 	$s3, $a1		# $s3 = mid_right = high

    #make 1664525
    lui $t0, 25
    ori $t0, $t0, 26125 #t0 = 1664525

    #make 22695477
    lui $t1,346
    ori $t1, $t1, 20021 #t1 = 22695477

    #1664525*(unsigned)high
    multu $t0, $a1
    mflo $t2
    
    #22695477*(unsigned)low
    multu $t1, $a0
    mflo $t3
    
    #(1664525*(unsigned)high + 22695477*(unsigned)low)
    add $t4, $t2, $t3

    #high - low + 1
    sub		$t5, $a1, $a0		#high - low
    addi    $t5, $t5, 1

    #(1664525*(unsigned)high + 22695477*(unsigned)low)%(high-low+1);
    div		$t4, $t5			# $t0 / $t1
    mfhi	$t6					# $t3 = $t0 mod $t1

    #i = low + (1664525*(unsigned)high + 22695477*(unsigned)low)%(high-low+1);
    add $s1, $a0, $t6

    #pivot = A[i]
    sll $t1, $s1, 2
    lw $t0, array($t1) #t0 = A[i]
    move $s0, $t0

    #A[i] = A[low]
    sll $t1, $a0, 2 #low * 4
    lw $t0, array($t1) #t0 = A[low]
    sll $t2, $s1, 2 #i * 4
    sw $t0, array($t2)


    #A[low] = pivot
    sll $t1, $a0, 2 #low * 4
    sw $s0, array($t1)

    #i=low + 1
    addi $s1, $a0, 1

	addi $sp, $sp, -4
    sw $ra, 0($sp)  #return address

    jal loop

    lw $ra, 0($sp)  #return address
	addi $sp, $sp, 4

    #store new mid_left and right
    move $t8, $s2
    move $t9, $s3

    jr		$ra	

loop:
    j loop_right

loop_right:
    #mid_right >= i
    slt $t0, $s3, $s1 #if mid_right < i
    bne $t0, $zero, loop_left #if above true, go to next while

    #A[mid_right] > pivot
    sll $t0, $s3, 2
    lw $t1, array($t0) #t1 = A[mid_right] 
    slt $t0, $s0, $t1 #if A[mid_right] > pivot
    beq $t0, $zero, loop_left #if above false, go to next while

    addi $s3, $s3, -1 #mid_right--;

    j loop_right

loop_left:
    slt $t0, $s3, $s1 #if mid_right < i
    bne $t0, $zero, if #if above true, go to next 

    #A[i] <= pivot
    sll $t0, $s1, 2
    lw $t1, array($t0) #A[i]
    slt $t2, $s0, $t1 # pivot < A[i]
    bne $t2, $zero, if # if above true exit to if

    #A[mid_left]
    sll $t0, $s2, 2
    lw $t1, array($t0)

    #A[i]
    sll $t0, $s1, 2
    lw $t2, array($t0)

    #A[mid_left] = A[i]
    sll $t4, $s2, 2 
    sw $t2, array($t4)

    #mid_left ++
    addi $s2, $s2, 1
     
    #A[i] = pivot
    sll $t0, $s1, 2
    sw $s0, array($t0)

    #i++
    addi $s1, $s1, 1

    j loop_left



if: #i < mid right
    slt $t0, $s1, $s3  # i < mid_right
    beq $t0, $zero, ra #if above false go back to jump

    #pivot    s0
    #   i     s1
    #mid_left s2
    #mid_rights3

    #A[mid_left]
    sll $t0, $s2, 2
    lw $t1, array($t0)

    #A[mid_right]
    sll $t0, $s3, 2
    lw $t2, array($t0)

    #A[mid_left++]=A[mid_right]
    sll $t0, $s2, 2
    sw $t2, array($t0)
    addi $s2, $s2, 1

    #A[i]
    sll $t0, $s1, 2
    lw $t3, array($t0)

    #A[mid_right--]=A[i]
    sll $t5, $s3, 2
    sw $t3, array($t5)
    addi $s3, $s3, -1

    #A[i++] = pivot
    sll $t0, $s1, 2
    sw $s0, array($t0)
    addi $s1, $s1, 1

    j loop

ra: jr		$ra					# jump back to partition



# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
