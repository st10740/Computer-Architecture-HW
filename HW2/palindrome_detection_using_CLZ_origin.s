.text
.global main
main:
    li a0, 0x00000003
    li a1, 0x00000C00
    jal ra, count_leading_zeros

    # check is palindrome or not
    li a2, 64
    sub a2, a2, a0
    li a0, 0x00000003
    li a1, 0x00000C00
    jal ra, palindrome_detected
    addi a7, zero, 1
    ecall
    
    # Exit program
    addi a7, zero, 10
    ecall

count_leading_zeros:
    addi sp, sp, -4 
    sw ra, 0(sp)
    add t1, a0, zero # t1 = low 32bits
    add t0, a1, zero # t0 = high 32bits


    # x |= (x >> 1);
    slli t2, t0, 31 # high 32bits shift left 31
    srli t3, t1, 1 # low 32bits shift right 1
    or t3, t2, t3
    srli t2, t0, 1 # high 32bits shift right 1
    or t0, t0, t2
    or t1, t1, t3
    # x |= (x >> 2);
    slli t2, t0, 30
    srli t3, t1, 2
    or t3, t2, t3
    srli t2, t0, 2
    or t0, t0, t2
    or t1, t1, t3
    # x |= (x >> 4);
    slli t2, t0, 28
    srli t3, t1, 4
    or t3, t2, t3
    srli t2, t0, 4
    or t0, t0, t2
    or t1, t1, t3
    # x |= (x >> 8);
    slli t2, t0, 24
    srli t3, t1, 8
    or t3, t2, t3
    srli t2, t0, 8
    or t0, t0, t2
    or t1, t1, t3
    # x |= (x >> 16);
    slli t2, t0, 16
    srli t3, t1, 16
    or t3, t2, t3
    srli t2, t0, 16
    or t0, t0, t2
    or t1, t1, t3
    # x |= (x >> 32);
    or t1, t0, t1
    
    # !!!count ones!!!
    # x -= (x>>1) & 0x5555555555555555
    slli t2, t0, 31 # x>>1
    srli t3, t1, 1
    or t3, t2, t3
    srli t2, t0, 1
    li t4, 0x55555555 # & 0x5555555555555555
    and t2, t2, t4
    and t3, t3, t4
    sltu t5, t1, t3 # t5 = borrow bit
    sub t0, t0, t2
    sub t0, t0, t5
    sub t1, t1, t3
    
    # x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333)
    slli t2, t0, 30 # x>>2
    srli t3, t1, 2
    or t3, t2, t3
    srli t2, t0, 2
    li t4, 0x33333333 # & 0x333333333333333
    and t2, t2, t4
    and t3, t3, t4
    
    and t0, t0, t4 # x & 0x3333333333333333
    and t1, t1, t4
    add t1, t1, t3 # add into x
    sltu t5, t1, t3 # t5 = carry bit
    add t0, t0, t2 
    add t0, t0, t5
    
    # x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f
    slli t2, t0, 28 # (x>>4) + x
    srli t3, t1, 4
    or t3, t2, t3
    srli t2, t0, 4
    add t3, t3, t1
    sltu t5, t3, t1
    add t2, t2, t0
    add t2, t2, t5
    li t4, 0x0f0f0f0f # & 0x0f0f0f0f0f0f0f0f
    and t0, t2, t4
    and t1, t3, t4
    
    # x += (x >> 8)
    slli t2, t0, 24
    srli t3, t1, 8
    or t3, t2, t3
    srli t2, t0, 8
    add t1, t1, t3
    sltu t5, t1, t3 # t5 = carry bit
    add t0, t0, t2
    add t0, t0, t5
    
    # x += (x >> 16)
    slli t2, t0, 16
    srli t3, t1, 16
    or t3, t2, t3
    srli t2, t0, 16
    add t1, t1, t3
    sltu t5, t1, t3 # t5 = carry bit
    add t0, t0, t2
    add t0, t0, t5
    
    # x += (x >> 32)
    mv t2, t0
    add t1, t1, t2
    sltu t5, t1, t2
    add t0, t0, t5
    
    # return (64 - (x & 0x7f))
    andi t1, t1, 0x7f
    mv a0, t1
    li t2, 64
    sub a0, t2, t1
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
    
palindrome_detected:
    addi sp, sp, -4
    sw ra, 0(sp)
    mv t1, a0         # low 32 bits
    mv t0, a1         # high 32 bits
    
    andi t5, a2, 0x1  # t5 = (input number is odd) ? 1 : 0
    srai t4, a2, 1    # t4 = input bit number / 2
    add t4, t4, t5    # t4 = input bit number / 2 + checkEven
    
    # x >> (input bit number / 2 + checkEven)
    li t5, 32
    sub t4, t5, t4    # t4 = 32 - t4
    sll t2, t0, t4
    sub t4, t5, t4    # (32 - t4) back to t4
    srl t3, t1, t4
    or t3, t2, t3     # t3 = left half of input number
    
    # t2 = reversed number
    li t2, 0          # t2 = reversed right half of input number
    li t5, 0          # t5 = i
    li t0, 32
    reverse_loop:
        srl t6, t3, t5
        andi t6, t6, 1
        slli t2, t2, 1
        or t2, t2, t6
        addi t5, t5, 1 # i++
        blt t5, t0, reverse_loop

    li t5,2
    li t3, 32
    srai t5, a2, 1
    sub t5, t3, t5
    srl t2, t2, t5
    
    # t3 = right half bit
    li t6, 32
    mv t3, a0
    srai t5, a2, 1
    sub t5, t6, t5
    sll t3, t3, t5
    srl t3, t3, t5
     
    # compare different
    beq t2, t3, isPalindrome
    li a0, 0
    jr ra
    
    isPalindrome:
        li a0, 1
        jr ra