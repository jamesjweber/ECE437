# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                       #
#   File name: test.halt.asm                                            #
#                                                                       #
#   Date created: 01/23/19                                              #
#                                                                       #
#   Programmer: James Weber                                             #
#                                                                       #
#   Lab/HW #: 03                                                        #
#                                                                       #
#   Description: Tests halt						                        #
#                                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

org 0x00
main:	
	bne	$0, $0, not_equal
	halt
	beq $0, $0, equal

not_equal:
	beq $0, $0, equal

equal:
	halt
	
