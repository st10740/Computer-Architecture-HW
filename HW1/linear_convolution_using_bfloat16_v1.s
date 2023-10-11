# This code only includes the implenetation of fp32_to_bf16 and test cases to ensure the program works as expect.
# The other parts of linear convolution by using bfloat16 have not yet been finished.
# because I'm stuck in implementing bfloat16 multiplication and addition myself.
# I will try to complete it as soon as possible.

.data
    test: .word 0x00000000 0x7F800000 0x700AB000 0xF00AB000 0x707F8FFF
            # exp=0 & man=0 | exp=0x7F800000 | normalized positive number | normalized negative number | normalized number with overflow after rounding to nearest
    exp_mask: .word 0x7F800000
    man_mask: .word 0x007FFFFF
    round: .word 8000
    bfloat16_man_plus_one_mask: .word 0x007F8000
    bfloat16_mask: .word 0xFFFF0000
    msg_before_str: .string "before convert to bfloat16: "
    msg_after_str: .string "after convert to bfloat16: "
    end_str: .string "\n"

.text
main:
    la s0, test
    li s1, 0                          # i
    li s2, 5                          # n
test_loop:
    beq s1, s2, exit                  # if i==5 break
    lw a0, 0(s0)                      # a0: test[i]
    jal do_fp32_to_bf16_and_print     
    addi s0, s0, 4                    # s0: address of test[i+1]
    addi s1, s1, 1                    # s1: i++
    j test_loop

exit:   
    li a7, 10                         # exit
    ecall
    
do_fp32_to_bf16_and_print:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)
    
    la a0, msg_before_str
    li a7, 4
    ecall                             # print "before convert to bfloat16: " 
    
    lw a0, 4(sp)
    li a7, 2
    ecall                             # print FP32 format
    
    la a0, end_str
    li a7, 4
    ecall                             # print "\n"
    
    la a0, msg_after_str
    li a7, 4
    ecall                             # print "after convert to bfloat16: " 
    
    lw a0, 4(sp)
    jal fp32_to_bf16
    li a7, 2
    ecall                             # print BF16 format
    
    la a0, end_str
    li a7, 4
    ecall                             # print "\n"
    
    lw ra, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8
    jr ra

fp32_to_bf16:
    addi sp, sp, -4
    sw ra, 0(sp)
    add t0, a0, zero                 # store a0 to t0
    lw t1, exp_mask                  
    and t2, t0, t1                   # t2: result of applying exp mask to t0
    beq t1, t2, return_fp32_to_bf16  # t0 is infinity or NaN, just return it
    beq t2, zero, exp_is_zero
    
normalized_number: 
    lw t1, bfloat16_man_plus_one_mask 
    lw t2, round                   
    and t3, t0, t1                    # t3: applying bfloat16_man_plus_one_mask to t0
    beq t1, t3, is_overflow           # doing round to nearest will cause overflow
    
    add t0, t0, t2                    # do round to nearest
    lw t1, bfloat16_mask           
    and a0, t0, t1                    # a0: applying bfloat16_mask to t0
    
return_fp32_to_bf16:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

exp_is_zero:
    lw t1, man_mask                
    and t1, t1, t0                    # t1: applying man_mask to t0
    bne t1, zero, normalized_number   # if t1!=0, t0 is normalized number
    j return_fp32_to_bf16             # else, t0 is zero, just return it

is_overflow:
    lw t1, bfloat16_mask
    and a0, t0, t1                    # do round down
    j return_fp32_to_bf16