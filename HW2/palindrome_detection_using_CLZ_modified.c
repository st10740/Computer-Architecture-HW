#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// count how many zeros forwards input number
uint16_t count_leading_zeros(uint64_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555 );
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}

int palindrome_detected(uint64_t x, int clz){
    uint64_t nob = (64 - clz);
    uint64_t checkEven = nob % 2;
    uint64_t left = x >> (nob/2+checkEven);
    uint64_t revRight = 0x0;

    /* Reverse the right half of the input x*/
    for(int i=0; i<nob/2; i++) {
        uint64_t rightestBit = x & 0x1;
        revRight = revRight << 1;
        revRight |= rightestBit;
        x = x >> 1;
    }

    return (left==revRight) ? 1 : 0;
}

int main(){
    uint64_t testA = 0x0000000000000000; //0 is palindrome
    uint64_t testB = 0x0000000000000002; //testB not palindrome
    uint64_t testC = 0x00000C0000000003; //testC is palindrome
    uint64_t testD = 0x0F000000000000F0; //testD not palindrome
    printf("%d\n", palindrome_detected(testA, count_leading_zeros(testA)));
    printf("%d\n", palindrome_detected(testB, count_leading_zeros(testB)));
    printf("%d\n", palindrome_detected(testC, count_leading_zeros(testC)));
    printf("%d\n", palindrome_detected(testD, count_leading_zeros(testD)));
}