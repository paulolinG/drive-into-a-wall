local PlayerGameInterface = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local templates = ReplicatedStorage:WaitForChild("GuiTemplates")
local PlayerGameInterfaceTemplate = templates:WaitForChild("PlayerGameInterface")
local TabTemplate = templates:WaitForChild("TabTemplate")

function PlayerGameInterface.create(
	name: string,
	title: string,
	titleColor: Color3,
	borderColor: Color3,
	backgroundColor: Color3,
	tabNames: { string }
)
	local container = PlayerGameInterfaceTemplate:Clone()

	container.Name = name
	container.Visible = false
	container.MainTitleContainer.MainTitle.Text = title
	container.MainTitleContainer.MainTitle.TextColor3 = titleColor

	-- Ensure that all visible borders are the same colour
	container.UIStroke.Color = borderColor
	container.MainTitleContainer.BottomBorder.BackgroundColor3 = borderColor
	container.MainTitleContainer.CloseButton.TextColor3 = borderColor
	container.MainTitleContainer.CloseButton.UIStroke.Color = borderColor
	container.TabsContainer.BottomBorder.BackgroundColor3 = borderColor

	local defaultTab = tabNames[1]

	local function updateTabVisuals(activeName: string)
		for _, tab in ipairs(container.TabsContainer.TabLabels:GetChildren()) do
			if tab:IsA("Frame") then
				local isActive = (tab.Name == activeName .. "Tab")
				tab.BottomBorder.BackgroundColor3 = isActive and backgroundColor or borderColor
			end
		end
		for _, tabContent in ipairs(container.TabContent:GetChildren()) do
			if tabContent:IsA("Frame") then
				local showTabContent = (tabContent.Name == activeName .. "Tab")
				tabContent.Visible = showTabContent
			end
		end
	end

	local self = setmetatable({
		Instance = container,
		CurrentTab = defaultTab,
	}, {
		__index = function(t, key)
			if key == "Open" then
				return function()
					container.Visible = true
				end
			end
			if key == "TabContent" then
				return container.TabContent
			end
			if table.find(tabNames, key) then
				return function()
					updateTabVisuals(key)
				end
			end
			return container[key]
		end,
		__newindex = function(t, key, value)
			container[key] = value
		end,
	})

	for _, tabName in ipairs(tabNames) do
		local tabContainer = TabTemplate:Clone()
		tabContainer.Name = tabName .. "Tab"
		tabContainer.TabButton.Text = tabName
		tabContainer.TabButton.TextColor3 = borderColor
		tabContainer.UIStroke.Color = borderColor
		tabContainer.BottomBorder.BackgroundColor3 = borderColor
		tabContainer.Parent = container.TabsContainer.TabLabels

		-- Update current tab state and display when new tab is clicked
		tabContainer.TabButton.MouseButton1Click:Connect(function()
			self.CurrentTab = tabName
			updateTabVisuals(tabName)
		end)
	end

	-- Configure close button functionality
	container.MainTitleContainer.CloseButton.MouseButton1Click:Connect(function()
		container.Visible = false
	end)

	updateTabVisuals(defaultTab)

	return self
end

return PlayerGameInterface
