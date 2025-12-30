local WallConfig = {}

-- [[ MASTER SETTINGS ]] --
-- Change everything here!
-- Even the UI and Generator will look at this list.

WallConfig.Stats = {
	Glass = {
		Reward = 5,
		Health = 10,
		Color = BrickColor.new("Cyan"),
		Sound = "rbxassetid://144884907",
		Pitch = 1.0,
		Thick = 1.5,
		DebrisCount = 10,
		DebrisSize = 2,
		Texture = "rbxassetid://241551622", -- Shard
	},

	Wood = {
		Reward = 1000,
		Health = 15,
		Color = BrickColor.new("Cocoa"),
		Sound = "rbxassetid://138122923",
		Pitch = 1.2,
		Thick = 2.0,
		DebrisCount = 12,
		DebrisSize = 1.5,
		Texture = "rbxassetid://243943684", -- Rock/Chunk
	},

	Brick = {
		Reward = 25,
		Health = 20,
		Color = BrickColor.new("Rust"),
		Sound = "rbxassetid://138122923",
		Pitch = 0.8,
		Thick = 4.0,
		DebrisCount = 15,
		DebrisSize = 3,
		Texture = "rbxassetid://243943684",
	},

	Concrete = {
		Reward = 50,
		Health = 40,
		Color = BrickColor.new("Medium stone grey"),
		Sound = "rbxassetid://138122923",
		Pitch = 0.6,
		Thick = 6.0,
		DebrisCount = 20,
		DebrisSize = 5,
		Texture = "rbxassetid://243943684",
	},

	Neon = {
		Reward = 100,
		Health = 80,
		Color = BrickColor.new("Electric blue"),
		Sound = "rbxassetid://2863953747",
		Pitch = 1.0,
		Thick = 1.0,
		DebrisCount = 25,
		DebrisSize = 2,
		Texture = "rbxassetid://241551622",
	},
}

return WallConfig
