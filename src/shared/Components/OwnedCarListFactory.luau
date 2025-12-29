local OwnedCarList = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local OwnedCarsListTemplate = templates:WaitForChild("OwnedCarsListTemplate")

function OwnedCarList.create(trackColor: Color3, scrollBarColor: Color3)
	
	local container = OwnedCarsListTemplate:Clone()
	container.Name = "GARAGETab"
	container.ScrollTrack.UIStroke.Color = trackColor
	container.ScrollTrack.UpArrowLabel.TextColor3 = trackColor
	container.ScrollTrack.DownArrowLabel.TextColor3 = trackColor
	container.ScrollingFrame.ScrollBarImageColor3 = scrollBarColor
	
	local self = setmetatable({
		Instance = container
	}, {
		__index = function(t, key)
			if key == "ListContainer" then
				return container.Items
			end
            return container[key]
		end,
		__newindex = function(t, key, value)
			container[key] = value
		end
	})
	
	return self
	
end

return OwnedCarList
