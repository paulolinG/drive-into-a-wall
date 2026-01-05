local TrackList = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local TrackListTemplate = Templates:WaitForChild("TracksContainer")

function TrackList.create(trackColor: Color3, scrollColor: Color3)
	local container = TrackListTemplate:Clone()
	container.Name = "TRACKSTab"
	container.Size = UDim2.fromScale(1, 1)

	-- Set up the color for the scroll track bar
	container.ScrollTrack.UIStroke.Color = trackColor
	container.ScrollTrack.DownArrowLabel.TextColor3 = trackColor
	container.ScrollTrack.UpArrowLabel.TextColor3 = trackColor

	container.ScrollingFrame.ScrollBarImageColor3 = scrollColor

	local self = setmetatable({
		Instance = container,
	}, {
		__index = function(t, key)
			if key == "ListContainer" then
				return container.Items
			end
			return container[key]
		end,
		__newindex = function(t, key, value)
			container[key] = value
		end,
	})

	return self
end

return TrackList
