local RetroPalette = {}

-- [[ THE NEON VIBE ]] --
RetroPalette.NeonCyan = Color3.fromRGB(0, 255, 255)      -- Classic Cyberpunk Blue
RetroPalette.HotPink = Color3.fromRGB(255, 0, 127)      -- Vibrant Synthwave Pink
RetroPalette.ElectricPurple = Color3.fromRGB(188, 19, 254) -- Darker Neon Purple

-- [[ ARCADE ACCENTS ]] --
RetroPalette.LaserGreen = Color3.fromRGB(57, 255, 20)    -- Rad Green
RetroPalette.BlazingOrange = Color3.fromRGB(255, 110, 0) -- Retro Sunset Orange
RetroPalette.PaleLemon = Color3.fromRGB(255, 255, 157)  -- Classic 80s Yellow

-- [[ UI BACKGROUNDS & BORDERS ]] --
RetroPalette.DeepSpace = Color3.fromRGB(13, 2, 33)       -- Very Dark Purple (Great for Backgrounds)
RetroPalette.SlateGray = Color3.fromRGB(45, 45, 45)      -- Industrial Retro Gray
RetroPalette.PureWhite = Color3.fromRGB(255, 255, 255)   -- High Contrast Text
RetroPalette.SolidBlack = Color3.fromRGB(0, 0, 0)        -- Perfect for Hard Shadows

-- Helper function to get a random neon color
function RetroPalette.GetRandomNeon()
	local neons = {
		RetroPalette.NeonCyan, 
		RetroPalette.HotPink, 
		RetroPalette.ElectricPurple, 
		RetroPalette.LaserGreen
	}
	return neons[math.random(1, #neons)]
end

return RetroPalette