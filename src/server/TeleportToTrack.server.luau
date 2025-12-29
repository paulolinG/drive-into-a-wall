local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local TeleportEvent = Events:WaitForChild("TeleportToTrackEvent")
local Tracks = workspace:WaitForChild("LocalTracks")

TeleportEvent.OnServerEvent:Connect(function(player: Player, trackName: string)
	local trackSpawnPartName = trackName .. "TrackSpawn"
	local track = trackName .. "_LocalTrack"
	local trackInstance = Tracks:FindFirstChild(track)
	if not trackInstance then
		warn("Failed to find track instance " .. track)
		return
	end
	local trackSpawn = trackInstance:FindFirstChild(trackSpawnPartName)
	if not trackSpawn then
		warn("Failed to find spawn for track " .. trackSpawnPartName)
		return
	end
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local targetPos = trackSpawn.Position + Vector3.new(0, 3, 0)	
		character:PivotTo(CFrame.new(targetPos))
	end
end)