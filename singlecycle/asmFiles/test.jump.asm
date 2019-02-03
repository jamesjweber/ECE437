# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                       #
#   File name: test.jump.asm                                            #
#                                                                       #
#   Date created: 01/23/19                                              #
#                                                                       #
#   Programmer: James Weber                                             #
#                                                                       #
#   Lab/HW #: 03                                                        #
#                                                                       #
#   Description: Tests jumps					                        #
#                                                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

org 0x00
main:	
	j jump_and_link

jump_1:
	jr $ra

jump_and_link:
	jal jump_1
	halt
