-- [[ UI FOR TELEPORTING TO TRACK ]] --

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local components = ReplicatedStorage:WaitForChild("Components")
local GuiParts = ReplicatedStorage:WaitForChild("Gui")
local PlayerMenu = require(GuiParts:WaitForChild("PlayerMenu"))

local TracksContainerFactory = require(components:WaitForChild("TrackListFactory"))
local TrackEntryFactory = require(components:WaitForChild("TrackEntryFactory"))
local LabelledButtonFactory = require(components:WaitForChild("LabelledButtonFactory"))

local Events = ReplicatedStorage:WaitForChild("Events")
local TeleportToTrackEvent = Events:WaitForChild("TeleportToTrackEvent")

local Config = ReplicatedStorage:WaitForChild("Config")
local TrackConfig = require(Config:WaitForChild("TrackConfig"))

local MiscModules = ReplicatedStorage:WaitForChild("Modules")
local ColorPalette = require(MiscModules:WaitForChild("ColorPalette"))

local gui = playerGui:WaitForChild("ShopGui")

-- Get the player menu instance and insert tab content for tracks
local menu = PlayerMenu.getInstance()

local trackListTrackColor = ColorPalette.HotPink
local trackListScrollColor = ColorPalette.ElectricPurple
local trackList = TracksContainerFactory.create(trackListTrackColor, trackListScrollColor)
trackList.Instance.Parent = menu.TabContent

local tracksBtnName = "TracksButton"
local tracksBtnTitle = "TRACKS"
local tracksBtnImageId = ""
local tracksBtnPosition = UDim2.new(0, 20, 0.5, 0)
local tracksBtnColor = ColorPalette.DeepSpace
local tracksBtnTextColor = ColorPalette.PureWhite
local tracksBtnBorderColor = ColorPalette.PureWhite
local tracksBtnIconColor = ColorPalette.PureWhite
local tracksBtn = LabelledButtonFactory.create(
	tracksBtnName,
	tracksBtnTitle,
	tracksBtnPosition,
	tracksBtnImageId,
	tracksBtnColor,
	tracksBtnTextColor,
	tracksBtnBorderColor,
	tracksBtnIconColor,
	function()
		menu.Open()
		menu.CurrentTab = "TRACKS"
		menu.TRACKS()
	end
)
tracksBtn.Instance.Parent = gui

for _, track in ipairs(TrackConfig.Config) do
	local trackName = track.Name
	local trackImageId = ""
	local trackTextColor = ColorPalette.PureWhite
	local trackBorderColor = ColorPalette.GetRandomNeon()
	local trackIconColor = ColorPalette.SlateGray

	local function teleportToTrack()
		print("CALLED TELEPORT with trackName " .. trackName)
		TeleportToTrackEvent:FireServer(trackName)
	end

	local trackEntry = TrackEntryFactory.create(
		trackName,
		trackImageId,
		trackTextColor,
		trackBorderColor,
		trackIconColor,
		teleportToTrack
	)
	trackEntry.Parent = trackList.ListContainer
end
