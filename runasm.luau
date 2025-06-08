local asm_func = require(script.Parent.asm_functions)
local regis = script.Parent.registers
 local code = [[
	mov eax, 1
	mov ebx, 2
	add eax, ebx
	sub ebx, 1
	inc ebx
	dec ebx
	mul ebx
]]
local linen = 0
for line in code:gmatch("([^\n]*)\n?") do
	local mne, r1, r2 = line:match("(%w+)%s+(%w+),?%s*(%w*)")
	mne = mne  ; r1 = r1  ; r2 = r2
	if mne == "mov" then
		asm_func.mov(r1, r2)
	elseif mne == "add" then
		asm_func.add(r1,r2)
	elseif mne == "sub" then
		asm_func.sub(r1,r2)
	elseif mne == "inc" then
		asm_func.inc(r1,r2)
	elseif mne == "dec" then
		asm_func.dec(r1,r2)
	elseif mne == "mul" then
		asm_func.mul(r1,r2)
	end
	linen += 1
	print(linen)
	for _, c in ipairs(regis:GetChildren()) do
		print(c.Name .. c.Value)
	end
end