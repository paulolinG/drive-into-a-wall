local PlayerMenu = {}
PlayerMenu.__index = PlayerMenu

local instance = nil

function PlayerMenu.getInstance()
	if not instance then 
		-- Import all the modules required to construct the menu
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Components = ReplicatedStorage:WaitForChild("Components")
		local PlayerMenuFactory = require(Components:WaitForChild("PlayerGameInterfaceFactory"))
		local MiscModules = ReplicatedStorage:WaitForChild("Modules")
		local ColorPalette = require(MiscModules:WaitForChild("ColorPalette"))
		
		-- Attach the menu to the PlayerGui to make it visible
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		local playerGui = player:WaitForChild("PlayerGui")
		local gui = playerGui:WaitForChild("ShopGui")
		
		local menuName = "PlayerGameInterface"
		local menuTitle = "MENU"
		local menuTextColor = ColorPalette.PureWhite
		local menuBorderColor = ColorPalette.HotPink
		local menuBackgroundColor = ColorPalette.SolidBlack
		local tabNames = {"GARAGE", "TRACKS"}
		instance = PlayerMenuFactory.create(menuName, menuTitle, menuTextColor, menuBorderColor, menuBackgroundColor, tabNames)
		instance.Parent = gui
	end
	
	return instance
end

return PlayerMenu
