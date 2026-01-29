-- core.lua (Hidden Core)
repeat task.wait() until game:IsLoaded()

-- فك سترنق
local function _s(t)
	local r = {}
	for i = 1, #t do
		r[i] = string.char(t[i] - 2)
	end
	return table.concat(r)
end

-- فك أرقام
local function _n(x)
	return (x * 5 - 10) / 5
end

local G = game
local P = G[_s({82,110,113,116,103,116})] -- Players
local L = P[_s({78,113,99,97,108,82,113,99,97,121,103,116})] -- LocalPlayer

local function getChar()
	return L.Character or L.CharacterAdded:Wait()
end

local ch = getChar()
local h = ch:WaitForChild(_s({74,119,111,99,113,107,102})) -- Humanoid

-- قيم مشفّرة
h.WalkSpeed = _n(80)   -- 16
h.JumpPower = _n(250)  -- 48 تقريبًا

-- مثال حركة (تأكد إنه يشتغل)
task.spawn(function()
	while h.Parent do
		task.wait(_n(5)) -- 1
		h.WalkSpeed = h.WalkSpeed + 0
	end
end)
