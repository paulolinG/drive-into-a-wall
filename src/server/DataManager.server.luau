local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- This creates the "Save File". Change the name inside quotes to reset everyone's data.
local myDataStore = DataStoreService:GetDataStore("JeepTycoon_Data_v1")

-- [[ 1. LOAD DATA WHEN PLAYER JOINS ]] --
Players.PlayerAdded:Connect(function(player)

	-- Create Leaderstats Folder (Stores the visible stats)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Create Coins
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Parent = leaderstats

	-- Load Saved Data
	local playerKey = "Player_" .. player.UserId
	local savedData = nil

	local success, errorMessage = pcall(function()
		savedData = myDataStore:GetAsync(playerKey)
	end)

	if success then
		if savedData then
			print("✅ Data Loaded for " .. player.Name)
			coins.Value = savedData
		else
			print("🆕 New player! Starting with 0 Coins.")
			coins.Value = 0 -- Starting Money
		end
	else
		warn("❌ Failed to load data: " .. errorMessage)
	end

	-- [[ CREATE THE COIN GUI ]] --
	-- We create the UI here so it automatically links to the new money value
	player.CharacterAdded:Connect(function()
		local existingGui = player.PlayerGui:FindFirstChild("CoinHud")
		if existingGui then existingGui:Destroy() end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "CoinHud"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = player.PlayerGui

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 200, 0, 60)
		frame.Position = UDim2.new(0, 20, 1, -80)
		frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		frame.BorderSizePixel = 0
		frame.Parent = screenGui

		local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = frame

		local title = Instance.new("TextLabel")
		title.Text = "COINS"; title.Size = UDim2.new(1, 0, 0.4, 0); title.BackgroundTransparency = 1
		title.TextColor3 = Color3.fromRGB(255, 200, 50); title.Font = Enum.Font.FredokaOne; title.TextSize = 18; title.Parent = frame

		local amount = Instance.new("TextLabel")
		amount.Text = tostring(coins.Value) -- Set initial text
		amount.Size = UDim2.new(1, 0, 0.6, 0); amount.Position = UDim2.new(0, 0, 0.4, 0); amount.BackgroundTransparency = 1
		amount.TextColor3 = Color3.fromRGB(255, 255, 255); amount.Font = Enum.Font.FredokaOne; amount.TextSize = 28; amount.Parent = frame

		-- Update UI when money changes
		coins.Changed:Connect(function(newVal)
			amount.Text = tostring(newVal)
		end)
	end)
end)

-- [[ 2. SAVE DATA WHEN PLAYER LEAVES ]] --
local function savePlayerData(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			local playerKey = "Player_" .. player.UserId

			local success, errorMessage = pcall(function()
				myDataStore:SetAsync(playerKey, coins.Value)
			end)

			if success then
				print("💾 Data Saved for " .. player.Name)
			else
				warn("❌ Failed to save data: " .. errorMessage)
			end
		end
	end
end

Players.PlayerRemoving:Connect(function(player)
	savePlayerData(player)
end)

-- [[ 3. SAVE EVERYONE ON SERVER SHUTDOWN ]] --
-- This is critical for Roblox Studio, otherwise data won't save when you press "Stop"
game:BindToClose(function()
	for _, player in pairs(Players:GetPlayers()) do
		savePlayerData(player)
	end
end)