# Defines the subroutines power and factorial, for use in calculating e^x.
         .data
enterX:  .asciiz    "Enter x: "
enterN:  .asciiz    "Enter n: "
factP:   .asciiz    "n! = "
powP:    .asciiz    "x^n = "
newL:    .asciiz    "\n"
         .globl     main
         .text

         # Registers:
         # $f0: x
         # $t0: n
main:
         li         $v0, 4       # Code for print_str
         la         $a0, enterX  # Prompt user for x
         syscall
         li         $v0, 6       # Code for read_single
         syscall                 # $f0 <-- x

         li         $v0, 4       # Code for print_str
         la         $a0, enterN  # load address of enterX
         syscall

         li         $v0, 5       # Code for read_int
         syscall

         move       $t0, $v0     # Save n to $t0
         move       $a0, $t0     # Pass n as an argument
         jal        FACT         # Compute n!
         move       $t1, $v0     # Store the result
         li         $v0, 4       # Code for print_str
         la         $a0, factP   # load address of factP
         syscall
         li         $v0, 1       # Code for print_int
         move       $a0, $t1     # Load the integer result
         syscall                 # Print the result

         li         $v0, 4       # Code for print_str
         la         $a0, newL    # Print newline
         syscall

         move       $a0, $t0     # Pass n as an argument
         jal        POW          # Compute x^n, x is in $f0, result goes in $f2
         li         $v0, 4       # Code for print_str
         la         $a0, powP    # Print "x^n = "
         syscall

         li         $v0, 2       # Code for print_float
         mov.s      $f12, $f2    # Load the float for syscall
         syscall                 # Print the result
         j          exit

FACT:    li         $t2, 1       # t2 will hold the result
         move       $t1, $a0     # t1 keeps track of the number to multiply by
floop:   beq        $t1, $zero, fdone
                                 # Exit the loop if done
         mul        $t2, $t2, $t1# Multiply the current result by t1
         addi       $t1, $t1, -1 # Decrement t1
         j          floop        # Loop, checking if t1 is zero yet
fdone:   move       $v0, $t2     # Load the result into the result register
         jr         $ra          # Return to caller

POW:     move       $t0, $a0     # $t0 is the counter, goes from n to 0
         li.s       $f2, 1.0     # $f2 holds the result, x is in $f0
ploop:   beq        $t0, $zero, pdone
                                 # If counter = 0, we're done
         mul.s      $f2, $f2, $f0# Multiply the result by x
         addi       $t0, $t0, -1 # Decrement n
         j          ploop        # Loop, checking if counter is 0
pdone:   jr         $ra          # Return to caller

exit:    li         $v0, 10      # System call code for exit 
         syscall                 # Return control to system

