local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local gameSpawnLocations = Workspace:WaitForChild("Game"):WaitForChild("SpawnLocations")
local lobbySpawnLocations = Workspace:WaitForChild("Lobby"):WaitForChild("SpawnLocations")

local RoundSignals = ReplicatedStorage:WaitForChild("Singals"):WaitForChild("RoundSignals")

local GetTimeSignal = RoundSignals:WaitForChild("GetTime")

-- In seconds
local ROUND_DURATION = .2*60
local INTERMISSION_DURATION = .2*60
local currentDuration = 0

local startTime = tick()

local roundActive = true

function teleportPlayers(spawnLocations)
	local players = Players:GetPlayers() -- needs to be replaced with only players who actually want to play!

	for _, player in pairs(players) do
		local locationNumber = math.random(1,#spawnLocations)
		player.Character:MoveTo(spawnLocations[locationNumber].CFrame.Position)
		--only one Player should be spawned at one location if they're in game
		if roundActive then table.remove(spawnLocations, locationNumber) end
	end

	
end

function changeState()
	roundActive = not roundActive
	local spawnLocations = {}
	if roundActive then
		spawnLocations = gameSpawnLocations:GetChildren()
	else
		spawnLocations = lobbySpawnLocations:GetChildren()
	end
	teleportPlayers(spawnLocations)
	
end


RunService.Heartbeat:Connect(function(deltaTime)
	if tick()-startTime >= currentDuration then
		changeState()
		currentDuration = (roundActive and ROUND_DURATION or INTERMISSION_DURATION)
		startTime = tick()
		GetTimeSignal:FireAllClients(currentDuration)
	end
end)

GetTimeSignal.OnServerEvent:Connect(function(player)
	GetTimeSignal:FireClient(player, currentDuration-(tick()-startTime))
end)