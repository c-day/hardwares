#################################################################################
# Craig Day
# ECE 552
# WISC architecture test bench
# 
# All tests are perfomed assuming that LLB, SUB, and B EQ work properly
#################################################################################

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

T_ADD:
    LLB R5, 0x05
    LLB R1, 0x05
    LLB R2, 0x07
    LLB R3, 0x0C
    ADD R1, R1, R2
    SUB R0, R1, R3
    B EQ, T_ADD2        # if R1 == R3, test passed
    HLT                 # test failed

T_ADD2:
    LLB R5, 0x06
    #test saturating addition here, not implementing yet

T_ADDZ:
    LLB R5, 0x07
    LLB R1, 0x02
    LLB R2, 0x01
    SUB R0, R1, R2      # clear the Z flag
    LLB R1, 0x72
    LLB R2, 0x22
    LLB R3, 0x72
    ADDZ R1, R1, R2
    SUB R0, R1, R3
    B EQ, T_ADDZ2
    HLT

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

T_LHB:
    LLB R5, 0x09
    LLB R1, 0x00
    LLB R2, 0xBC
    SLL R2, R2, 8
    LHB R1, 0xBC
    SUB R0, R1, R2
    B EQ, DONE          # if R1 == R2, test passed
    HLT                 # test failed

DONE:
    LLB R5, 0xAA
    LHB R5, 0xAA        # set R5 = 0xAAAA to signify all tests passed
    HLT
