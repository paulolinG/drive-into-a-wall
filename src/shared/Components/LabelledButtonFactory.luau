local LabelledButtonFactory = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local labelledButtonTemplate = templates:WaitForChild("LabelledButton")

function LabelledButtonFactory.create(
	name: string,
	text: string,
	position: UDim2,
	imageId: string,
	color: Color3,
	textColor: Color3,
	borderColor: Color3,
	iconBackgroundColor: Color3,
	onClick: () -> ()
)
	local container = labelledButtonTemplate:Clone()
	container.Name = name
	container.Position = position
	container.BackgroundColor3 = color
	container.UIStroke.Color = borderColor
	container.Icon.UIStroke.Color = borderColor
	container.TextContainer.TextLabel.Text = text
	container.TextContainer.TextLabel.TextColor3 = textColor
	container.Icon.BackgroundColor3 = iconBackgroundColor

	if imageId ~= "" then
		container.Icon.Image = imageId
	end

	if onClick then
		container.MouseButton1Click:Connect(onClick)
	end

	local proxy = setmetatable({
		Instance = container, -- Reference to the real button
	}, {
		__index = function(t, key)
			if key == "Text" then
				return container.TextLabel.Text
			end
			return container[key] -- Fallback to the button properties
		end,
		__newindex = function(t, key, value)
			if key == "Text" then
				container.TextLabel.Text = value
			else
				container[key] = value
			end
		end,
	})

	return proxy
end

return LabelledButtonFactory
