# Computes exp(x) for a user-input value x.

         .data
enterX:  .asciiz    "Enter x: "
expX:    .asciiz    "exp(x) = "
         .globl     main
         .text

         # Registers:
         # $t0: POW counter
         # $t1: FACT counter
         # $t2: FACT result
         # $t3: n for Taylor Series expansion
         # $t4: Holds 11, the point at which to branch to 'exit'
         # $f0: x for Taylor Series expansion
         # $f2: The result of x^n for the current term
         # $f4: For holding n! and the current term
         # $f6: The total for the expansion

main:
         li         $v0, 4       # Code for print_str
         la         $a0, enterX  # Prompt user for x
         syscall
         li         $v0, 6       # Code for read_single
         syscall                 # $f0 <-- x
         li         $t3, 0       # Initialize n
         li         $t4, 11      # Initialize the endpoint for n
         li.s       $f6, 0.0     # Initialize the total
mloop:   beq        $t3, $t4, exit
                                 # If n > 10, we're done
         # First calculate x^n
         move       $a0, $t3     # Pass n as an arg to POW, x already is in $f0
         jal        POW          # Calculate x^n --> $f2

         # Then calculate n!
         move       $a0, $t3     # Pass n as an arg to FACT
         jal        FACT         # Calculate n!
         mtc1       $v0, $f4     # Move n! to the float coprocessor register
         cvt.s.w    $f4, $f4     # Convert n! from int to float
         div.s      $f4, $f2, $f4# Divide x^n by n! and store it in $f4
         add.s      $f6, $f6, $f4# Add (x^n)/(n!) to the total

         addi       $t3, $t3, 1  # Increment n
         j          mloop        # Rinse and repeat!

# POW takes a single-float argument from f0 (the base) and an integer
# argument from a0 (the exponent).  It returns the result in f2.
# It uses the registers t0, f0, and f2.

POW:     move       $t0, $a0     # $t0 is the counter, goes from n to 0
         li.s       $f2, 1.0     # $f2 holds the result, x is in $f0
ploop:   beq        $t0, $zero, pdone
                                 # If counter = 0, we're done
         mul.s      $f2, $f2, $f0# Multiply the result by x
         addi       $t0, $t0, -1 # Decrement n
         j          ploop        # Loop, checking if counter is 0
pdone:   jr         $ra          # Return to caller

# FACT takes an argument from a0 and returns the factorial in v0.
# It uses the registers t1 and t2.

FACT:    li         $t2, 1       # t2 will hold the result
         move       $t1, $a0     # t1 keeps track of the number to multiply by
floop:   beq        $t1, $zero, fdone
                                 # Exit the loop if done
         mul        $t2, $t2, $t1# Multiply the current result by t1
         addi       $t1, $t1, -1 # Decrement t1
         j          floop        # Loop, checking if t1 is zero yet
fdone:   move       $v0, $t2     # Load the result into the result register
         jr         $ra          # Return to caller

exit:    li         $v0, 4       # Code for print_str
         la         $a0, expX    # Print "exp(x) = "
         syscall
         mov.s      $f12, $f6    # Pass the expansion as an argument
         li         $v0, 2       # Code for print_single (float)
         syscall
         li         $v0, 10      # System call code for exit 
         syscall                 # Return control to system
