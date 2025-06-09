local rlx86ver = require(script.Parent.rluaux86asm_versioninfo)
local asm_func = require(script.Parent.asm_functions)
local regis = script.Parent.registers
local flags = script.Parent.flags
local eip = regis["eip"]
 local code = [[
 	mov eax, 2
 	mov ebx, 3
 	mul ebx
	neg ebx
]]
local linen = 0

rlx86ver.rlx86ver() -- Print version of RLuau-x86ASM
for line in code:gmatch("([^\n]*)\n?") do
	local mne, r1, r2 = line:match("(%w+)%s+(%w+),?%s*(%w*)")
	mne = mne  ; r1 = r1  ; r2 = r2
	if mne == "mov" then
		if r1 == "eip" then
			warn("Error: Cannot change value of EIP. Instruction ignored.")
		else
			asm_func.mov(r1,r2)
		end
	elseif mne == "add" then
		if regis[r1].__signed == true then
			asm_func.s_add(r1,r2)
		else
			asm_func.add(r1,r2)
		end
	elseif mne == "sub" then
		if regis[r1].__signed == true then
			asm_func.s_sub(r1,r2)
		else
			asm_func.sub(r1,r2)
		end
	elseif mne == "inc" then
		asm_func.inc(r1,r2)
	elseif mne == "dec" then
		asm_func.dec(r1,r2)
	elseif mne == "mul" then
		asm_func.mul(r1,r2)
	elseif mne == "imul" then
		asm_func.imul(r1,r2)
	elseif mne == "div" then
		asm_func.div(r1,r2)
	elseif mne == "idiv" then
		asm_func.idiv(r1,r2)
	elseif mne == "neg" then
		asm_func.neg(r1,r2)
	end
	linen += 1
	print(linen)
	for _, c in ipairs(regis:GetChildren()) do
		print(c.Name .. c.Value)
	end
	
	
end
for _, c in ipairs(regis:GetChildren()) do
	c.Value = 0
end

for _, c in ipairs(flags:GetChildren()) do
	c.Value = false
end
