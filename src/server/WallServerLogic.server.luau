local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WallConfig = require(ReplicatedStorage:WaitForChild("WallConfig"))
local event = ReplicatedStorage:WaitForChild("WallBreakEvent")
local CarsFolder = workspace:WaitForChild("Cars")

event.OnServerEvent:Connect(function(player, wall, carModel)
	-- 1. SECURITY CHECKS
	if not wall or not wall:IsDescendantOf(workspace) then
		return
	end
	if wall.Transparency >= 1 then
		return
	end -- Already broken by someone else

	-- Verify car is actually real
	if not carModel or not carModel:IsDescendantOf(CarsFolder) then
		return
	end

	-- 2. SERVER BREAK (Replicates to other players)
	wall.Transparency = 1
	wall.CanCollide = false

	local typeName = wall:GetAttribute("WallType")
	local stats = WallConfig.Stats[typeName]
	if not stats then
		return
	end

	if wall:FindFirstChild("DebrisChunks") then
		wall.DebrisChunks:Emit(stats.DebrisCount)
	end

	-- 3. GIVE MONEY
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats:FindFirstChild("Coins") then
		leaderstats.Coins.Value += stats.Reward
	end

	-- 4. DAMAGE CAR
	local carScript = carModel:FindFirstChild("CarScript")
	if carScript then
		local healthObject = carScript:FindFirstChild("Health")
		if healthObject then
			healthObject.Value -= stats.Health
			print("Damaged " .. carModel.Name .. ". HP is now: " .. healthObject.Value)

			if healthObject.Value <= 0 then
				print(carModel.Name .. " is broken!")
			end
		end
	end
end)
