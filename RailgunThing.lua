--> Config
local config = {
	health = "inf",
	walkspeed = 100,
	jumppower = 75
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
local clamp = math.clamp

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
local animationIdle = it("Animation")
animationIdle.Name = "Idle"
animationIdle.AnimationId = "rbxassetid://180435571"
local animationController = humanoid:LoadAnimation(animationIdle)
animationController.Priority = Enum.AnimationPriority.Action4
animationController:Play()

--> Variables
local sine = 0
local method = 1
local textHeight = 2
local attacking = false
local canAttack = true
local taunting = false
local mouseDown = false
local flying = false
local indicators = {}
local funkified = {}
local voided = {}
local songTable = {
	1836459997,
	1837560230,
	1846257192,
	1837678344,
	1837678344,
	1837768562
}
local keys = {
	wDown = false,
	aDown = false,
	sDown = false,
	dDown = false,
	fDown = false
}
local lastSong
local bodyGyro,bodyVelocity

--> Create Functions
local function createWeld(p0,p1,parent,name)
	local newWeld = it("Weld",parent)
	newWeld.Name = name
	newWeld.Part0 = p0
	newWeld.Part1 = p1
	return newWeld
end

local function createAttachment(parent,axis,rotation,secondaryAxis,orientation,position)
	local newAttachment = it("Attachment",parent)
	newAttachment.Axis = axis
	newAttachment.Rotation = rotation
	newAttachment.SecondaryAxis = secondaryAxis
	newAttachment.Orientation = orientation
	newAttachment.Position = position
	return newAttachment
end

local function createSound(soundId,volume,parent,name)
	local newSound = it("Sound",parent)
	newSound.SoundId = "rbxassetid://"..soundId
	newSound.Volume = volume
	newSound.Parent = parent
	newSound.Name = name
	newSound.Ended:Connect(function()
		newSound:Destroy()
	end)
	return newSound
end

local function createSoundObject(soundId,volume,name,position)
	local newSoundObject = Instance.new("Part",character)
	newSoundObject.Name = name
	newSoundObject.Anchored = true
	newSoundObject.CanCollide = false
	newSoundObject.Transparency = 1
	newSoundObject.Position = position
	local newSound = it("Sound",newSoundObject)
	newSound.SoundId = "rbxassetid://"..soundId
	newSound.Volume = volume
	newSound.Name = name
	newSound.Ended:Connect(function()
		newSoundObject:Destroy()
	end)
	return newSound
end

local function randomSong()
	local selectedSong
	repeat 
		local newSong = math.random(1, #songTable)
		selectedSong = songTable[newSong]
	until selectedSong ~= lastSong
	lastSong = selectedSong
	return selectedSong
end

--> Update Humanoid & Create Instances
local music = it("Sound")
music.Name = "Music"
music.SoundId = "rbxassetid://"..randomSong()
--music.Looped = true
music.Volume = 1
music.RollOffMinDistance = 25
music.RollOffMaxDistance = 300
music.Parent = rootpart
music:Play()

local gunPart = it("Part",character)
gunPart.Orientation = vt(0, 180, 0)
gunPart.Size = vt(4.699999809265137, 4.300000190734863, 0.800000011920929)
gunPart.Name = "Gun"
gunPart.Rotation = vt(180, 0, 180)
gunPart.Massless = true
gunPart.CanCollide = false

local gunWeld = createWeld(gunPart,rightarm,gunPart,"GunWeld")
local gunAttachment = createAttachment(gunPart,vt(1, -7.450580596923828e-08, -1.762527972459793e-07),vt(0.0000948222223087214, 0.00001009853440336883, -0.000004268884822522523),vt(7.450609729175994e-08, 1, 0.0000016549601014048676),vt(0.0000948222223087214, 0.0000103186430351343, -0.000006830188794992864),vt(2.1874499320983887, -2.0448765754699707, 0.07854291796684265))

local gunMesh = it("SpecialMesh",gunPart)
gunMesh.MeshId = "rbxassetid://4615369575"
gunMesh.MeshType = Enum.MeshType.FileMesh
gunMesh.Name = "GunMesh"
gunMesh.Scale = vt(1,1,1)
gunMesh.TextureId = "rbxassetid://4615393635"

local forceField = it("ForceField",character)
forceField.Visible = false

humanoid.MaxHealth = config.health
humanoid.Health = config.health
humanoid.WalkSpeed = config.walkspeed
humanoid.JumpPower = config.jumppower

--> Gui
local railGui = it("ScreenGui",player.PlayerGui)
local infoFrame = it("TextLabel",railGui)
infoFrame.TextWrapped = true
infoFrame.TextStrokeTransparency = 0
infoFrame.BorderSizePixel = 0
infoFrame.BackgroundColor3 = Color3.new(1, 1, 1)
infoFrame.TextStrokeColor3 = Color3.new(1, 0.282353, 0)
infoFrame.AnchorPoint = Vector2.new(0.5, 1)
infoFrame.TextSize = 30
infoFrame.Size = UDim2.new(1, 0, 0.100000001, 0)
infoFrame.Name = "Info"
infoFrame.BorderColor3 = Color3.new(0, 0, 0)
infoFrame.Text = "Method: kill"
infoFrame.BackgroundTransparency = 1
infoFrame.Position = UDim2.new(0.5, 0, 1, -20)
infoFrame.TextColor3 = Color3.new(1, 0.635294, 0)
infoFrame.Font = Enum.Font.Jura

--> Functions
local function talk(text)
	for i,v in pairs(head:GetChildren()) do
		if v:IsA("BillboardGui") then
			v:Destroy()
		end
	end

	local newTalk = it("BillboardGui",head)
	local wordsFrame = it("TextLabel",newTalk)

	newTalk.Active = true;
	newTalk.LightInfluence = 1;
	newTalk.AlwaysOnTop = true;
	newTalk.Size = UDim2.new(20, 0, 1, 0);
	newTalk.ClipsDescendants = true;
	newTalk.Name = "Talk";
	newTalk.StudsOffset = Vector3.new(0, 2, 0)

	wordsFrame.TextWrapped = true;
	wordsFrame.TextStrokeTransparency = 0;
	wordsFrame.BorderSizePixel = 0;
	wordsFrame.TextScaled = true;
	wordsFrame.BackgroundColor3 = Color3.new(1, 1, 1);
	wordsFrame.TextStrokeColor3 = Color3.new(1, 0.2, 0);
	wordsFrame.TextSize = 20;
	wordsFrame.Size = UDim2.new(1, 0, 1, 0);
	wordsFrame.Name = "Words";
	wordsFrame.BorderColor3 = Color3.new(0, 0, 0);
	wordsFrame.Text = "";
	wordsFrame.BackgroundTransparency = 1;
	wordsFrame.TextColor3 = Color3.new(1, 0.54902, 0)
	wordsFrame.Font = Enum.Font.Jura

	for i = 1,string.len(text) do
		task.wait(0.05)
		if newTalk then
			local talkSound = createSound(9043367153,1.5,head,"Talk")
			talkSound.PlaybackSpeed = (math.random(10,13)*.1)
			talkSound:Play()
			wordsFrame.Text = "{ "..string.sub(text,1,i).." }"
		end
	end

	task.wait(1)

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(wordsFrame, tweenInfo, { TextTransparency = 1 })
	transparencyTween:Play()
	transparencyTween.Completed:Connect(function()
		newTalk:Destroy()
	end)
end

local function applyDeathEffect(character)
	for i, part in pairs(character:GetDescendants()) do
		if part:IsA("Decal") then
			part:Destroy()
		end
		if part:IsA("BasePart") then
			part.Anchored = true
			table.insert(funkified, part)
			local originalCFrame = part.CFrame

			local randomRotationX = math.rad(math.random(-360, 360))
			local randomRotationY = math.rad(math.random(-360, 360))
			local randomRotationZ = math.rad(math.random(-360, 360))

			local randomRotationCFrame = CFrame.Angles(randomRotationX, randomRotationY, randomRotationZ)
			local targetCFrame = originalCFrame * CFrame.new(Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))) * randomRotationCFrame

			local transparencyTweenInfo = TweenInfo.new(1.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local transparencyTween = game:GetService("TweenService"):Create(part, transparencyTweenInfo, { Transparency = 1 })
			transparencyTween:Play()

			local cframeTweenInfo = TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local cframeTween = game:GetService("TweenService"):Create(part, cframeTweenInfo, { CFrame = targetCFrame })
			cframeTween:Play()

			local brickColorTweenInfo = TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local brickColorTween = game:GetService("TweenService"):Create(part, brickColorTweenInfo, { Color = Color3.fromRGB(213, 115, 61) })
			brickColorTween:Play()

			brickColorTween.Completed:Connect(function()
				character:Destroy()
			end)
		end
	end
end

function attack(position,range)
	for i, child in pairs(workspace:GetDescendants()) do
		if child.ClassName == "Model" and child ~= character then
			local dHumanoid = child:FindFirstChildOfClass("Humanoid")
			if dHumanoid then
				local dTorso = child:FindFirstChild("Torso") or child:FindFirstChild("UpperTorso") or child:FindFirstChild("HumanoidRootPart")
				if dTorso then
					if (dTorso.Position - position).Magnitude <= range then
						dHumanoid.Health = 0
						dHumanoid.Parent:BreakJoints()
						applyDeathEffect(dHumanoid.Parent)
						if game:GetService("Players"):GetPlayerFromCharacter(child) ~= nil then
							local detectedPlayer = game:GetService("Players"):GetPlayerFromCharacter(child)
							if method == 2 then
								if detectedPlayer ~= nil then
									coroutine.wrap(talk)("Vanish.")
									table.insert(voided,{detectedPlayer.Name, method})
								end
							end
							if method == 3 then
								if detectedPlayer ~= nil then
									coroutine.wrap(talk)("You weren't wanted here anyway.")
									table.insert(voided,{detectedPlayer.Name, method})
									detectedPlayer:Kick("nil")
								end
							end
							if method == 4 then
								if detectedPlayer ~= nil then
									coroutine.wrap(talk)("Have fun elsewhere.")
									table.insert(voided,{detectedPlayer.Name, method})
									local reserveInfo = game:GetService("TeleportService"):ReserveServer(game.PlaceId)
									game:GetService("TeleportService"):TeleportToPrivateServer(game.PlaceId, reserveInfo, {detectedPlayer})
								end	
							end
						end
					end
				end
			end
		end
	end
end

local function reloadVisual()
	local gunCopy = gunPart:Clone()
	gunCopy:ClearAllChildren()
	gunCopy.Transparency = 0.25
	gunCopy.CastShadow = false
	gunCopy.BrickColor = brickc("Neon orange")
	gunCopy.Material = Enum.Material.Neon
	gunCopy.Parent = character

	local meshCopy = gunMesh:Clone()
	meshCopy.TextureId = ""
	meshCopy.Parent = gunCopy

	createWeld(gunPart,gunCopy,gunPart,"ReloadVisual")

	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(gunCopy, tweenInfo, { Transparency = 1 })
	transparencyTween:Play()

	local sizeTween = game:GetService("TweenService"):Create(meshCopy, tweenInfo, { Scale = vt(meshCopy.Scale.X+0.5, meshCopy.Scale.Y+0.5, meshCopy.Scale.Z+2) })
	sizeTween:Play()

	transparencyTween.Completed:Connect(function()
		gunCopy:Destroy()
	end)
end

local function createIndicator2(endPosition, spawnCount,startSize)
	for i = 1, spawnCount do
		startSize =- 1
		local indicatorPart = Instance.new("Part", character)
		table.insert(indicators, indicatorPart)
		indicatorPart.Size = Vector3.new(startSize, startSize, startSize)
		indicatorPart.Anchored = true
		indicatorPart.CanCollide = false
		indicatorPart.Locked = true
		indicatorPart.CastShadow = false
		indicatorPart.BrickColor = brickc("Neon orange")
		indicatorPart.Material = Enum.Material.Neon
		indicatorPart.Transparency = 0.75

		indicatorPart.CFrame = CFrame.new(endPosition) * CFrame.Angles(math.random(), math.random(), math.random())

		local randomOrientation = CFrame.Angles(math.random(), math.random(), math.random())

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

		local orientationTween = game:GetService("TweenService"):Create(indicatorPart, tweenInfo, {
			CFrame = CFrame.lookAt(endPosition, endPosition + randomOrientation.LookVector)
		})
		orientationTween:Play()

		local transparencyTween = game:GetService("TweenService"):Create(indicatorPart, tweenInfo, { Transparency = 1 })
		transparencyTween:Play()

		orientationTween.Completed:Connect(function()
			indicatorPart:Destroy()
		end)
	end
end

local function createIndicator(startPosition,endPosition,size)	
	local indicatorPart = Instance.new("Part",character)
	table.insert(indicators, indicatorPart)
	indicatorPart.Size = vt(size, size, (startPosition - endPosition).magnitude)
	indicatorPart.Anchored = true
	indicatorPart.CanCollide = false
	indicatorPart.Locked = true
	indicatorPart.CastShadow = false
	indicatorPart.BrickColor = brickc("Neon orange")
	indicatorPart.Material = Enum.Material.Neon
	indicatorPart.Transparency = 0.75

	local midpoint = (startPosition + endPosition) / 2

	indicatorPart.CFrame = cf(midpoint, endPosition)

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local transparencyTween = game:GetService("TweenService"):Create(indicatorPart, tweenInfo, { Transparency = 1 })
	transparencyTween:Play()

	transparencyTween.Completed:Connect(function()
		indicatorPart:Destroy()
	end)
end

local function raycast(startPosition,endPosition,tasked)
	local bulletStartPos = startPosition
	local direction = (endPosition - bulletStartPos).unit
	local distance = (endPosition - bulletStartPos).magnitude + 1

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {character:GetDescendants(),indicators,funkified}
	local result = workspace:Raycast(bulletStartPos, direction * distance, raycastParams)

	if result then
		if tasked == 1 then
			createIndicator(startPosition,result and result.Position or endPosition,1.5)
			createSoundObject(2770705979,3,"Explosion",result and result.Position or endPosition):Play()
			createIndicator2(result and result.Position or endPosition,6,7)
			createIndicator2(startPosition,3,4)
		end
	end

	if result and result.Instance then
		if tasked == 1 then
			attack(result and result.Position or endPosition,10)
		end
	end
end

local function shoot(position)
	if not attacking and canAttack and not taunting then
		attacking = true
		canAttack = false
		rootpart.CFrame = cf(rootpart.CFrame.p,Vector3.new(position.X,rootpart.Position.Y,position.Z))
		humanoid.AutoRotate = false

		for i=1,12 do
			game:GetService('RunService').Stepped:wait()
			rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(0+0*math.cos(sine/13)),rad(20+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+0*math.sin(sine/13)),rad(0+0*math.cos(sine/13)),rad(20+0*math.cos(sine/13))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+0*math.cos(sine/13)),rad(-45+0*math.cos(sine/13)),rad(90+0*math.cos(sine/13))),.3)
		end

		createSound(2960518660,2,gunPart,"Railshot"):Play()
		raycast(gunAttachment.WorldPosition,mouse.Hit.Position,1)

		for i=1,4 do
			game:GetService('RunService').Stepped:wait()
			rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(0+0*math.cos(sine/13)),rad(20+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(124+0*math.sin(sine/13)),rad(0+0*math.cos(sine/13)),rad(20+0*math.cos(sine/13))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+0*math.cos(sine/13)),rad(-45+0*math.cos(sine/13)),rad(90+0*math.cos(sine/13))),.3)
		end

		for i=1,2 do
			game:GetService('RunService').Stepped:wait()
			rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(0+0*math.cos(sine/13)),rad(20+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/13),0.75+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(269+0*math.sin(sine/13)),rad(-29+0*math.cos(sine/13)),rad(-3+0*math.cos(sine/13))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+0*math.cos(sine/13)),rad(-45+0*math.cos(sine/13)),rad(90+0*math.cos(sine/13))),.3)
		end
		humanoid.AutoRotate = true
		attacking = false
		wait(1)
		reloadVisual()
		canAttack = true
	end
end

local function changeMethod()
	method = method +1
	local methodText
	if method == 2 then
		methodText = "Method: Bаnish" -- Russian a

		infoFrame.Text = methodText
		coroutine.wrap(talk)(methodText)
	elseif method == 3 then
		methodText = "Method: Permakiсk" -- Russian c

		infoFrame.Text = methodText
		coroutine.wrap(talk)(methodText)
	elseif method == 4 then
		methodText = "Method: Reserver"

		infoFrame.Text = methodText
		coroutine.wrap(talk)(methodText)
	elseif method == 5 then
		methodText = "Method: Kill"

		infoFrame.Text = methodText
		coroutine.wrap(talk)(methodText)
		method = 1
	end
end

local function clearTables(targetValue)
	if targetValue ~= "All" then
		if #voided > 0 then
			for i = #voided, 1, -1 do
				if voided[i][2] == targetValue then
					table.remove(voided, i)
				end
			end
		end
	end

	if targetValue == 2 then
		coroutine.wrap(talk)("Unbanished.")
	elseif targetValue == 3 then
		coroutine.wrap(talk)("The gates have reopened.")
	elseif targetValue == 4 then
		coroutine.wrap(talk)("You may visit again.")
	elseif targetValue == "All" then
		table.clear(voided)
		coroutine.wrap(talk)("Tables Cleared")
	end
end
--[[ Old clearer
local function clearTables(tableType)
	if tableType == 1 then
		table.clear(voided)
		coroutine.wrap(talk)("Tables Cleared")
	end
end]]

local function teleport()
	if mouse.Target then
		local newPosition = mouse.Hit.Position + vt(0,3,0)
		local oldPosition = rootpart.Position
		createIndicator2(oldPosition,6,10)
		createIndicator(oldPosition,newPosition,6)
		createSound(164320294,2,rootpart,"Teleport"):Play()
		createIndicator2(newPosition,6,10)
		rootpart.CFrame = cf(newPosition) * angles(0,math.random(-360,360),0)
	end
end

local function fly()
	flying = not flying
	if flying then
		bodyGyro = Instance.new("BodyGyro",rootpart)
		bodyVelocity = Instance.new('BodyVelocity',rootpart)
		bodyGyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		bodyGyro.P = 1e4
		bodyGyro.CFrame = rootpart.CFrame
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	else
		if bodyGyro then
			bodyGyro:Destroy()
		end
		if bodyVelocity then
			bodyVelocity:Destroy()
		end
	end
end

local function updateMovement()
	if flying and bodyVelocity then
		local moveDirection = (keys.wDown and Vector3.new(0, 1, 0) or Vector3.new(0, 0, 0))
			+ (keys.aDown and Vector3.new(-1, 0, 0) or Vector3.new(0, 0, 0))
			+ (keys.sDown and Vector3.new(0, -1, 0) or Vector3.new(0, 0, 0))
			+ (keys.dDown and Vector3.new(1, 0, 0) or Vector3.new(0, 0, 0))
		local moveVector = rootpart.CFrame.LookVector * moveDirection
		bodyVelocity.Velocity = moveVector * 10
	end
end

local function keyPress(key)
	if key == "w" then
		keys.wDown = true
	end
	if key == "a" then
		keys.aDown = true
	end
	if key == "s" then
		keys.sDown = true
	end
	if key == "d" then
		keys.dDown = true
	end
	if key == "t" then
		taunting = not taunting
	end
	if key == "z" then
		if music ~= nil then
			coroutine.wrap(talk)("Let's switch it up a little.")
			music.SoundId = "rbxassetid://"..randomSong()
			music.TimePosition = 0
			music:Play()
		end
	end
	if key == "f" then
		keys.fDown = true
		while keys.fDown do
			shoot(mouse.Hit.Position)
			task.wait()
		end
	end
	if key == "e" then
		teleport()
	end
	if key == "n" then
		clearTables(2)
	end
	if key == "b" then
		clearTables(3)
	end
	if key == "v" then
		clearTables(4)
	end
	if key == "c" then
		clearTables("All")
	end
	if key == "m" then
		changeMethod()
	end
end

local function keyUnpress(key)
	if key == "w" then
		keys.wDown = false
	end
	if key == "a" then
		keys.aDown = false
	end
	if key == "s" then
		keys.sDown = false
	end
	if key == "d" then
		keys.dDown = false
	end
	if key == "f" then
		keys.fDown = false
	end
end

--> Misc Functionality
game:GetService("Workspace").ChildAdded:Connect(function(child)
	for _, v in pairs(voided) do
		local instance, deathMethod = unpack(v)
		if child.Name == instance then
			if game:GetService("Players"):GetPlayerFromCharacter(child) ~= nil then
				local detectedPlayer = game:GetService("Players"):GetPlayerFromCharacter(child)
				if deathMethod == 2 then
					if detectedPlayer ~= nil then
						detectedPlayer.Character:Destroy()
					end
				elseif deathMethod == 3 then
					if detectedPlayer ~= nil then
						game:GetService("Players"):GetPlayerFromCharacter(child):Kick("nil")
					end
				elseif deathMethod == 4 then
					if detectedPlayer ~= nil then
						local reserveInfo = game:GetService("TeleportService"):ReserveServer(game.PlaceId)
						game:GetService("TeleportService"):TeleportToPrivateServer(game.PlaceId, reserveInfo, {detectedPlayer})
					end
				end
			end
		end
	end
end)

music.Ended:Connect(function()
	if music ~= nil then
		coroutine.wrap(talk)("Let's switch it up a little.")
		music.SoundId = "rbxassetid://"..randomSong()
		music.TimePosition = 0
		music:Play()
	end
end)

humanoid.Died:Connect(function()
	if music then
		music:Destroy()
	end
	createSound(4829723033,2,rootpart,"Death"):Play()
end)

player.Chatted:Connect(function(chatMessage)
	if chatMessage ~= nil then
		coroutine.wrap(talk)(chatMessage)
	end
end)
--> Inputs
mouse.KeyDown:Connect(function(key)
	keyPress(key)
end)

mouse.KeyUp:Connect(function(key)
	keyUnpress(key)
end)

mouse.Button1Down:Connect(function()
	mouseDown = true
end)

mouse.Button1Up:Connect(function()
	mouseDown = false
end)

--> Loop
game:GetService("RunService").Heartbeat:Connect(function()
	sine = sine +2

	local velocity = (rootpart.Velocity * vt(1, 0, 1)).magnitude

	if keys.wDown or keys.aDown or keys.sDown or keys.dDown then
		updateMovement()
	end

	humanoid.Health = config.health
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

	if not taunting then
		humanoid.WalkSpeed = config.walkspeed
		humanoid.JumpPower = config.jumppower
		gunPart.Transparency = 0
		if rootpart.Velocity.y > 1 and not flying then 
			-- Jump

			neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/5),1+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(10+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			if not attacking then
				rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/5),0+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(10+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/5),0.5+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(130+0*math.cos(sine/5)),rad(20+0*math.cos(sine/5)),rad(30+0*math.cos(sine/5))),.3)
			end
			ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/5),0.5+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(130+0*math.cos(sine/5)),rad(-20+0*math.cos(sine/5)),rad(-30+0*math.cos(sine/5))),.3)
			rh.C0 = rh.C0:Lerp(cf(0.5+-0*math.cos(sine/5),-0.5+0*math.cos(sine/5),-0.5+0*math.cos(sine/5))*angles(rad(-10+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/5),-0.75+0*math.cos(sine/5),-0.25+0*math.cos(sine/5))*angles(rad(-10+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),0.75+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+5*math.cos(sine/13)),rad(-45+-5*math.cos(sine/13)),rad(90+5*math.cos(sine/13))),.3)
		elseif rootpart.Velocity.y < -1 and not flying then 
			-- Fall

			neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/5),1+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(-20+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			if not attacking then
				rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/5),0+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(-10+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/5),0.5+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(80+0*math.cos(sine/5)),rad(20+0*math.cos(sine/5)),rad(30+0*math.cos(sine/5))),.3)
			end
			ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/5),0.5+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(80+0*math.cos(sine/5)),rad(-20+0*math.cos(sine/5)),rad(-30+0*math.cos(sine/5))),.3)
			rh.C0 = rh.C0:Lerp(cf(0.5+-0*math.cos(sine/5),-0.5+0*math.cos(sine/5),-0.5+0*math.cos(sine/5))*angles(rad(20+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/5),-0.75+0*math.cos(sine/5),-0.25+0*math.cos(sine/5))*angles(rad(15+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),0.75+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+5*math.cos(sine/13)),rad(-45+-5*math.cos(sine/13)),rad(90+5*math.cos(sine/13))),.3)
		elseif velocity < 1 then
			-- Idle

			if not flying then
				neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(-7.5+-10*math.sin(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
				if not attacking then
					rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/13),0+0.25*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(3+3*math.cos(sine/13)),rad(0+0*math.sin(sine/13)),rad(0+0*math.cos(sine/13))),.3)
					rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/13),0.5+0.25*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(115+15*math.sin(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
				end
				ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/13),0.5+0.25*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(-10+0*math.sin(sine/13)),rad(0+0*math.cos(sine/13)),rad(10+0*math.cos(sine/13))),.3)
				rh.C0 = rh.C0:Lerp(cf(0.55+0*math.cos(sine/13),-1+-0.25*math.cos(sine/13),-0.25+0*math.cos(sine/13))*angles(rad(-5+-4.5*math.cos(sine/13)),rad(-15+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
				lh.C0 = lh.C0:Lerp(cf(-0.55+0*math.cos(sine/13),-1+-0.25*math.cos(sine/13),-0.25+0*math.cos(sine/13))*angles(rad(-5+-4.5*math.cos(sine/13)),rad(15+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
				gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),0.75+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+5*math.cos(sine/13)),rad(-45+-5*math.cos(sine/13)),rad(90+5*math.cos(sine/13))),.3)
			else
				-- Idle Flying

				neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.sin(sine/13))*angles(rad(-15+5*math.sin(sine/13)),rad(0+11*math.cos(sine/13)),rad(0+0*math.sin(sine/13))),.3)
				if not attacking then
					rj.C0 = rj.C0:Lerp(cf(0+0*math.sin(sine/23),0+1*math.sin(sine/23),0+0*math.cos(sine/23))*angles(rad(15+5*math.cos(sine/23)),rad(0+0*math.cos(sine/23)),rad(0+5*math.cos(sine/23))),.3)
					rs.C0 = rs.C0:Lerp(cf(1.25+0*math.sin(sine/23),0.5+0.5*math.sin(sine/23),-0.5+0*math.sin(sine/23))*angles(rad(100+0*math.cos(sine/23)),rad(-23+-3*math.cos(sine/23)),rad(33+-5*math.cos(sine/23))),.3)
				end	
				ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/23),0.5+0*math.cos(sine/23),0+0*math.cos(sine/23))*angles(rad(-32+2*math.cos(sine/23)),rad(-9+4*math.cos(sine/23)),rad(22+4*math.cos(sine/23))),.3)
				rh.C0 = rh.C0:Lerp(cf(0.5+0*math.cos(sine/23),-1+0*math.cos(sine/23),0+0*math.cos(sine/23))*angles(rad(-27+-15*math.cos(sine/23)),rad(0+0*math.cos(sine/23)),rad(0+0*math.cos(sine/23))),.3)
				lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/23),-0.5+0*math.cos(sine/23),-0.5+0*math.cos(sine/23))*angles(rad(-21+11*math.cos(sine/23)),rad(10+0*math.cos(sine/23)),rad(0+0*math.cos(sine/23))),.3)
				gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/13),0.75+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(90+5*math.cos(sine/13)),rad(-45+-5*math.cos(sine/13)),rad(90+5*math.cos(sine/13))),.3)
			end
		elseif velocity >= 1 then
			-- Walk

			if not flying then
				neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/5),1+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(15+-10*math.cos(sine/5)),rad(0+10*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				if not attacking then
					rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/5),0+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(-15+10*math.sin(sine/5)),rad(0+-5*math.cos(sine/5)),rad(0+0*math.sin(sine/5))),.3)
					rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/5),0.5+0.25*math.cos(sine/5),0+-0.25*math.cos(sine/5))*angles(rad(150+-21*math.sin(sine/5)),rad(0+-5*math.cos(sine/5)),rad(0+-5*math.cos(sine/5))),.3)
				end	
				ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/5),0.5+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(-74+-23*math.sin(sine/5)),rad(0+20*math.cos(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				rh.C0 = rh.C0:Lerp(cf(0.5+0*math.cos(sine/5),-1+0.5*math.cos(sine/5),-0.5+-1*math.cos(sine/5))*angles(rad(0+90*math.sin(sine/5)),rad(0+0*math.sin(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/5),-1+-0.5*math.cos(sine/5),-0.5+1*math.cos(sine/5))*angles(rad(0+-90*math.sin(sine/5)),rad(0+0*math.sin(sine/5)),rad(0+0*math.cos(sine/5))),.3)
				gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/5),0.75+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(90+5*math.cos(sine/5)),rad(-45+-5*math.cos(sine/5)),rad(90+5*math.cos(sine/5))),.3)
			else
				-- Walk Flying

				neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/20),1+0*math.cos(sine/20),0+0*math.cos(sine/20))*angles(rad(10+3*math.sin(sine/20)),rad(0+3*math.cos(sine/20)),rad(2+3*math.cos(sine/20))),.3)
				if not attacking then
					rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/20),1+-1*math.cos(sine/20),0+0*math.cos(sine/20))*angles(rad(-30+-3*math.sin(sine/20)),rad(0+3*math.cos(sine/20)),rad(0+-3*math.cos(sine/20))),.3)
					rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/20),0.5+0*math.cos(sine/20),0+0*math.cos(sine/20))*angles(rad(104+1*math.cos(sine/20)),rad(-21+1*math.cos(sine/20)),rad(-14+1*math.cos(sine/20))),.3)
				end
				ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/40),0.5+0*math.cos(sine/40),0+0*math.cos(sine/40))*angles(rad(-9+5*math.cos(sine/40)),rad(37+5*math.cos(sine/40)),rad(-16+5*math.cos(sine/40))),.3)
				rh.C0 = rh.C0:Lerp(cf(0.5+0*math.cos(sine/13),-0.75+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*angles(rad(-9+3*math.cos(sine/13)),rad(-9+3*math.cos(sine/13)),rad(0+3*math.cos(sine/13))),.3)
				lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/13),-1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(-14+-3*math.cos(sine/13)),rad(20+3*math.cos(sine/13)),rad(0+1*math.cos(sine/13))),.3)
				gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/5),0.75+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(90+5*math.cos(sine/5)),rad(-45+-5*math.cos(sine/5)),rad(90+5*math.cos(sine/5))),.3)
			end
		end
	end
	if taunting and not attacking then
		humanoid.WalkSpeed = 5
		humanoid.JumpPower = 0
		if not flying then
			neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/8),1+0*math.cos(sine/8),0+0*math.cos(sine/8))*angles(rad(0+26*math.cos(sine/8)),rad(0+26*math.sin(sine/8)),rad(0+0*math.cos(sine/8))),.3)
			rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/8),0+-0.25*math.sin(sine/8),0+0*math.cos(sine/8))*angles(rad(0+20*math.cos(sine/8)),rad(0+0*math.cos(sine/8)),rad(0+0*math.cos(sine/8))),.3)
			rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/16),0.5+0*math.cos(sine/16),0+0*math.cos(sine/16))*angles(rad(180+31*math.cos(sine/16)),rad(0+11*math.cos(sine/16)),rad(0+-5*math.cos(sine/16))),.3)
			ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/16),0.5+0*math.cos(sine/16),0+0*math.cos(sine/16))*angles(rad(180+-43*math.cos(sine/16)),rad(0+-12*math.cos(sine/16)),rad(0+-5*math.cos(sine/16))),.3)
			rh.C0 = rh.C0:Lerp(cf(0.5+0*math.cos(sine/8),-0.7+0.5*math.sin(sine/8),-0.5+0.25*math.cos(sine/8))*angles(rad(0+-20*math.cos(sine/8)),rad(0+0*math.cos(sine/8)),rad(0+0*math.cos(sine/8))),.3)
			lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/8),-0.5+-0.25*math.sin(sine/8),-0.5+0.25*math.cos(sine/8))*angles(rad(0+-20*math.cos(sine/8)),rad(0+0*math.cos(sine/8)),rad(0+0*math.cos(sine/8))),.3)
			gunWeld.C0 = gunWeld.C0:Lerp(cf(-2+0*math.cos(sine/5),0.75+0*math.cos(sine/5),0+0*math.cos(sine/5))*angles(rad(90+5*math.cos(sine/5)),rad(-45+-5*math.cos(sine/5)),rad(90+5*math.cos(sine/5))),.3)
			gunPart.Transparency = 1
		else
			neck.C0 = neck.C0:Lerp(cf(0+0*math.cos(sine/20),1+0*math.cos(sine/20),0+0*math.cos(sine/20))*angles(rad(0+0*math.sin(sine/20)),rad(0+-30*math.cos(sine/20)),rad(0+0*math.cos(sine/20))),.3)
			rj.C0 = rj.C0:Lerp(cf(0+0*math.cos(sine/400),0+0*math.cos(sine/400),0+0*math.cos(sine/400))*angles(rad(0+360*math.sin(sine/400)),rad(0+360*math.cos(sine/400)),rad(0+360*math.cos(sine/400))),.3)
			rs.C0 = rs.C0:Lerp(cf(1+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(180+-60*math.cos(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			ls.C0 = ls.C0:Lerp(cf(-1+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(180+60*math.cos(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			rh.C0 = rh.C0:Lerp(cf(0.5+0*math.cos(sine/13),-1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(0+30*math.cos(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			lh.C0 = lh.C0:Lerp(cf(-0.5+0*math.cos(sine/13),-1+0*math.cos(sine/13),0+0*math.cos(sine/13))*angles(rad(0+-30*math.cos(sine/13)),rad(0+0*math.cos(sine/13)),rad(0+0*math.cos(sine/13))),.3)
			gunPart.Transparency = 1
		end
	end
end)
talk("Made by @zekevious")
