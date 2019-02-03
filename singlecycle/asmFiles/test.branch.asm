# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                       #
#   File name: test.branch.asm                                          #
#                                                                       #
#   Date created: 01/23/19                                              #
#                                                                       #
#   Programmer: James Weber                                             #
#                                                                       #
#   Lab/HW #: 03                                                        #
#                                                                       #
#   Description: Tests branches					                        #
#                                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

org 0x00
main:	
	ori $s0, $0, 1
	beq $0, $s0, equal
	beq $0, $0, equal

not_equal:
	halt

equal:
	bne $0, $0, not_equal
	bne $s0, $0, not_equal
	halt
	
