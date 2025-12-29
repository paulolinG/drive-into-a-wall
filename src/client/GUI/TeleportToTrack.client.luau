-- [[ UI FOR TELEPORTING TO TRACK ]] -- 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local components = ReplicatedStorage:WaitForChild("Components")

local LabelledButton = require(components:WaitForChild("LabelledButtonFactory"))
local VerticalListContainer = require(components:WaitForChild("VerticalListContainerFactory"))
local LabelledItemWithActionFactory = require(components:WaitForChild("LabelledItemWithActionFactory"))

local Events = ReplicatedStorage:WaitForChild("Events")
local TeleportToTrackEvent = Events:WaitForChild("TeleportToTrackEvent")

local Config = ReplicatedStorage:WaitForChild("Config")
local TrackConfig = require(Config:WaitForChild("TrackConfig"))

local MiscModules = ReplicatedStorage:WaitForChild("Modules")
local ColorPalette = require(MiscModules:WaitForChild("ColorPalette"))

-- TODO: Maybe check for if server events exist??

local gui = playerGui:WaitForChild("ShopGui")
local trackTeleportTitle = "TRACKS"
local trackTeleportTitleColor = Color3.fromRGB(0, 0, 0)
local trackTeleportPrimaryColor = Color3.fromRGB(10, 10, 32)
local trackTeleportSecondaryColor = Color3.fromRGB(0, 255, 255)
local trackTeleport = VerticalListContainer.create(
	trackTeleportTitle, trackTeleportTitleColor, trackTeleportPrimaryColor, trackTeleportSecondaryColor
)
trackTeleport.Instance.Parent = gui

local tracksBtnPosition = UDim2.new(0, 20, 0.5, 0)
local tracksBtnColor = ColorPalette.DeepSpace
local tracksBtnTextColor = ColorPalette.PureWhite
local tracksBtnBorderColor = ColorPalette.PureWhite
local tracksBtnIconColor = ColorPalette.PureWhite
local tracksBtn = LabelledButton.create(
	"TracksButton",
	"TRACKS", 
	tracksBtnPosition, 
	"",
	tracksBtnColor,
	tracksBtnTextColor,
	tracksBtnBorderColor,
	tracksBtnIconColor, 
	trackTeleport.Toggle
)
tracksBtn.Instance.Parent = gui

for _, track in ipairs(TrackConfig.Config) do
	local trackName = track.Name
	local trackImageId = ""
	local trackTextColor = Color3.fromRGB(255, 255, 255)
	local trackActionText = "Teleport"
	
	local function teleportToTrack()
		print("CALLED TELEPORT with trackName " .. trackName)
		TeleportToTrackEvent:FireServer(trackName)
	end
	
	local trackEntry = LabelledItemWithActionFactory.create(
		trackName, trackImageId, trackTextColor, trackActionText, teleportToTrack
	)
	trackEntry.Instance.Parent = trackTeleport.ListContainer

end