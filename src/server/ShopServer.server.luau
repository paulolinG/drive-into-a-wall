local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- CONFIGURATION: Set your prices here
local CAR_PRICES = {
	Jeep = 0, -- Free starter car
	Jeep2 = 500, -- Mid-tier
	Jeep3 = 2000, -- High-tier
}

-- 1. SETUP REMOTES (Communication between Client and Server)
local shopEvent = Instance.new("RemoteFunction")
shopEvent.Name = "ShopFunction"
shopEvent.Parent = ReplicatedStorage

-- 2. SETUP PLAYER OWNERSHIP DATA
Players.PlayerAdded:Connect(function(player)
	-- Create a folder to remember what cars they own
	local ownedFolder = Instance.new("Folder")
	ownedFolder.Name = "OwnedCars"
	ownedFolder.Parent = player

	-- Give them the default Jeep for free
	local starterCar = Instance.new("StringValue")
	starterCar.Name = "Jeep"
	starterCar.Parent = ownedFolder
end)

-- 3. HANDLE REQUESTS (Buy or Spawn)
function shopEvent.OnServerInvoke(player, action, carName)
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins = leaderstats and leaderstats:FindFirstChild("Coins")
	local ownedFolder = player:FindFirstChild("OwnedCars")
	local price = CAR_PRICES[carName]

	if not coins or not ownedFolder or not price then
		return "Error"
	end

	if action == "Buy" then
		-- CHECK IF THEY CAN AFFORD IT
		if coins.Value >= price then
			if not ownedFolder:FindFirstChild(carName) then
				-- Deduct Money
				coins.Value = coins.Value - price

				-- Grant Ownership
				local receipt = Instance.new("StringValue")
				receipt.Name = carName
				receipt.Parent = ownedFolder

				return "Success"
			else
				return "AlreadyOwned"
			end
		else
			return "TooPoor"
		end
	elseif action == "Spawn" then
		-- CHECK IF THEY OWN IT
		if ownedFolder:FindFirstChild(carName) then
			-- Find the car in Storage
			local carTemplate = ServerStorage:FindFirstChild(carName)
			if carTemplate then
				-- Delete their old car if they have one
				for _, obj in pairs(game.Workspace:GetChildren()) do
					if obj.Name == carName and obj:GetAttribute("Owner") == player.Name then
						obj:Destroy()
					end
				end

				-- Spawn new car
				local newCar = carTemplate:Clone()
				newCar:SetAttribute("Owner", player.Name) -- Tag it
				newCar.Parent = game.Workspace

				-- Teleport car to player
				local char = player.Character
				if char then
					-- Move car 5 studs in front of player
					newCar:SetPrimaryPartCFrame(char.PrimaryPart.CFrame * CFrame.new(0, 5, -10))
				end

				return "Spawned"
			end
		else
			return "NotOwned"
		end
	end
end
