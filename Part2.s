# Computes exp(x) for a user-input value x.

         .data
enterX:  .asciiz    "Enter x: "
expX:    .asciiz    "exp(x) = "
         .globl     main
         .text
main:
         li         $v0, 4       # Code for print_str
         la         $a0, enterX  # Prompt user for x
         syscall
         li         $v0, 6       # Code for read_single
         syscall                 # $f0 <-- x

exit:    li         $v0, 10      # System call code for exit 
         syscall                 # Return control to system
