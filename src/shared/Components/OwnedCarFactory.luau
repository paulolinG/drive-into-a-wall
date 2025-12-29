local OwnedCar = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local OwnedCarTemplate = Templates:WaitForChild("OwnedCarTemplate")

function OwnedCar.create(name: string, imageid: string, imageBackgroundColor: Color3, textColor: Color3)
	local container = OwnedCarTemplate:Clone()
	container.TextLabel.Text = name
	container.TextLabel.TextColor3 = textColor
	container.ImageLabel.Image = imageid
	container.ImageLabel.BackgroundColor3 = imageBackgroundColor
	
	return container
end

return OwnedCar
