local regs = script.Parent.registers
local flags = script.Parent.flags
local function resolve(reg)
	if tonumber(reg) then
		return tonumber(reg)
	else 
		return regs[reg].Value
	end
end
local function flagcheck(res)
	if res == 0 then
		flags["zf"].Value = 1
	else
		flags["zf"].Value = 0
	end
	if res < 0 then
		flags["sf"].Value = 1
	else
		flags["sf"].Value = 0
	end
end
local function resetflag()
	for _, f in pairs(flags:GetChildren()) do
		f.Value = 0
	end
end


return {
--Other

-- Data transfer
mov = function(reg1, reg2)
	regs[reg1].Value = resolve(reg2)
end
,
-- Arithmetic
add = function(reg1, reg2)
	local num1 = regs[reg1].Value
	local num2 = resolve(reg2)
	local res = num1 + num2
	regs[reg1].Value = res
	
	resetflag()
	flags["cf"].Value = (res > 0xFFFFFFFF) and 1 or 0
	flagcheck(regs[reg1].Value)
end
,
sub = function(reg1, reg2)
	local num1 = regs[reg1].Value
	local num2 = resolve(reg2)
	local res = num1 - num2
	regs[reg1].Value = res
		resetflag()
	flags["cf"].Value = (num1 < num2) and 1 or 0
	flagcheck(regs[reg1].Value)
end
,
s_add = function(reg1, reg2)
		local num1 = regs[reg1].Value
		local num2 = resolve(reg2)
		local res = num1 + num2
		regs[reg1].Value = res
		
		resetflag()
		if (num1 > 0 and num2 > 0 and res < 0) or 
			(num1 < 0 and num2 < 0 and res > 0) then
			flags["of"].Value = 1
		else
			flags["of"].Value = 0
		end
		flagcheck(regs[reg1].Value)
	end
	,
s_sub = function(reg1, reg2)
		local num1 = regs[reg1].Value
		local num2 = resolve(reg2)
		local res = num1 - num2
		regs[reg1].Value = res
		resetflag()
		flags["cf"].Value = (num1 < num2) and 1 or 0
		if (num1 >= 0 and num2 < 0 and res < 0) or 
			(num1 < 0 and num2 >= 0 and res >= 0) then
			flags["of"].Value = 1
		end
		flagcheck(regs[reg1].Value)
	end
	,
inc = function(reg1)
	regs[reg1].Value += 1
		flagcheck(regs[reg1].Value)
end
,
dec = function(reg1)
	regs[reg1].Value -= 1
		flagcheck(regs[reg1].Value)
end
,
mul = function(reg1)
	if type(regs["eax"].Value) ~= "number" then
		warn("Error: EAX must be initialized before using mul/imul (eax is not a number)")
		return
	else
		regs[reg1].Value = regs[reg1].Value * regs["eax"].Value
			flagcheck(regs[reg1].Value)
	end
end
,
imul = function(reg1)
	regs[reg1].Value = regs[reg1].Value * regs["eax"].Value
		flagcheck(regs[reg1].Value)
end
,
div = function(reg1)
		if regs["edx"] ~= 0 then
			warn("Error: EDX must be 0!")
		elseif regs["eax"] < 0 then
			warn("Error: attempted unsigned division on negative value.")
		else
			local dividend = regs["eax"].Value
			local divisor = resolve(reg1)
			if divisor == 0 then
				warn("Error: cannot divide by 0. (divisor = 0)")
				return
			end
			regs["eax"].Value = dividend // divisor
			regs["edx"].Value = dividend % divisor
		end
end
,
idiv = function(reg1)
		local dividend = regs["eax"].Value
		local divisor = resolve(reg1)
		regs["eax"].Value = dividend // divisor
		regs["edx"].Value = dividend % divisor
end
,
neg = function(reg1)
	if regs[reg1].__signed == false then
		warn("Error: " .. reg1 .. " is unsigned, meaning it can not go under 0.")
		return
	end
	regs[reg1].Value = -regs[reg1].Value
end
,
-- Bitwise
-- Todo: test
asm_and = function(reg1, reg2)
	regs[reg1].Value = bit32.band(regs[reg1].Value,resolve(reg2))
		flagcheck(regs[reg1].Value)
end
,
asm_or = function(reg1,reg2)
	regs[reg1].Value = bit32.bor(regs[reg1].Value,resolve(reg2))
		flagcheck(regs[reg1].Value)
end
,
asm_xor = function(reg1, reg2)
	regs[reg1].Value = bit32.bxor(regs[reg1].Value,resolve(reg2))
		flagcheck(regs[reg1].Value)
end
,
asm_not = function(reg1)
	regs[reg1].Value = bit32.bnot(regs[reg1].Value)
end,
}