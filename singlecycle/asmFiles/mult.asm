# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                       #
#   File name: mult.asm                                                 #
#                                                                       #
#   Date created: 01/14/19                                              #
#                                                                       #
#   Programmer: James Weber                                             #
#                                                                       #
#   Lab/HW #: 02                                                        #
#                                                                       #
#   Description: Multiplies two unsigned words.                         #
#                                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

org 0x00
main:	
	# Store stack pointer in s-register
	ori $s0, $0, 0x8FF4
	# Pop two unsigned numbers from the stack
	jal cust_pop
	or $a0, $0, $v0
	jal cust_pop
	or $a1, $0, $v0
	# Multiply the two unsigned numbers
	jal mult
	# Push result to the stack
	or $a0, $0, $v0
	jal cust_push
	halt

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#  ╔══════════╦═════════════╦════════╗
#  ║ asm      ║ c           ║ i/o/v  ║
#  ╠══════════╬═════════════╬════════╣
#  ║ a0 (R4)  ║ num_1       ║ input  ║
#  ║ a1 (R5)  ║ num_2       ║ input  ║
#  ║ v0 (R2)  ║ result      ║ output ║
#  ║ t0 (R8)  ║ multiplier  ║ var    ║
#  ║ t1 (R9)  ║ inner_prod  ║ var    ║
#  ║ t2 (R10) ║ ip_shifted  ║ var    ║
#  ║ t3 (R11) ║ shift_level ║ var    ║
#  ║ t4 (R12) ║ shift_one   ║ var    ║
#  ╚══════════╩═════════════╩════════╝

mult:  				  				# mult(int num_1, int num_2) {
	and $v0, $0, $0	  	  			#   int result = 0;
	and $t3, $0, $0		  			#   int shift_level = 0;
	addi $t4, $0, 1		  			#   int shift_one = 1;
	beq $a0, $0, return_mult  		#   if (!num_1 || !num_2)
	beq $a1, $0, return_mult  		#     return result;
mlt_out_loop:			  			#   while(num_2 > 0) {
	andi $t0, $a1, 1	  			#     int multiplier = num_2 & 0x1;
	and $t1, $0, $0		  			#     int inner_prod = 0;
	beq $t0, $0, mlt_out_loop_end 	#     
mlt_in_loop:			  			#     while (multiplier > 0) {
	add $t1, $t1, $a0	  			#       inner_prod += num_1;
	addi $t0, $t0, -1	  			#       multiplier -= 1;
	bne $t0, $0, mlt_in_loop  		#     }     
mlt_out_loop_end:					#
	sllv $t2, $t3, $t1	  			#     int ip_shifted = inner_prod << shift_level;
	add $v0, $v0, $t2 	  			#     result += ip_shifted;
	addi $t3, $t3, 1 	  			#     shift_level += 1;
	srlv $a1, $t4, $a1       		#     num_2 = num_2 >> 1;
	bne $a1, $0, mlt_out_loop 		#   }
return_mult:			  			#   return result;
	jr $ra 			  				# }
	 			 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cust_push:
	addi $s0, $s0, -4	# SP -= 4
	sw $a0, 0($s0)		# push(arg_1)
	jr $ra				# return

cust_pop:
	lw $v0, 0($s0)		# pop(return_val_1)
	addi $s0, $s0, 4	# SP += 4
	jr $ra 				# returns


# This data will be put on the stack
org 0x8FF8
	cfw 0x29
	cfw 0x34
