#include <stdint.h>
#include <stdio.h>
#include <string.h>

extern uint64_t get_cycles();
extern void palindrome_detection_origin();
extern void palindrome_detection_modify1();
extern void palindrome_detection_modify2();

int main(void)
{
    /* measure cycles */
    /* origin */
    uint64_t oldcount = get_cycles();
    palindrome_detection_origin();
    uint64_t cyclecount = get_cycles() - oldcount;
    printf("origin cycle count: %u\n", (unsigned int) cyclecount);
    
    /* modify1 */
    oldcount = get_cycles();
    palindrome_detection_modify1();
    cyclecount = get_cycles() - oldcount;

    printf("modify1 cycle count: %u\n", (unsigned int) cyclecount);
    
    /* modify2 */
    oldcount = get_cycles();
    palindrome_detection_modify2();
    cyclecount = get_cycles() - oldcount;

    printf("modify2 cycle count: %u\n", (unsigned int) cyclecount);

    return 0;
}
