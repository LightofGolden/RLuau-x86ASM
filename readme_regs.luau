--[[
eax = accumulator (for arithmetic and return)
ebx = base register (general)
ecx = counter (for loops)
edx = data register (for i/o, mul and div)
esi = source index (for string processing)
edi = destination index (for string processing)
ebp = base pointer (for stack frames and base pointer)
esp = stack pointer (for stack operations)
eip = instruction pointer (for branching and call instructions)
ZF	Zero Flag	Kết quả == 0
SF	 Sign Flag	Kết quả âm (bit cao nhất == 1)
OF	Overflow Flag	Tràn số có dấu (signed overflow)
CF	Carry Flag	Tràn số không dấu (unsigned carry/borrow)
PF	Parity Flag	Số bit 1 trong kết quả là chẵn
]]