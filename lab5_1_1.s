# MNHoang - ITITIU21208
.data
prompt: .asciiz "Enter an unsigned integer (0-15): "
invalid: .asciiz "Invalid Input\n"
hexChars: .asciiz "0123456789ABCDEF"
prefix: .asciiz "0x"

.text
.globl main
main:
  li $t1, 16          # store 16 in $t1

input_loop:
  li $v0, 4           # syscall for print string
  la $a0, prompt      # load address of prompt
  syscall

  li $v0, 5           # syscall for read integer
  syscall             # read integer to $v0

  blt $v0, $zero, invalid_input
  bge $v0, $t1, invalid_input

  div $v0, $t1        # divide $v0 by 16, quotient in $LO, remainder in $HI
  mfhi $t2            # move remainder (HI) to $t2

  li $v0, 4           # syscall for print string
  la $a0, prefix      # load address of prefix
  syscall

  lbu $a0, hexChars($t2) # load byte (unsigned) of corresponding hex character into $a0

  li $v0, 11          # syscall for print character
  syscall

  li $v0, 10          # syscall for exit
  syscall

invalid_input:
  li $v0, 4           # syscall for print string
  la $a0, invalid     # load address of invalid input message
  syscall

  j input_loop        # jump back to start of input loop