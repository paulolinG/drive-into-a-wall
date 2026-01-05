local TrackEntry = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local TrackEntryTemplate = Templates:WaitForChild("TrackEntry")

function TrackEntry.create(
	trackName: string,
	imageId: string,
	textColor: Color3,
	borderColor: Color3,
	iconColor: Color3,
	teleportToTrackFn: () -> {}
)
	local container = TrackEntryTemplate:Clone()
	container.Name = trackName
	container.TextContainer.TextLabel.Text = trackName
	container.Icon.Image = imageId
	container.Icon.BackgroundColor3 = iconColor
	container.TextContainer.TextLabel.TextColor3 = textColor
	container.UIStroke.Color = borderColor
	container.Icon.UIStroke.Color = borderColor
	container.MouseButton1Click:Connect(teleportToTrackFn)
	return container
end

return TrackEntry
