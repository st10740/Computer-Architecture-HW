riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O0 palindrome_detection_using_CLZ_origin.c -o origin_O0.elf 
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O1 palindrome_detection_using_CLZ_origin.c -o origin_O1.elf 
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O2 palindrome_detection_using_CLZ_origin.c -o origin_O2.elf 
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O3 palindrome_detection_using_CLZ_origin.c -o origin_O3.elf 
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -Os palindrome_detection_using_CLZ_origin.c -o origin_Os.elf 

riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O0 palindrome_detection_using_CLZ_modified.c -o modified_O0.elf
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O1 palindrome_detection_using_CLZ_modified.c -o modified_O1.elf
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O2 palindrome_detection_using_CLZ_modified.c -o modified_O2.elf
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -O3 palindrome_detection_using_CLZ_modified.c -o modified_O3.elf
riscv-none-elf-gcc -march=rv32i -mabi=ilp32 -Os palindrome_detection_using_CLZ_modified.c -o modified_Os.elf

riscv-none-elf-objdump -d origin_O0.elf > disassembly/origin_O0.txt
riscv-none-elf-objdump -d origin_O1.elf > disassembly/origin_O1.txt
riscv-none-elf-objdump -d origin_O2.elf > disassembly/origin_O2.txt
riscv-none-elf-objdump -d origin_O3.elf > disassembly/origin_O3.txt
riscv-none-elf-objdump -d origin_Os.elf > disassembly/origin_Os.txt

riscv-none-elf-objdump -d modified_O0.elf > disassembly/modified_O0.txt
riscv-none-elf-objdump -d modified_O1.elf > disassembly/modified_O1.txt
riscv-none-elf-objdump -d modified_O2.elf > disassembly/modified_O2.txt
riscv-none-elf-objdump -d modified_O3.elf > disassembly/modified_O3.txt
riscv-none-elf-objdump -d modified_Os.elf > disassembly/modified_Os.txt