-- [[ SHOP GUI GENERATOR ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gui = playerGui:WaitForChild("ShopGui")

local components = ReplicatedStorage:WaitForChild("Components")
local GuiParts = ReplicatedStorage:WaitForChild("Gui")
local PlayerMenu = require(GuiParts:WaitForChild("PlayerMenu"))

-- Import the components we are using to construct the GUI element
local LabelledButton = require(components:WaitForChild("LabelledButtonFactory"))
local OwnedCarListFactory = require(components:WaitForChild("OwnedCarListFactory"))
local OwnedCarFactory = require(components:WaitForChild("OwnedCarFactory"))

local Config = ReplicatedStorage:WaitForChild("Config")
local CarConfig = require(Config:WaitForChild("CarConfig"))

local MiscModules = ReplicatedStorage:WaitForChild("Modules")
local ColorPalette = require(MiscModules:WaitForChild("ColorPalette"))

local menu = PlayerMenu.getInstance()

local ownedCarsListTrackColor = ColorPalette.ElectricPurple
local ownedCarsListScrollColor = ColorPalette.HotPink
local ownedCars = OwnedCarListFactory.create(ownedCarsListTrackColor, ownedCarsListScrollColor)
ownedCars.Instance.Parent = menu.TabContent

-- Create the button to open the car shop
local carShopBtnPosition = UDim2.new(0, 20, 0.75, 0)
local carShopBtnColor = ColorPalette.LaserGreen
local carShopBtnBorderColor = ColorPalette.SolidBlack
local carShopBtnTextColor = ColorPalette.SolidBlack
local carShopBtnIconColor = ColorPalette.PureWhite
local carShopBtnIconImage = "rbxassetid://90459802847380"
local carShopBtn = LabelledButton.create(
	"ShopButton",
	"SHOP", 
	carShopBtnPosition, 
	carShopBtnIconImage, 
	carShopBtnColor, 
	carShopBtnTextColor, 
	carShopBtnBorderColor,
	carShopBtnIconColor,
	menu.Open
)
carShopBtn.Instance.Parent = gui


for _, car in ipairs(CarConfig.Config) do
	local carEntryName = car.Name
	local carEntryImageId = ""
	local carEntryTextColor = ColorPalette.PureWhite
	local carEntryIconColor = ColorPalette.SolidBlack
	local carEntry = OwnedCarFactory.create(carEntryName, carEntryImageId, carEntryIconColor, carEntryTextColor)
	carEntry.Parent = ownedCars.ListContainer
end