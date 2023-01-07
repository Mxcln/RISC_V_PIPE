@echo off
set /p var=please input the C file to be compiled:
md build
set var_build=build/
set var_c=.c
set var_s=.s
set var_o=.o
set var_data=.data

riscv-none-embed-gcc -mabi=ilp32 -march=rv32i -S %var%%var_c% -o %var_build%%var%%var_s%
riscv-none-embed-as -mabi=ilp32 -march=rv32i  %var_build%%var%%var_s% -o %var_build%%var%%var_o%
riscv-none-embed-objcopy -I elf32-littleriscv %var_build%%var%%var_o% -O verilog %var_build%%var%%var_data%
REM riscv-none-embed-ld -m elf32lriscv main.o -o main.x
REM reverse.exe < /%var_build%%var%