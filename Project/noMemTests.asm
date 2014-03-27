#################################################################################
# Craig Day
# ECE 552
# WISC architecture test bench
# 
# All tests are perfomed assuming that LLB, SUB, and B EQ work properly
#################################################################################

#   We assume that BEQ, LLB, and halt works

T_ADD:                  # test the ADD and SUB operations
    LLB R5, 0x05        # R5 <= 0x0005
    LLB R1, 0x05        # R1 <= 0x0005
    LLB R2, 0x07        # R2 <= 0x0007
    LLB R3, 0x0C        # R3 <= 0x000C
    ADD R1, R1, R2      
    SUB R0, R1, R3
    B EQ, T_ADD2        # if R1 == R3, test passed
    HLT                 # test failed

T_ADDZ:                 # test the ADDZ opperation
    LLB R5, 0x07        # R5 <= 0x0007
    LLB R1, 0x02        # R1 <= 0x0002
    LLB R2, 0x01        # R2 <= 0x0001
    SUB R0, R1, R2      # clear the Z flag
    LLB R1, 0x72        # R1 <= 0x0072
    LLB R2, 0x22        # R2 <= 0x0072
    LLB R3, 0x72        # R3 <= 0x0072
    ADDZ R1, R1, R2
    SUB R0, R1, R3
    B EQ, T_ADDZ2
    HLT

T_AND:                  # test the AND operation
    LLB R1, 0xFF        # R1 <= 0xFFFF
    AND R1, R1, R0      # R1 <= 0xFFFF & 0x0000
    SUB R0, R1, R0      # set flags with R1 - 0
    B EQ, T_NOR         # if R1 == 0, test passed
    HLT                 # if we are here, the AND test failed, halting

T_NOR:                  # test the NOR operation
    LLB R5, 0x01
    LLB R1, 0x85        # R1 <= 0x0005
    LLB R2, 0x86        # R2 <= 0x0006
    LLB R3, 0x78        # R3 <= 0x0008
    NOR R4, R1, R2      # R1 <= ~(R1 | R2)
    SUB R0, R4, R3
    B EQ, T_SLL         # if R1 == R3, test passed
    HLT                 # if we get here, test NOR failed, halting 

T_SLL:                  # test logical shift left, SLL
    LLB R5, 0x02
    LLB R1, 0x07        # R1 <= 0x0007
    LLB R2, 0x70        # R2 <= 0x0070
    SLL R1, R1, 4       # R1 <= R1 << 4
    SUB R0, R1, R2      # compare R1 and R2, should be equal and set Z
    B EQ, T_SRL         # if R1 == R2, test SLL passed
    HLT                 # if we get here, the SLL test failed, halting

T_SRL:                  # test logical shift right, SRL
    LLB R5, 0x03
    LLB R1, 0x70
    LLB R2, 0x07
    SRL R1, R1, 4
    SUB R0, R1, R2
    B EQ, T_SRA         # R1 == R2, test passed
    HLT                 # test failed

T_SRA:                  # test arithmatic shift right, SRA
    LLB R5, 0x04
    LLB R1, 0xF0
    LLB R2, 0xFF
    SRA R1, R1, 4
    SUB R0, R1, R2      
    B EQ, T_ADD         # if R1 == R2, test passed
    HLT                 # test failed

T_LHB:
    LLB R5, 0x09
    LLB R1, 0x00
    LLB R2, 0xBC
    SLL R2, R2, 8
    LHB R1, 0xBC
    SUB R0, R1, R2
    B EQ, T_B_UNCOND    # if R1 == R2, test passed
    HLT                 # test failed

    #well we know, or at least hope, that B EQ has worked so lets try the others
T_B_UNCOND:
    B UNCOND,  T_NEQ

T_NEQ:
    LLB R5, 0x09
    LLB R1, 0x08
    SUB R0, R5, R1
    B NEQ, T_GT
    HLT

T_GT:   #9-8 is > 0 so we can just use the flags set above
    B GT, T_GTE
    HLT

T_GTE:  #Test the greater part of GTE
    B GTE, T_GTE2
    HLT

T_GTE2: #Test equal part of GTE
    SUB R0, R9, R9
    B GTE, T_LT
    HLT

T_LTE:  #Test equal part of LTE
    B LTE, T_LTE2
    HLT

T_LTE2: #Test less than part of LTE
    SUB R0, R1, R5  #8-9 < 0
    B LT, T_LT
    HLT

T_LT:   #reuse flags set above
    B LT, T_OVFL
    HLT

T_OVFL:
    LLB R5, 0xFF    #sign extended on load to 0xFFFF
    LLB R1, 0xFF
    ADD R0, R1, R5
    B OVFL, T_ADD2
    HLT
    
# end of basic test

#*******************************************************************************

# we now begin edge cases
T_ADD2:
    LLB R5, 0x06
    #test saturating addition here, not implementing yet

T_ADDZ2:
    LLB R5, 0x08
    SUB R0, R0, R0      # set the Z flag
    LLB R1, 0x52
    LLB R2, 0x22
    LLB R3, 0x74
    ADDZ R1, R1, R2     
    SUB R0, R1, R3
    B EQ, T_LHB         # if R1 == R3, test passed
    HLT                 # test failed

DONE:
    LLB R5, 0xAA
    LHB R5, 0xAA        # set R5 = 0xAAAA to signify all tests passed
    HLT
