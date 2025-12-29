local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local carsFolder = Workspace:WaitForChild("Cars")

local function setupDeathLogic(carModel)
	-- 1. Find the Health Object
	-- We wait up to 5 seconds just to be safe in case the game is lagging
	local carScript = carModel:WaitForChild("CarScript", 5)
	if not carScript then return end

	local healthObj = carScript:WaitForChild("Health", 5)
	if not healthObj then return end

	-- 2. Watch for changes
	healthObj.Changed:Connect(function(newHealth)

		if newHealth <= 0 then
			-- Prevent double explosion
			if carModel:GetAttribute("IsDead") then return end
			carModel:SetAttribute("IsDead", true)

			print("BOOM! " .. carModel.Name .. " destroyed.")

			-- 3. Explosion Logic
			local seat = carModel:FindFirstChild("DriveSeat") or carModel:FindFirstChildWhichIsA("VehicleSeat")

			if seat then
				-- Visuals
				local explosion = Instance.new("Explosion")
				explosion.Position = seat.Position
				explosion.BlastRadius = 15
				explosion.BlastPressure = 500000 
				explosion.Parent = Workspace

				-- Kill Driver
				if seat.Occupant then
					seat.Occupant.Health = 0
				end
			end

			-- 4. Destroy Car
			carModel:BreakJoints()
			Debris:AddItem(carModel, 5) -- Deletes parts after 5 seconds
		end
	end)
end

-- RUN THE LOGIC ON ALL CARS IMMEDIATELY
for _, car in pairs(carsFolder:GetChildren()) do
	task.spawn(function() 
		setupDeathLogic(car) 
	end)
end

-- ALSO WATCH FOR NEW CARS (Just in case you add respawning later)
carsFolder.ChildAdded:Connect(function(child)
	task.wait(1) 
	setupDeathLogic(child)
end)