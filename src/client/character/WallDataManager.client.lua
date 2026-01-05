local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("WallBreakEvent")
local CarsFolder = workspace:WaitForChild("Cars")
local player = Players.LocalPlayer

-- [[ 1. INSTANT BREAK (VISUALS) ]] --
local function clientBreakWall(wall, carModel)
	if wall.Transparency >= 1 then
		return
	end

	-- INSTANTLY HIDE IT LOCALLY
	wall.Transparency = 1
	wall.CanCollide = false

	-- Play Sound/Particles locally for instant feedback
	if wall:FindFirstChild("SmashSound") then
		wall.SmashSound:Play()
	end
	if wall:FindFirstChild("Sparkles") then
		wall.Sparkles:Emit(50)
	end

	-- Tell Server to do the Math (Money/Damage)
	event:FireServer(wall, carModel)
end

-- [[ 2. TOUCH LISTENER ]] --
local function setupWallListener(wall)
	wall.Touched:Connect(function(hit)
		-- Simple check: Is it a car part?
		if hit:IsDescendantOf(CarsFolder) then
			local current = hit
			local carModel = nil

			-- [[ UPDATED LOOP: Handles Rarity Folders ]] --
			while current and current ~= CarsFolder do
				-- Case A: Car is directly inside Cars folder (Cars -> Car)
				if current.Parent == CarsFolder then
					carModel = current
					break
				end
				-- Case B: Car is inside a Rarity Folder (Cars -> Rarity -> Car)
				if current.Parent.Parent == CarsFolder then
					carModel = current
					break
				end
				current = current.Parent
			end

			if carModel then
				-- Check if WE are the driver (so only one person fires the event)
				local seat = carModel:FindFirstChild("DriveSeat") or carModel:FindFirstChild("VehicleSeat")
				if seat and seat.Occupant and seat.Occupant.Parent == player.Character then
					clientBreakWall(wall, carModel)
				end
			end
		end
	end)
end

-- [[ 3. INIT ]] --
for _, obj in pairs(game.Workspace:GetDescendants()) do
	if obj.Name == "BreakableWall" and obj:IsA("BasePart") then
		setupWallListener(obj)
	end
end

game.Workspace.DescendantAdded:Connect(function(descendant)
	if descendant.Name == "BreakableWall" and descendant:IsA("BasePart") then
		setupWallListener(descendant)
	end
end)

-- [[ 4. RESPAWN LOGIC ]] --
local function resetTrack()
	for _, obj in pairs(game.Workspace:GetDescendants()) do
		if obj.Name == "BreakableWall" and obj:IsA("BasePart") then
			obj.CanCollide = false
			if obj.Material == Enum.Material.Glass then
				obj.Transparency = 0.5
			elseif obj.Material == Enum.Material.Neon then
				obj.Transparency = 0.2
			else
				obj.Transparency = 0
			end
		end
	end
end
task.wait(1)
resetTrack()
