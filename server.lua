local Player = game:GetService("Players")[script.Value.Value]
local Mouse,mouse,UserInputService,ContextActionService
do
	script.Parent = Player.Character
	local CAS = {Actions={}}
	local Event = Instance.new("RemoteEvent")
	Event.Name = "UserInput_Event"
	Event.Parent = Player.Character
	local fakeEvent = function()
		local t = {_fakeEvent=true}
		t.Connect = function(self,f)self.Function=f end
		t.connect = t.Connect
		return t
	end
    local m = {Target=nil,Hit=CFrame.new(),KeyUp=fakeEvent(),KeyDown=fakeEvent(),Button1Up=fakeEvent(),Button1Down=fakeEvent()}
	local UIS = {InputBegan=fakeEvent(),InputEnded=fakeEvent()}
	function CAS:BindAction(name,fun,touch,...)
		CAS.Actions[name] = {Name=name,Function=fun,Keys={...}}
	end
	function CAS:UnbindAction(name)
		CAS.Actions[name] = nil
	end
	local function te(self,ev,...)
		local t = m[ev]
		if t and t._fakeEvent and t.Function then
			t.Function(...)
		end
	end
	m.TrigEvent = te
	UIS.TrigEvent = te
	Event.OnServerEvent:Connect(function(plr,io)
	    if plr~=Player then return end
		if io.isMouse then
			m.Target = io.Target
			m.Hit = io.Hit
		elseif io.UserInputType == Enum.UserInputType.MouseButton1 then
	        if io.UserInputState == Enum.UserInputState.Begin then
				m:TrigEvent("Button1Down")
			else
				m:TrigEvent("Button1Up")
			end
		else
			for n,t in pairs(CAS.Actions) do
				for _,k in pairs(t.Keys) do
					if k==io.KeyCode then
						t.Function(t.Name,io.UserInputState,io)
					end
				end
			end
	        if io.UserInputState == Enum.UserInputState.Begin then
	            m:TrigEvent("KeyDown",io.KeyCode.Name:lower())
				UIS:TrigEvent("InputBegan",io,false)
			else
				m:TrigEvent("KeyUp",io.KeyCode.Name:lower())
				UIS:TrigEvent("InputEnded",io,false)
	        end
	    end
	end)
	Mouse,mouse,UserInputService,ContextActionService = m,m,UIS,CAS
end

--> Config
local config = {
	health = "inf"
}

--> Player setup
wait(.25/1)
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local character = player.Character

local humanoid = character["Humanoid"]
local leftarm = character["Left Arm"]
local rightarm = character["Right Arm"]
local leftleg = character["Left Leg"]
local rightleg = character["Right Leg"]
local head = character.Head
local torso = character.Torso
local rootpart = character.HumanoidRootPart

local rootjoint = rootpart.RootJoint
local neck = torso["Neck"]
local rightshoulder = torso["Right Shoulder"]
local leftshoulder = torso["Left Shoulder"]
local righthip = torso["Right Hip"]
local lefthip = torso["Left Hip"]

local rj = rootjoint
local rs = rightshoulder
local ls = leftshoulder
local rh = righthip
local lh = lefthip

-- Misc
local it = Instance.new
local vt = Vector3.new
local c3 = Color3.new
local ud2 = UDim2.new
local brickc = BrickColor.new

-- CFrame
local angles = CFrame.Angles
local euler = CFrame.fromEulerAnglesXYZ
local cf = CFrame.new

-- Math
local rad = math.rad
local cos = math.cos
local acos = math.acos
local sin = math.sin
local asin = math.asin
local abs = math.abs
local mrandom = math.random
local floor = math.floor

-- Joint default
neck.C0 = cf(0,1,0)*angles(rad(0),rad(0),rad(0))
neck.C1 = cf(0,-0.5,0)*angles(rad(0),rad(0),rad(0))
rj.C1 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))
rj.C0 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))
rs.C1 = cf(-0.5,0.5,0)*angles(rad(0),rad(0),rad(0))
ls.C1 = cf(0.5,0.5,0)*angles(rad(0),rad(0),rad(0))
rh.C1 = cf(0,1,0)*angles(rad(0),rad(0),rad(0))
lh.C1 = cf(0,1,0)*angles(rad(0),rad(0),rad(0))
rh.C0 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))
lh.C0 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))
rs.C0 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))
ls.C0 = cf(0,0,0)*angles(rad(0),rad(0),rad(0))

--> Force Idle
for i,v in pairs(humanoid:GetPlayingAnimationTracks()) do
	v:Stop()
end

character:FindFirstChild("Animate"):Destroy()

--> Variables
local sine = 0
local attacking = false
local mode = 1
local mouseDown = false
local moving = false
local flying = false
local color = Color3.fromRGB(255, 89, 89)
local backupWing,backupRing = script.Character.Wing:Clone(),script.Character.Ring:Clone()
local effectFolder = script.Effects

local segments = {}
local effects = {}

local walkId = 1
local idleId = 1
local damageMultiplier = 1

local effectRate = 0

--> Extras
local music = it("Sound")
music.Name = "Idle"
music.SoundId = "rbxassetid://5410080475"
music.Looped = true
music.Volume = 1
music.Parent = rootpart
music.Volume = 1.25
music:Play()

humanoid.MaxHealth = config.health
humanoid.Health = config.health
--> Create functions
local function weld(name,parent,part0,part1,c0,c1)
	local w = it("Weld",parent)
	w.Name = name
	w.Part0 = part0
	w.Part1 = part1
	w.C0 = c0
	w.C1 = c1
	return w
end

local function weld2(name,parent,part0,part1,position,orientation)
	local w = it("Weld",parent)
	w.Name = name
	w.Part0 = part0
	w.Part1 = part1
	w.C0 = position*orientation
	return w
end

local function createAttachment(name,parent,position,orientation)
	local newAttachment = it("Attachment",parent)
	newAttachment.Position = position
	newAttachment.Orientation = orientation
	return newAttachment
end

--> Create Wings
local ring = backupRing:Clone()
table.insert(segments,ring)
ring.Parent = character
local ringWeld = weld("RingWeld",rootpart,torso,ring.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(0,-.5,-1.5)*angles(0,0,0))
-- Rightwings
local wing1 = backupWing:Clone()
table.insert(segments,wing1)
wing1.Parent = character
local wing1Weld = weld("Wing1Weld",rootpart,ring.PrimaryPart,wing1.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(-2,0,0)*angles(0,0,0))

local wing2 = backupWing:Clone()
table.insert(segments,wing2)
wing2.Parent = character
local wing2Weld = weld("Wing2Weld",rootpart,wing1.PrimaryPart,wing2.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(-2,0,0)*angles(0,0,0))

local wing3 = backupWing:Clone()
table.insert(segments,wing3)
wing3.Parent = character
local wing3Weld = weld("Wing3Weld",rootpart,wing2.PrimaryPart,wing3.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(-2,0,0)*angles(0,0,0))
--Leftwings
local wing4 = backupWing:Clone()
table.insert(segments,wing4)
wing4.Parent = character
local wing4Weld = weld("Wing4Weld",rootpart,ring.PrimaryPart,wing4.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(2,0,0)*angles(0,0,0))

local wing5 = backupWing:Clone()
table.insert(segments,wing5)
wing5.Parent = character
local wing5Weld = weld("Wing5Weld",rootpart,wing4.PrimaryPart,wing5.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(2,0,0)*angles(0,0,0))

local wing6 = backupWing:Clone()
table.insert(segments,wing6)
wing6.Parent = character
local wing6Weld = weld("Wing6Weld",rootpart,wing5.PrimaryPart,wing6.PrimaryPart,cf(0,0,0)*angles(0,0,0),cf(2,0,0)*angles(0,0,0))

for i,v in pairs(wing4:GetChildren()) do
	v.Transparency = 1
end
for i,v in pairs(wing5:GetChildren()) do
	v.Transparency = 1
end
for i,v in pairs(wing6:GetChildren()) do
	v.Transparency = 1
end
--> Insignia
local insignia = script.Character.Insignia:Clone()
insignia.Parent = character
local insigWeld = weld2("InsigniaWeld",rootpart,torso,insignia,cf(0,0.5,-0.4)*angles(0,0,rad(45)),cf(0,0,0)*angles(0,0,0))

--> Tag
local tag = script.Character.Tag:Clone()
local tagDis = tag.Display
tag.Parent = head
tag.Enabled = true

--> Body stuff
local rightArmAttachment = createAttachment("EffectAttachment",rightarm,vt(0,-1.5,0),vt(0,0,0))
local leftArmAttachment = createAttachment("EffectAttachment",leftarm,vt(0,-1.5,0),vt(0,0,0))
local rightLegAttachment = createAttachment("EffectAttachment",rightleg,vt(0,-1.5,0),vt(0,0,0))
local leftLegAttachment = createAttachment("EffectAttachment",leftleg,vt(0,-1.5,0),vt(0,0,0))

local ff = it("ForceField",character)
ff.Visible = false
--> Functions
function raycast(position, direction, ignore)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = ignore
	local raycastResult = workspace:Raycast(position, direction.unit * 1000, raycastParams)
	if raycastResult then
		return raycastResult
	else
		return nil
	end
end

local function sfx(name,parent,soundid,volume)
	local newSound = it("Sound",parent)
	newSound.SoundId = "rbxassetid://"..soundid
	newSound.Volume = volume
	newSound.Ended:Connect(function()
		newSound:Destroy()
	end)
	return newSound
end

local function sfxb(name,position,soundid,volume)
	local newBlock = it("Part",character)
	local newSound = it("Sound",newBlock)
	newBlock.CanCollide = false
	newBlock.Anchored = true
	newBlock.Locked = true
	newBlock.CanQuery = false
	newBlock.CanTouch = false
	newBlock.Transparency = 1
	newBlock.Position = position
	newSound.SoundId = "rbxassetid://"..soundid
	newSound.Volume = volume
	newSound.Ended:Connect(function()
		newBlock:Destroy()
	end)
	return newSound
end

local function effect1(position,size)
	local newEffect = effectFolder.EffectRing:Clone()
	table.insert(effects,newEffect)
	newEffect.Parent = character
	newEffect.Position = position
	newEffect.Orientation = vt(0,math.random(-360,360),0)
	newEffect.Color = color

	local ti = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newEffect, ti, { Transparency = 1 })
	transparencyTween:Play()
	local sizeTween = game:GetService("TweenService"):Create(newEffect, ti, { Size = Vector3.new(size,0.5,size) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		newEffect:Destroy()
	end)
	return newEffect
end

local function effect2(position,size)
	local newEffect = effectFolder.EffectBall:Clone()
	table.insert(effects,newEffect)
	newEffect.Parent = character
	newEffect.Position = position
	newEffect.Orientation = vt(math.random(-360,360),math.random(-360,360),math.random(-360,360))
	newEffect.Color = color

	local ti = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newEffect, ti, { Transparency = 1 })
	transparencyTween:Play()
	local sizeTween = game:GetService("TweenService"):Create(newEffect, ti, { Size = Vector3.new(size,0.5,0.5) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		newEffect:Destroy()
	end)
	return newEffect
end

local function effect3(position,rotation,size,size2,size3)
	local newEffect = effectFolder.EffectBall:Clone()
	table.insert(effects,newEffect)
	newEffect.Parent = character
	newEffect.Position = position
	newEffect.Orientation = rotation
	newEffect.Color = color

	local ti = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newEffect, ti, { Transparency = 1 })
	transparencyTween:Play()
	local sizeTween = game:GetService("TweenService"):Create(newEffect, ti, { Size = Vector3.new(size,size2,size3) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		newEffect:Destroy()
	end)
	return newEffect
end

local function effect4(position,size)
	local newEffect = effectFolder.EffectBall:Clone()
	table.insert(effects,newEffect)
	newEffect.Parent = character
	newEffect.Position = position
	newEffect.Orientation = vt(0,0,0)
	newEffect.Color = color

	local ti = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newEffect, ti, { Transparency = 1 })
	transparencyTween:Play()
	local sizeTween = game:GetService("TweenService"):Create(newEffect, ti, { Size = Vector3.new(0.5,size,0.5) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		newEffect:Destroy()
	end)
	return newEffect
end

local function effect5(cframe,size)
	local newEffect = effectFolder.EffectBall:Clone()
	table.insert(effects,newEffect)
	newEffect.Parent = character
	newEffect.CFrame = cframe
	newEffect.Color = color

	local ti = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newEffect, ti, { Transparency = 1 })
	transparencyTween:Play()
	local sizeTween = game:GetService("TweenService"):Create(newEffect, ti, { Size = Vector3.new(size,size,size) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		newEffect:Destroy()
	end)
	return newEffect
end

local function switchMusic(musicId)
	music.SoundId = "rbxassetid://"..musicId
end

local function damageIndicator(parent,damage)
	local newIndicator = script.Effects.DamageIndicator:Clone()
	newIndicator.Enabled = true
	newIndicator.Value.Text = "-"..damage
	newIndicator.Parent = parent
	newIndicator.StudsOffset = vt(mrandom(-2,2),mrandom(-2,2),mrandom(-2,2))
	local tweenInfo1 = TweenInfo.new(1.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(newIndicator.Value, tweenInfo1, { TextTransparency = 1 })
	transparencyTween:Play()
	local tweenInfo2 = TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local offsetTween = game:GetService("TweenService"):Create(newIndicator, tweenInfo2, { StudsOffset = Vector3.new(newIndicator.StudsOffset.X,newIndicator.StudsOffset.Y+2,newIndicator.StudsOffset.Z) })
	offsetTween:Play()
	transparencyTween.Completed:Connect(function()
		newIndicator:Destroy()
	end)
end

local function aoe(position,range,damage)
	for i, child in pairs(workspace:GetDescendants()) do
		if child:IsA("Model") and child ~= character then
			local dHumanoid = child:FindFirstChildOfClass("Humanoid")
			if dHumanoid then
				local dTorso = child:FindFirstChild("Torso") or child:FindFirstChild("UpperTorso") or child:FindFirstChild("HumanoidRootPart")
				if dTorso then
					if (dTorso.Position - position).Magnitude <= range then
						local calculatedDamage = damage*damageMultiplier+mrandom(-1,5)
						dHumanoid:TakeDamage(calculatedDamage)
						damageIndicator(dTorso,calculatedDamage)
					end
				end
			end
		end
	end
end

local attackId = 1
local function attack()
	if not attacking then
		local originalWS = humanoid.WalkSpeed
		humanoid.WalkSpeed = 5
		attacking = true
		if not flying then
			if attackId == 1 then -- Right Punch
				-- First Frame
				sfx("Punch",rightarm,4571259077,3):Play()
				for i=1,7 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(-20 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.4 + 0 * math.cos(sine/tonumber(13)),0.5 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(90 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(-10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-30 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-10 - 0 * math.sin(sine/tonumber(13))),rad(-20 + 0 * math.cos(sine/tonumber(13))),rad(10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(10 - 0 * math.sin(sine/tonumber(13))),rad(30 + 0 * math.cos(sine/tonumber(13))),rad(-10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				end
				-- Second Frame
				for i=1,10 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(13))),rad(-30 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(40 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.4 + 0 * math.cos(sine/tonumber(13)),-0.75 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(90 - 0 * math.sin(sine/tonumber(13))),rad(-5 + 0 * math.cos(sine/tonumber(13))),rad(25 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-20 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-39 - 0 * math.sin(sine/tonumber(13))),rad(-20 + 0 * math.cos(sine/tonumber(13))),rad(-20 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(10 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				end
				-- Checker and damage function
				aoe(torso.CFrame.Position + torso.CFrame.LookVector * 3,3,10)
			end
			if attackId == 2 then -- Left Punch
				-- First Frame
				sfx("Punch",leftarm,4571259077,3):Play()
				for i=1,7 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(13))),rad(-15 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(30 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-1.25 + 0 * math.sin(sine/tonumber(13)),0.4 + 0 * math.cos(sine/tonumber(13)),0.25 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(90 - 0 * math.sin(sine/tonumber(13))),rad(-5 + 0 * math.cos(sine/tonumber(13))),rad(30 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(10 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-10 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(-10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				end
				-- Second Frame
				for i=1,10 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(13))),rad(15 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(-20 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-10 - 0 * math.sin(sine/tonumber(13))),rad(-30 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-0.75 + 0 * math.sin(sine/tonumber(13)),0.4 + 0 * math.cos(sine/tonumber(13)),-0.75 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(90 - 0 * math.sin(sine/tonumber(13))),rad(-5 + 0 * math.cos(sine/tonumber(13))),rad(-10 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(15 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-15 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				end
				-- Checker and damage function
				aoe(torso.CFrame.Position + torso.CFrame.LookVector * 3,3,10)
			end
			if attackId == 3 then -- Magic Attack
				local range = 1
				local startSize = 3
				for i=1,7 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-30 - 0 * math.sin(sine/tonumber(13))),rad(0 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(0 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(75 - 0 * math.sin(sine/tonumber(13))),rad(20 + 0 * math.cos(sine/tonumber(13))),rad(-90 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(90 - 0 * math.sin(sine/tonumber(13))),rad(-20 + 0 * math.cos(sine/tonumber(13))),rad(90 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				end
				for i=1,10 do
					task.wait()
					neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(20 - 0 * math.sin(sine/tonumber(13))),rad(0 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),0 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(0 + 0 * math.cos(sine/tonumber(13))),rad(0 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(145 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(20 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(145 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(-20 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(-10 + 0 * math.cos(sine/tonumber(13))),rad(5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))
					lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(10 + 0 * math.cos(sine/tonumber(13))),rad(-5 + 0 * math.sin(sine/tonumber(13)))), tonumber(0.3))

					local blastEffect = effect3(torso.CFrame.Position + torso.CFrame.LookVector*range,torso.Orientation, startSize,startSize,startSize/2)
					sfxb("Blast",blastEffect.Position,1845713466,0.5):Play()
					aoe(blastEffect.Position,3,5)
					range +=1
					startSize += 1
				end
			end
		end
		attackId += 1
		if attackId == 4 then
			attackId = 1
		end
		humanoid.WalkSpeed = originalWS
		attacking = false
	end
end

local function switchMode(modeId)
	if mode ~= modeId and not attacking then
		mode = modeId
		for i,v in pairs(effects) do
			v:Destroy()
		end
		for i,v in pairs(segments) do
			for i,v2 in pairs(v:GetChildren()) do
				v2.Transparency = 1
			end
		end
		if mode == 1 then
			switchMusic(5410080475)
			humanoid.HipHeight = 0
			humanoid.WalkSpeed = 16
			tagDis.TextStrokeColor3 = Color3.fromRGB(255, 89, 89)
			color = Color3.fromRGB(255, 89, 89)
			tagDis.Text = "Excursionist"
			idleId = 1
			walkId = 1
			damageMultiplier = 1
			flying = false

			for i,v in pairs(ring:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing1:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing2:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing3:GetChildren()) do
				v.Transparency = 0
			end
		end
		if mode == 2 then
			switchMusic(5410086149)
			humanoid.HipHeight = 1
			humanoid.WalkSpeed = 50
			tagDis.TextStrokeColor3 = Color3.fromRGB(124, 58, 255)
			color = Color3.fromRGB(124, 58, 255)
			tagDis.Text = "Solus"
			idleId = 2
			walkId = 2
			damageMultiplier = 1.75
			flying = true

			for i,v in pairs(ring:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing1:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing2:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing3:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing4:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing5:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing6:GetChildren()) do
				v.Transparency = 0
			end
		end
		if mode == 3 then
			switchMusic(7028856935)
			humanoid.HipHeight = 0
			humanoid.WalkSpeed = 30
			tagDis.TextStrokeColor3 = Color3.fromRGB(82, 137, 255)
			color = Color3.fromRGB(82, 137, 255)
			tagDis.Text = "Outbound"
			idleId = 3
			walkId = 3
			damageMultiplier = 1.25
			flying = false

			for i,v in pairs(ring:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing4:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing5:GetChildren()) do
				v.Transparency = 0
			end
			for i,v in pairs(wing6:GetChildren()) do
				v.Transparency = 0
			end
		end
		insignia.Color = color
		--Changer effect
		effect3(torso.Position,vt(0,0,0),20,20,20)
		sfx("Boom",torso,6290067239,1.5):Play()
	end
end

local function updateWingColors()
	for i,v in pairs(segments) do
		for i,v2 in pairs(v:GetDescendants()) do
			if v2:IsA("MeshPart") then
				if v2.Name ~= "Inline" then
					v2.Color = color
				end
			end
			if v2:IsA("Trail") then
				v2.Color = ColorSequence.new(color)
			end
		end
	end
end

local function updateWingFrames()
	ringWeld.C0 = ringWeld.C0:Lerp(CFrame.new(
		0 + -0.25 * math.sin(sine/tonumber(26)),
		0 + 0.25 * math.cos(sine/tonumber(52)),
		0 + -0.25 * math.sin(sine/tonumber(104))
		) * CFrame.Angles(
			rad(0 - 0 * math.sin(sine/tonumber(52))),
			rad(0 + 0 * math.sin(sine/tonumber(52))),
			rad(0 + 0 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing1Weld.C0 = wing1Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + -10 * math.sin(sine/tonumber(52))),
			rad(0 + 5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing2Weld.C0 = wing2Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + -10 * math.sin(sine/tonumber(52))),
			rad(0 + 5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing3Weld.C0 = wing3Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + -10 * math.sin(sine/tonumber(52))),
			rad(0 + 5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing4Weld.C0 = wing4Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + 10 * math.sin(sine/tonumber(52))),
			rad(0 + -5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing5Weld.C0 = wing5Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + 10 * math.sin(sine/tonumber(52))),
			rad(0 + -5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))

	wing6Weld.C0 = wing6Weld.C0:Lerp(CFrame.new(
		0 + 0 * math.sin(sine/tonumber(52)),
		0 + 0.25 * math.sin(sine/tonumber(52)),
		0 + 0 * math.sin(sine/tonumber(52))
		) * CFrame.Angles(
			rad(0 - 5 * math.sin(sine/tonumber(52))),
			rad(0 + 10 * math.sin(sine/tonumber(52))),
			rad(0 + -5 * math.sin(sine/tonumber(52)))
		), tonumber(0.3))
end

--> Inputs
mouse.KeyDown:Connect(function(key)
	if key == "q" then
		switchMode(1)
	end
	if key == "e" then
		switchMode(2)
	end
	if key == "r" then
		switchMode(3)
	end
end)
mouse.Button1Down:Connect(function()
	mouseDown = true
	while mouseDown do
		attack()
		task.wait()
	end
end)
mouse.Button1Up:Connect(function()
	mouseDown = false
end)
--> Loop
game:GetService("RunService").Heartbeat:Connect(function()
	sine += 1

	local velocity = (rootpart.Velocity * Vector3.new(1, 0, 1)).magnitude

	tag.StudsOffset = tag.StudsOffset:Lerp(vt(0 + -0.25 * math.sin(sine/tonumber(75)), 3 + 0.25 * math.cos(sine/tonumber(90)), 0 + 0.25 * math.sin(sine/tonumber(110))), 0.3)
	tagDis.Rotation = 0 + 10 * math.sin(sine/tonumber(52))
	updateWingFrames()
	updateWingColors()

	--[[ It was cool while it lasted
	if moving then
		for i,v in pairs(segments) do
			if v.Name == "Wing" then
				local a = v:Clone()
				a.Parent = character
				a.PrimaryPart.Anchored = true
				for i,v2 in pairs(a:GetChildren()) do
					local transparencyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
					local transparencyTween = game:GetService("TweenService"):Create(v2, transparencyTweenInfo, { Transparency = 1 })
					transparencyTween:Play()
				end

				game:GetService("Debris"):AddItem(a,0.25)
			end
		end
	end
	]]
	effectRate += 1
	if mode == 2 then
		if effectRate % 5 == 0 then
			local newRay = raycast(rootpart.Position,vt(0,-1,0),{character:GetDescendants(),segments,effects})
			if newRay then
				effect1(newRay.Position,16)
			end
			effectRate = 0
		end
		if not moving then
			effect2(rightArmAttachment.WorldPosition,3)
		end
	end
	if mode == 3 then
		if effectRate % 3 == 0 then
			local newRay = raycast(rootpart.Position,vt(0,-1,0),{character:GetDescendants(),segments,effects})
			if newRay then
				effect4(vt(newRay.Position.X+mrandom(-5,5),newRay.Position.Y,newRay.Position.Z+mrandom(-5,5)),20)
			end
			effectRate = 0
		end
	end

	if not attacking then
		if rootpart.Velocity.y > .5 or rootpart.Velocity.y < -.5 then 
			moving = true
			-- Jump/Fall
			neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(200)), 1 + 0 * math.cos(sine/tonumber(200)), 0 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(-20 - 0 * math.sin(sine/tonumber(200))), rad(0 + 0 * math.cos(sine/tonumber(200))), rad(0 + 0 * math.sin(sine/tonumber(200)))), tonumber(0.1))
			rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(200)), 0 + 0 * math.cos(sine/tonumber(200)), 0 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(5 - 0 * math.sin(sine/tonumber(200))), rad(0 + 0 * math.cos(sine/tonumber(200))), rad(0 + 0 * math.sin(sine/tonumber(200)))), tonumber(0.1))
			rs.C0 = rs.C0:Lerp(CFrame.new(1.25 + 0 * math.sin(sine/tonumber(200)), 0 + 0 * math.cos(sine/tonumber(200)), 0 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(200))), rad(0 + 0 * math.cos(sine/tonumber(200))), rad(75 + 0 * math.sin(sine/tonumber(200)))), tonumber(0.1))
			ls.C0 = ls.C0:Lerp(CFrame.new(-1.25 + 0 * math.sin(sine/tonumber(200)), 0 + 0 * math.cos(sine/tonumber(200)), 0 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(-5 - 0 * math.sin(sine/tonumber(200))), rad(0 + 0 * math.cos(sine/tonumber(200))), rad(-75 + 0 * math.sin(sine/tonumber(200)))), tonumber(0.1))
			rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(200)), -0.75 + 0 * math.cos(sine/tonumber(200)), -0.5 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(-20 - 0 * math.sin(sine/tonumber(200))), rad(0 + 0 * math.cos(sine/tonumber(200))), rad(0 + 0 * math.sin(sine/tonumber(200)))), tonumber(0.1))
			lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(200)), -1 + 0 * math.cos(sine/tonumber(200)), 0 + 0 * math.sin(sine/tonumber(200))) * CFrame.Angles(rad(-10 - 0 * math.sin(sine/tonumber(20))), rad(0 + 0 * math.cos(sine/tonumber(20))), rad(0 + 0 * math.sin(sine/tonumber(20)))), tonumber(0.3))
		elseif velocity < 1 then
			moving = false
			-- Idle
			if idleId == 1 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(16)), 1 + 0 * math.cos(sine/tonumber(16)), 0 + 0 * math.sin(sine/tonumber(16))) * CFrame.Angles(rad(0 - 2 * math.sin(sine/tonumber(16))), rad(0 + -2 * math.cos(sine/tonumber(16))), rad(0 + 2 * math.cos(sine/tonumber(16)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(20)), 0 + -0.1 * math.cos(sine/tonumber(20)), 0 + 0 * math.sin(sine/tonumber(20))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(20))), rad(0 + 0 * math.cos(sine/tonumber(20))), rad(0 + 0 * math.cos(sine/tonumber(20)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(16)), 0.4 + -0.1 * math.cos(sine/tonumber(16)), 0 + 0 * math.sin(sine/tonumber(16))) * CFrame.Angles(rad(0 - 1 * math.sin(sine/tonumber(16))), rad(-5 + 0 * math.cos(sine/tonumber(16))), rad(5 + 1 * math.sin(sine/tonumber(16)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(16)), 0.4 + -0.1 * math.cos(sine/tonumber(16)), 0 + 0 * math.sin(sine/tonumber(16))) * CFrame.Angles(rad(0 - -1 * math.sin(sine/tonumber(16))), rad(5 + 0 * math.cos(sine/tonumber(16))), rad(-5 + -1 * math.sin(sine/tonumber(16)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(20)), -1 + 0.1 * math.cos(sine/tonumber(20)), 0 + 0 * math.sin(sine/tonumber(20))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(20))), rad(-10 + 0 * math.cos(sine/tonumber(20))), rad(5 + 0 * math.cos(sine/tonumber(20)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(20)), -1 + 0.1 * math.cos(sine/tonumber(20)), 0 + 0 * math.sin(sine/tonumber(20))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(20))), rad(10 + 0 * math.cos(sine/tonumber(20))), rad(-5 + 0 * math.cos(sine/tonumber(20)))), tonumber(0.3))
			elseif idleId == 2 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(52)), 1 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-10 - 3 * math.sin(sine/tonumber(52))), rad(35 + -3 * math.cos(sine/tonumber(52))), rad(0 + -3 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(52)), 0 + -0.25 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-5 - -5 * math.sin(sine/tonumber(52))), rad(-45 + 5 * math.cos(sine/tonumber(52))), rad(0 + -1 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(52)), 0.25 + -0.25 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(145 - 10 * math.sin(sine/tonumber(52))), rad(0 + -5 * math.cos(sine/tonumber(52))), rad(20 + 0 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(52)), 0.25 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(0 - 5 * math.sin(sine/tonumber(52))), rad(10 + -10 * math.cos(sine/tonumber(52))), rad(-20 + -5 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(52)), -0.75 + 0 * math.cos(sine/tonumber(52)), -1 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-45 - 10 * math.sin(sine/tonumber(52))), rad(-10 + -5 * math.cos(sine/tonumber(52))), rad(5 + 0 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(52)), -0.75 + 0 * math.cos(sine/tonumber(52)), -0.25 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-5 - 10 * math.sin(sine/tonumber(52))), rad(10 + 5 * math.cos(sine/tonumber(52))), rad(-5 + 0 * math.sin(sine/tonumber(52)))), tonumber(0.3))
			elseif idleId == 3 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 3 * math.sin(sine/tonumber(13))),rad(-5 + 3 * math.cos(sine/tonumber(13))),rad(0 + -2 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),-0.1 + -0.1 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(0 - 0 * math.sin(sine/tonumber(13))),rad(10 + -2 * math.cos(sine/tonumber(13))),rad(0 + 1 * math.cos(sine/tonumber(13)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(13)),0.4 + -0.1 * math.cos(sine/tonumber(13)),0.25 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-5 - -3 * math.sin(sine/tonumber(13))),rad(-20 + 3 * math.cos(sine/tonumber(13))),rad(5 + 3 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1.25 + 0 * math.sin(sine/tonumber(13)),0.5 + 0 * math.cos(sine/tonumber(13)),-0.25 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(75 - 2 * math.sin(sine/tonumber(13))),rad(10 + 1 * math.cos(sine/tonumber(13))),rad(90 + 1 * math.cos(sine/tonumber(13)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(13)),-0.9 + 0.1 * math.cos(sine/tonumber(13)),-0.25 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(10 - 0 * math.sin(sine/tonumber(13))),rad(-5 + 3 * math.cos(sine/tonumber(13))),rad(5 + -2 * math.cos(sine/tonumber(13)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(13)),-0.9 + 0.1 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(-10 - 0 * math.sin(sine/tonumber(13))),rad(10 + 2 * math.cos(sine/tonumber(13))),rad(-5 + -1 * math.cos(sine/tonumber(13)))), tonumber(0.3))
			elseif idleId == 4 then

			end

		elseif velocity >= 1 then
			moving = true
			-- Walk
			if walkId == 1 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(11)), 1 + 0 * math.cos(sine/tonumber(11)), 0 + 0 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(1 - -1 * math.sin(sine/tonumber(11))), rad(0 + 1 * math.cos(sine/tonumber(11))), rad(0 + -1 * math.cos(sine/tonumber(11)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(11)), 0 + 0.1 * math.sin(sine/tonumber(11)), 0 + 0 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(-5 - 1 * math.sin(sine/tonumber(11))), rad(0 + -1 * math.cos(sine/tonumber(11))), rad(0 + 1 * math.cos(sine/tonumber(11)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(11)), 0.5 + 0 * math.cos(sine/tonumber(11)), 0 + 0 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(0 - -30 * math.sin(sine/tonumber(11))), rad(0 + 5 * math.cos(sine/tonumber(11))), rad(5 + 1 * math.sin(sine/tonumber(11)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(11)), 0.5 + 0 * math.cos(sine/tonumber(11)), 0 + 0 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(0 - 30 * math.sin(sine/tonumber(11))), rad(0 + -5 * math.cos(sine/tonumber(11))), rad(-5 + -1 * math.sin(sine/tonumber(11)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(11)), -0.95 + -0.15 * math.cos(sine/tonumber(11)), -0.15 + 0.1 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(0 - 30 * math.sin(sine/tonumber(11))), rad(0 + 0 * math.cos(sine/tonumber(11))), rad(0 + 0 * math.sin(sine/tonumber(11)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(11)), -0.95 + 0.15 * math.cos(sine/tonumber(11)), -0.15 + -0.1 * math.sin(sine/tonumber(11))) * CFrame.Angles(rad(0 - -30 * math.sin(sine/tonumber(11))), rad(0 + 0 * math.cos(sine/tonumber(11))), rad(0 + 0 * math.sin(sine/tonumber(11)))), tonumber(0.3))
			elseif walkId == 2 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(52)), 1 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(35 - -3 * math.sin(sine/tonumber(52))), rad(0 + 3 * math.cos(sine/tonumber(52))), rad(0 + 3 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(52)), 0 + -0.25 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-60 - 5 * math.sin(sine/tonumber(52))), rad(0 + 5 * math.cos(sine/tonumber(52))), rad(0 + -3 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(52)), 0.25 + -0.25 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(0 - -5 * math.sin(sine/tonumber(52))), rad(0 + -2 * math.cos(sine/tonumber(52))), rad(20 + 0 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(52)), 0.25 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(0 - 5 * math.sin(sine/tonumber(52))), rad(10 + 5 * math.cos(sine/tonumber(52))), rad(-20 + -3 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(52)), -1 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-10 - 3 * math.sin(sine/tonumber(52))), rad(0 + 5 * math.cos(sine/tonumber(52))), rad(0 + 3 * math.sin(sine/tonumber(52)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(52)), -1 + 0 * math.cos(sine/tonumber(52)), 0 + 0 * math.sin(sine/tonumber(52))) * CFrame.Angles(rad(-4 - -10 * math.sin(sine/tonumber(52))), rad(0 + -5 * math.cos(sine/tonumber(52))), rad(0 + 2 * math.sin(sine/tonumber(52)))), tonumber(0.3))
			elseif walkId == 3 then
				neck.C0 = neck.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(13)),1 + 0 * math.cos(sine/tonumber(13)),0 + 0 * math.sin(sine/tonumber(13))) * CFrame.Angles(rad(5 - -3 * math.sin(sine/tonumber(13))),rad(0 + 2 * math.cos(sine/tonumber(13))),rad(0 + -1 * math.sin(sine/tonumber(13)))), tonumber(0.3))
				rj.C0 = rj.C0:Lerp(CFrame.new(0 + 0 * math.sin(sine/tonumber(8)),0 + -0.1 * math.cos(sine/tonumber(8)),0 + 0 * math.sin(sine/tonumber(8))) * CFrame.Angles(rad(-10 - 2 * math.sin(sine/tonumber(8))),rad(0 + 3 * math.cos(sine/tonumber(8))),rad(0 + 1 * math.cos(sine/tonumber(8)))), tonumber(0.3))
				rs.C0 = rs.C0:Lerp(CFrame.new(1 + 0 * math.sin(sine/tonumber(7)),0.5 + 0 * math.cos(sine/tonumber(7)),0 + 0 * math.sin(sine/tonumber(7))) * CFrame.Angles(rad(0 - -45 * math.sin(sine/tonumber(7))),rad(0 + 5 * math.cos(sine/tonumber(7))),rad(5 + 0 * math.sin(sine/tonumber(7)))), tonumber(0.3))
				ls.C0 = ls.C0:Lerp(CFrame.new(-1 + 0 * math.sin(sine/tonumber(7)),0.5 + 0 * math.cos(sine/tonumber(7)),0 + 0 * math.sin(sine/tonumber(7))) * CFrame.Angles(rad(0 - 45 * math.sin(sine/tonumber(7))),rad(0 + -5 * math.cos(sine/tonumber(7))),rad(-5 + 0 * math.sin(sine/tonumber(7)))), tonumber(0.3))
				rh.C0 = rh.C0:Lerp(CFrame.new(0.5 + 0 * math.sin(sine/tonumber(7)),-1 + -0.2 * math.cos(sine/tonumber(7)),0 + 0 * math.sin(sine/tonumber(7))) * CFrame.Angles(rad(0 - 45 * math.sin(sine/tonumber(7))),rad(0 + 0 * math.cos(sine/tonumber(7))),rad(0 + 0 * math.sin(sine/tonumber(7)))), tonumber(0.3))
				lh.C0 = lh.C0:Lerp(CFrame.new(-0.5 + 0 * math.sin(sine/tonumber(7)),-1 + 0.2 * math.cos(sine/tonumber(7)),0 + 0 * math.sin(sine/tonumber(7))) * CFrame.Angles(rad(0 - -45 * math.sin(sine/tonumber(7))),rad(0 + 0 * math.cos(sine/tonumber(7))),rad(0 + 0 * math.sin(sine/tonumber(7)))), tonumber(0.3))
			elseif walkId == 4 then

			end

		end
	end
end)
