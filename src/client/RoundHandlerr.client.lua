local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local RoundSignals = ReplicatedStorage:WaitForChild("Singals"):WaitForChild("RoundSignals")

local GetTimeSignal = RoundSignals:WaitForChild("GetTime")

local TimerGUI = player.PlayerGui:WaitForChild("RoundTimer")
local TimerPivot = TimerGUI:WaitForChild("TimerPivot")
local TimerLabel: TextLabel = TimerPivot:WaitForChild("Timer")

local timer = 0

function updateTimerGUI()
	local currentTime = math.ceil(timer)
	local min = math.floor(currentTime/60)
	local secs = currentTime%60
	TimerLabel.Text = string.format("%s:%02d", min, secs)
end

GetTimeSignal.OnClientEvent:Connect(function(timeRemaning: number)
	timer = timeRemaning-player:GetNetworkPing()
	updateTimerGUI()
	TimerLabel.Visible = true
end)

RunService.Heartbeat:Connect(function(deltaTime)
	timer -= deltaTime
	if timer <= 0 then
		timer = 0
	end
	updateTimerGUI()
end)

GetTimeSignal:FireServer()