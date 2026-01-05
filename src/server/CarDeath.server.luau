local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local carsFolder = Workspace:WaitForChild("Cars")

-- [[ 1. THE DEATH LOGIC ]] --
local function setupDeathLogic(carModel)
	-- Check if logic is already applied to avoid duplicates
	if carModel:GetAttribute("DeathLogicActive") then
		return
	end
	carModel:SetAttribute("DeathLogicActive", true)

	-- 1. Find the Health Object
	-- We wait up to 5 seconds just to be safe in case the game is lagging
	local carScript = carModel:WaitForChild("CarScript", 5)
	if not carScript then
		return
	end

	local healthObj = carScript:WaitForChild("Health", 5)
	if not healthObj then
		return
	end

	-- 2. Watch for changes
	healthObj.Changed:Connect(function(newHealth)
		if newHealth <= 0 then
			-- Prevent double explosion
			if carModel:GetAttribute("IsDead") then
				return
			end
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

-- [[ 2. RUN THE LOGIC ON EXISTING CARS ]] --
-- We use GetDescendants to find cars inside Rarity folders
for _, descendant in pairs(carsFolder:GetDescendants()) do
	-- We identify a valid car by finding its script
	if descendant.Name == "CarScript" and descendant.Parent:IsA("Model") then
		task.spawn(function()
			setupDeathLogic(descendant.Parent)
		end)
	end
end

-- [[ 3. WATCH FOR NEW CARS ]] --
-- This detects if a car spawns inside ANY subfolder (Common, Rare, etc.)
carsFolder.DescendantAdded:Connect(function(descendant)
	if descendant.Name == "CarScript" and descendant.Parent:IsA("Model") then
		task.wait(0.5) -- Small wait to ensure the car is fully loaded
		setupDeathLogic(descendant.Parent)
	end
end)
