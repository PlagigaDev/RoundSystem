local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local RoundSignals = ReplicatedStorage:WaitForChild("Singals"):WaitForChild("RoundSignals")

local GetTimeSignal = RoundSignals:WaitForChild("GetTime")

local TimerGUI = player.PlayerGui:WaitForChild("RoundTimer")
local TimerPivot = TimerGUI:WaitForChild("TimerPivot")
local TimerLabel: TextLabel = TimerPivot:WaitForChild("Timer")

local FadeScreen = Instance.new("Frame")
FadeScreen.BackgroundColor3 = Color3.new()
FadeScreen.AnchorPoint = Vector2.new(.5,.5)
FadeScreen.Position = UDim2.fromScale(.5,.5)
FadeScreen.Size = UDim2.fromScale(1.5,1.5)
FadeScreen.BackgroundTransparency = 1
FadeScreen.Parent = TimerGUI

local timer = 0

local FADE_DURATION = 1
local fadeTweenInfo = TweenInfo.new(FADE_DURATION/2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false)
local fadeActive = false

function updateTimerGUI()
	local currentTime = math.ceil(timer)
	local min = math.floor(currentTime/60)
	local secs = currentTime%60
	TimerLabel.Text = string.format("%s:%02d", min, secs)
end

function fadeScreen()
	if fadeActive then return end
	fadeActive = true
	local tween = TweenService:Create(FadeScreen, fadeTweenInfo, {["Transparency"] = 0})
	tween:Play()
	tween.Completed:Connect(function(playbackState)
		task.wait(.5)
		local tweenTwo = TweenService:Create(FadeScreen, fadeTweenInfo, {["Transparency"] = 1})
		tweenTwo:Play()
		tweenTwo.Completed:Connect(function()
			fadeActive = false
		end)
	end)
end

GetTimeSignal.OnClientEvent:Connect(function(timeRemaning: number)
	timer = timeRemaning-player:GetNetworkPing()
	updateTimerGUI()
	TimerLabel.Visible = true
end)

RunService.Heartbeat:Connect(function(deltaTime)
	timer -= deltaTime
	if timer <= .6 then
		fadeScreen()
	end
	updateTimerGUI()
end)

GetTimeSignal:FireServer()