# Defines the subroutines power and factorial, for use in calculating e^x.
         .data
enterX:  .asciiz    "Enter x: "
enterN:  .asciiz    "Enter n: "
factP:   .asciiz    "n! = "
powP:    .asciiz    "x^n = "
         .globl     main
         .text
main:
         li         $v0, 4       # Code for print_str
         la         $a0, enterX  # load address of enterX
         syscall
         li         $v0, 5       # Code for read_int
         syscall
         move       $t1, $v0     # Save x to $t1

         li         $v0, 4       # Code for print_str
         la         $a0, enterN  # load address of enterX
         syscall

         li         $v0, 5       # Code for read_int
         syscall

         move       $t2, $v0     # Save n to $t2
         move       $a0, $t2     # Pass n as an argument
         jal        FACT         # Compute n!
         move       $t3, $v0     # Store the result
         li         $v0, 4       # Code for print_str
         la         $a0, factP   # load address of factP
         syscall

         li         $v0, 1       # Code for print_int
         move       $a0, $t3     # Load the integer result
         syscall                 # Print the result

         move       $a0, $t2     # Pass x as an argument
         move       $a1, $t1     # Pass n as another argument
         jal        POW          # Compute x^n
         move       $t2, $v0     # Store the result
         j          exit

FACT:    li         $t0, 1       # t0 will hold the result
         move       $t1, $a0     # t1 keeps track of the number to multiply by
floop:   beq        $t1, $zero, fdone
                                 # Exit the loop if done
         mul        $t0, $t0, $t1# Multiply the current result by t1
         addi       $t1, -1      # Decrement t1
         j          floop        # Loop, checking if t1 is zero yet
fdone:   move       $v0, $t0
         jr         $ra          # Return to caller

POW:     # Something
         jr         $ra          # Return to caller

exit:    li         $v0, 10      # System call code for exit 
         syscall                 # Return control to system

