# MNHoang - ITITIU21208
.data
    msg: .asciiz "Fibonacci Series (First 100 terms):\n"
    overflow_msg: .asciiz "\nOverflow occurred. Exiting..."

.text
.globl main
main:
    # Print the heading
    li $v0, 4
    la $a0, msg
    syscall

    # Initialize registers
    li $t0, 0  # Current term
    li $t1, 1  # Previous term
    li $t2, 1  # Counter

    # Print the first two terms
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 11
    li $a0, ','
    syscall
    li $a0, ' '
    syscall
    move $a0, $t1
    li $v0, 1
    syscall

    # Loop for the remaining 98 terms
loop:
    beq $t2, 100, exit  # Exit if 100 terms are printed

    # Check for overflow before calculating the next term
    bge $t1, 0x7FFFFFFF, overflow_exit  # Exit if overflow is imminent

    # Calculate the next term
    add $t3, $t0, $t1  # $t3 = $t0 + $t1

    # Print the current term
    li $v0, 11
    li $a0, ','
    syscall
    li $a0, ' '
    syscall
    move $a0, $t3
    li $v0, 1
    syscall

    # Update registers
    move $t0, $t1  # Previous term = Current term
    move $t1, $t3  # Current term = New term
    addi $t2, $t2, 1  # Increment counter

    j loop

overflow_exit:
    li $v0, 4
    la $a0, overflow_msg
    syscall
    j exit

exit:
    li $v0, 10
    syscall