local Player = game:GetService("Players")[script.Parent.Value.Value]

    local Char = Player.Character
    local Event = Char:WaitForChild("UserInput_Event")

    local UIS = game:GetService("UserInputService")

    local input = function(io,a)
        if a then return end
        local io = {KeyCode=io.KeyCode,UserInputType=io.UserInputType,UserInputState=io.UserInputState}
        Event:FireServer(io)
    end
    UIS.InputBegan:Connect(input)
    UIS.InputEnded:Connect(input)
    local Changed = false
    local Mouse = Player:GetMouse()
    local h,t = Mouse.Hit,Mouse.Target
    game:GetService("RunService").RenderStepped:Connect(function()
        if h~=Mouse.Hit or t~=Mouse.Target then
            Event:FireServer({isMouse=true,Target=Mouse.Target,Hit=Mouse.Hit})
            h,t=Mouse.Hit,Mouse.Target
	end
	for i,v in pairs(Char.Humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
    end)
