local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WallConfig = require(ReplicatedStorage:WaitForChild("WallConfig"))
local event = ReplicatedStorage:WaitForChild("WallBreakEvent")
local CarsFolder = workspace:WaitForChild("Cars")

event.OnServerEvent:Connect(function(player, wallType, carModel)
	-- 1. SECURITY CHECK: Verify stats exist
	local stats = WallConfig.Stats[wallType]
	if not stats then return end

	-- 2. GIVE MONEY
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats and leaderstats:FindFirstChild("Coins") then
		leaderstats.Coins.Value = leaderstats.Coins.Value + stats.Reward
	end

	-- 3. DAMAGE CAR
	-- We check if carModel exists and is actually inside the Cars folder
	if carModel and carModel.Parent == CarsFolder then

		local carScript = carModel:FindFirstChild("CarScript")

		if carScript then
			-- Find the ACTUAL Health Object inside the script
			local healthObject = carScript:FindFirstChild("Health")

			if healthObject then
				-- Subtract the damage from the current value
				healthObject.Value = healthObject.Value - stats.Health

				print("Damaged " .. carModel.Name .. ". HP is now: " .. healthObject.Value)
			end
		end
	end
end)