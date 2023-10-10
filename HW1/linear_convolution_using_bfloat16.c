#include <stdio.h>
#include <stdlib.h>

float fp32_to_bf16(float x) {
    float y = x;
    int *p = (int *) &y;
    unsigned int exp = *p & 0x7F800000;
    unsigned int man = *p & 0x007FFFFF;
    if (exp == 0 && man == 0) /* zero */
        return x;
    if (exp == 0x7F800000) /* infinity or NaN */
        return x;

    /* Normalized number */
    /* round to nearest */
    float r = x;
    int *pr = (int *) &r;
    *pr &= 0xFF800000;  /* r has the same exp as x */
    r /= 0x100;
    y = x + r;

    *p &= 0xFFFF0000;

    return y;
}

void fp32_to_bf16_in_arr(float* arr, int len) {
    while(len) {
        *arr = fp32_to_bf16(*arr);
        arr += 1;
        len--;
    }
}

void printResult(float* signal, int len) {
    for(int i=0; i<len; i++) {
        printf("%f ", *(signal + i));
    }
    printf("\n");
}

float* convolution_with_bf16(float* signal, float* impulse, int sLen, int impluseLen) {
    int l = sLen + impluseLen -1;
    float* output = (float*) malloc(sizeof(float)*l);

    /* convert signal from FP32 format to BF16 format */
    fp32_to_bf16_in_arr(signal, sLen);
    fp32_to_bf16_in_arr(impulse, impluseLen);

    /* do linear convolution */
    for(int n=0; n<l; n++) {
        output[n] = 0.0;
        for(int k=0; k<sLen; k++) {
            if((n-k) >= 0 && (n-k) <= impluseLen) {
                output[n] +=  signal[k] * impulse[n-k]; 
            }
        }
    }

    return output;
}

int main() {
    float signal1[3] = {1.2, 1.3, 1.4};
    float impulse1[3] = {2.1, 3.2, 2.1};

    float* result1 = convolution_with_bf16(signal1, impulse1, 3, 3);
    printResult(result1, 3+3-1);
    
    return 0;
}