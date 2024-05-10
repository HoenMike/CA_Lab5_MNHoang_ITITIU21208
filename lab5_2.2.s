# MNHoang - ITITIU21208
.data
msg:            .asciiz "Enter the number of terms: "
newline:        .asciiz "\n"
overflow_msg:   .asciiz "Overflow occurred. Exiting..."

.text
.globl main
main:
    # Prompt the user for input
    li $v0, 4
    la $a0, msg
    syscall

    # Read the number of terms
    li $v0, 5
    syscall
    move $a0, $v0

    # Call the fibonacci function
    jal fibonacci

    # Exit the program
    li $v0, 10
    syscall

fibonacci:
    # Save registers
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    # Initialize registers
    move $s0, $a0  # Number of terms
    li $s1, 1      # First term
    li $s2, 1      # Second term
    li $s3, 2      # Counter

    # Print the first term
    li $v0, 1
    move $a0, $s1
    syscall

    # Print the second term
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 1
    move $a0, $s2
    syscall

    # Loop for the remaining terms
loop:
    beq $s3, $s0, exit  # Exit if all terms are printed

    # Check for overflow before calculating the next term
    bge $s2, 0x7FFFFFFF, overflow_exit  # Exit if overflow is imminent

    # Calculate the next term
    add $t1, $s1, $s2  # $t1 = $s1 + $s2

    # Print the current term
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 1
    move $a0, $t1
    syscall

    # Update registers
    move $s1, $s2  # Previous term = Current term
    move $s2, $t1  # Current term = New term
    addi $s3, $s3, 1  # Increment counter

    j loop

overflow_exit:
    li $v0, 4
    la $a0, overflow_msg
    syscall
    j exit

exit:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20

    jr $ra