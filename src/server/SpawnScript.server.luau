local Players = game:GetService("Players")

local spawnPart = game.Workspace:WaitForChild("SpawnTarget")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Wait for physics engine to settle and move character model to custom spawn
		local targetPos = spawnPart.Position + Vector3.new(0, 3, 0)
		character:PivotTo(CFrame.new(targetPos))
	end)
end)
