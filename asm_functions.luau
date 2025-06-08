local asm_func = {}
local regs = script.Parent.registers
local function resolve(reg)
	if tonumber(reg) then
		return tonumber(reg)
	else 
		return regs[reg].Value
	end
end
return {
mov = function(reg1, reg2)
	regs[reg1].Value = resolve(reg2)
end
,
add = function(reg1, reg2)
	regs[reg1].Value += resolve(reg2)
end
,
sub = function(reg1, reg2)
	regs[reg1].Value -= resolve(reg2)
end
,
inc = function(reg1)
	regs[reg1].Value += 1
end
,
dec = function(reg1)
	regs[reg1].Value -= 1
end
,
mul = function(reg1)
	regs[reg1].Value = regs[reg1].Value * regs["eax"].Value
end
,
imul = function(reg1)
	regs[reg1].Value = regs[reg1].Value * regs["eax"].Value
end

}