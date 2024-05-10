# MNHoang - ITITIU21208
.data
prompt: .asciiz "Enter a 32-bit integer: "
invalid: .asciiz "Invalid Input\n"
hexChars: .asciiz "0123456789ABCDEF"
prefix: .asciiz "0x"

.text
.globl main
main:
  li $t1, 16 # store 16 in $t1
  li $t2, 4 # store 4 in $t2 (used for shifting)

input_loop:
  li $v0, 4 # syscall for print string
  la $a0, prompt # load address of prompt
  syscall

  li $v0, 5 # syscall for read integer
  syscall # read integer to $v0

  move $a0, $v0 # move the input number to $a0
  jal printHex # jump to printHex procedure

  li $v0, 10 # syscall for exit
  syscall

printHex:
  move $t3, $a0 # copy the input number to $t3
  li $t6, 0 # initialize print flag to 0

  li $v0, 4 # syscall for print string
  la $a0, prefix # load address of prefix
  syscall

  li $t4, 28 # initialize shift amount to 28 (4 bytes * 8 bits - 4 bits)

hex_loop:
  srlv $t5, $t3, $t4 # shift $t3 right by $t4 bits and store in $t5
  andi $t5, $t5, 0xF # mask out all but the least significant 4 bits

  # if the digit is non-zero or we've started printing, set the print flag
  or $t6, $t6, $t5
  beqz $t6, skip_print

  lbu $a0, hexChars($t5) # load byte (unsigned) of corresponding hex character into $a0
  li $v0, 11 # syscall for print character
  syscall

skip_print:
  sub $t4, $t4, $t2 # decrement shift amount by 4
  bgez $t4, hex_loop # continue loop if shift amount is greater than or equal to zero

  jr $ra # return from procedure