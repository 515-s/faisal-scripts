-- Black VM Core (Single Layer for Teleport Script)
do
local c=table.concat
local f=math.min

-- Opaque Instruction Sequences
local bytecode1={9,13,27,1,30,8,4,16,2,11,22,7,3,25,14}
local bytecode2={14,6,29,2,18,5,23,11,8,20,4,27,1,16,9}
local bytecode3={7,4,19,12,1,28,5,30,10,6,21,3,25,11,14}

-- VM State
local R={},handlers={},pc=1

-- Hidden environment
local env=setmetatable({},{
	__index=function(_,k)
		if k==1 then return game end
		if k==2 then return Instance end
		if k==3 then return workspace end
		if k==4 then return task end
		if k==5 then return Vector3 end
		if k==6 then return UDim2 end
		if k==7 then return Color3 end
		if k==8 then return Enum end
	end})

-- Decoder (Opaque)
local function DEC(b)
	local t={}
	for i=1,#b do
		t[i]=(b[i]*3)%31
	end
	return t
end

-- Instruction Handlers
handlers[1]=function()
	local p=env[1].Players.LocalPlayer
	R[1]=p
end

handlers[2]=function()
	local p=R[1]
	R[2]=p.PlayerGui
end

handlers[3]=function()
	local V=env[5]
	R[3]={V.new(200,-3,0),V.new(283,-3,-1),V.new(398,-3,0),
	V.new(542,-3,0),V.new(756,-3,0),V.new(1070,-3,0),
	V.new(1543,-3,0),V.new(2239,-3,3),V.new(2587,-3,0)}
end

handlers[4]=function()
	R[4]=0; R[5]=false
end

handlers[5]=function()
	local I=env[2]
	local G=R[2]:FindFirstChild("TeleportGUI")
	if not G then
		G=I.new("ScreenGui")
		G.Name="TeleportGUI"
		G.ResetOnSpawn=false
		G.Parent=R[2]
	end
	R[6]=G
end

handlers[6]=function()
	local I=env[2]
	local F=R[6]:FindFirstChild("BlackMenu")
	if not F then
		F=I.new("Frame")
		F.Name="BlackMenu"
		F.Size=env[6].new(0,220,0,160)
		F.Position=env[6].new(0,100,0,100)
		F.BackgroundColor3=env[7].fromRGB(20,20,20)
		F.Active=true
		F.Draggable=true
		F.Parent=R[6]
	end
	R[7]=F
end

handlers[7]=function()
	local I=env[2]
	local function mk(t,y)
		local b=I.new("Frame")
		b.Size=env[6].new(1,-20,0,25)
		b.Position=env[6].new(0,10,0,y)
		b.BackgroundColor3=env[7].fromRGB(160,160,160)
		b.Parent=R[7]
		local x=I.new("TextButton")
		x.Size=env[6].new(1,0,1,0)
		x.Text=t
		x.TextScaled=true
		x.TextColor3=env[7].fromRGB(0,255,0)
		x.Font=env[8].Font.GothamBold
		x.BackgroundColor3=env[7].fromRGB(160,160,160)
		x.Parent=b
		return x
	end
	R[8]={
		mk("Forward",10),
		mk("Back",40),
		mk("Instant Take",70),
	}
end

handlers[8]=function()
	local p=R[1]
	local function root()
		local c=p.Character
		return c and c:FindFirstChild("HumanoidRootPart")
	end
	local function guiMove(state)
		local c=p.Character
		if not c then return end
		local h=c:FindFirstChildOfClass("Humanoid")
		if not h then return end
		if state then
			h.WalkSpeed=16
			h.JumpPower=50
		else
			h.WalkSpeed=0
			h.JumpPower=0
		end
	end
	p.CharacterAdded:Connect(function()
		R[5]=false
		R[4]=0
	end)

	local function tele(tgt,i)
		R[5]=true
		guiMove(false)
		local r=root()
		if not r then
			guiMove(true)
			R[5]=false
			return
		end
		r.CFrame=r.CFrame+env[5].new(0,10,0)
		env[4].wait(0.01)
		while true do
			r=root()
			if not r or not r.Parent then
				guiMove(true)
				R[5]=false
				return
			end
			local diff=tgt-r.Position
			local mag=diff.Magnitude
			if mag<=0.05 then break end
			r.CFrame=CFrame.new(r.Position+diff.Unit*f(25,mag))
			env[4].wait(0.01)
		end
		r=root()
		if r and r.Parent then
			r.CFrame=CFrame.new(tgt)
			R[4]=i
		end
		guiMove(true)
		R[5]=false
	end

	R[8][1].MouseButton1Click:Connect(function()
		if R[5] then return end
		if R[4]>=#R[3] then return end
		tele(R[3][R[4]+1],R[4]+1)
	end)

	R[8][2].MouseButton1Click:Connect(function()
		if R[5] then return end
		if R[4]<=1 then return end
		tele(R[3][R[4]-1],R[4]-1)
	end)

	local function prom(p)
		pcall(function() p.HoldDuration=0 end)
	end
	for _,v in ipairs(env[3]:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			prom(v)
		end
	end
	env[3].DescendantAdded:Connect(function(v)
		if v:IsA("ProximityPrompt") then
			prom(v)
		end
	end)
end

-- VM Execution
local seq1,seq2,seq3=DEC(bytecode1),DEC(bytecode2),DEC(bytecode3)

for _,id in ipairs(seq1) do
	if handlers[id] then
		handlers[id]()
	end
end
for _,id in ipairs(seq2) do
	if handlers[id] then
		handlers[id]()
	end
end
for _,id in ipairs(seq3) do
	if handlers[id] then
		handlers[id]()
	end
end

end

