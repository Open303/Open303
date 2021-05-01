--[[
		// FileName: PlayerListScript.lua
		// Written by: jmargh
		// Edited by: SCARFACIAL
		// Adapted to 303 v2 by: halofan987123
		// Description: Implementation of in game player list
]]

print("Running newest PlayerList")

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
if script.Parent:FindFirstChild("PlayerListContainer") then
	script.Parent:FindFirstChild("PlayerListContainer"):Destroy()
end

local GetStaffLevel, ReportPlayer;
local Api = game:GetService("ReplicatedStorage"):FindFirstChild("Api")
if Api then
	local Section = Api:FindFirstChild("Playerlist")
	GetStaffLevel = Api:FindFirstChild("GetStaffRank")
	if Section then
		ReportPlayer = Section:FindFirstChild("SendAbuseReport")
		GetContextMenu = Section:FindFirstChild("GetContextMenu")
		PlayerlistControl = Section:FindFirstChild("PlayerlistControl")
	end
end

local UserInputService = game:GetService('UserInputService')
local ContextActionService = game:GetService('ContextActionService')
local Players = game:GetService('Players')

local RbxGui = LoadLibrary("RbxGui")
local Player = Players.LocalPlayer
local PlayerStaffLevel = 0;
local PlayerListGui = script.Parent

if GetStaffLevel then
	PlayerStaffLevel = GetStaffLevel:InvokeServer(Player.Name)
end

--[[ Script Variables ]]--
local MyPlayerEntry = nil
local PlayerEntries = {}
local ScaleX = 1
local IsExpanding = false
local LastSelectedFrame = nil
local LastSelectedPlayer = nil
local IsPlayerListExpanded = false
local MinContainerSize = UDim2.new(0, 200, 0.5, 0)
local PlayerEntrySizeY = 20
local NameEntrySizeX = 165

--Report Abuse
local AbusingPlayer = nil
local AbuseReason = nil

--[[ Constants ]]--
local ENTRY_PAD = 1
local BG_TRANSPARENCY = 0.7
local TEXT_STROKE_TRANSPARENCY = 0.75
local TEXT_COLOR = Color3.new(1, 1, 243/255)
local TEXT_STROKE_COLOR = Color3.new(34/255, 34/255, 34/255)
local TWEEN_TIME = 0.15
local MAX_STR_LEN = 10
local ZINDEX = 3 -- CreateDropdownMenu does weird things. Don't set this any higher.

local ABUSES = {
	"Dragburning/Dragseating",
	"Destroying handmade work",
	"Ragging (Repeated killing)",
	"Exploiting/Cheating"
}

--[[ Images ]]--
local EXPAND_ICON = 'rbxasset://textures/ui/expandPlayerList.png'
local FRIEND_ICON = 'rbxasset://textures/ui/icon_friends_16.png'

local BRONZE_SURVIVOR_ICON = "rbxgameasset://Images/BRONZE 14"
local IRON_SURVIVOR_ICON = "rbxgameasset://Images/IRON 14"
local SILVER_SURVIVOR_ICON = "rbxgameasset://Images/SILVER 14"
local GOLD_SURVIVOR_ICON = "rbxgameasset://Images/GOLD 14"
local PLATINUM_SURVIVOR_ICON = "rbxgameasset://Images/PLATINUM 14"

local MOD_ICON = "rbxgameasset://Images/MOD 14"
local ADMIN_ICON = "rbxgameasset://Images/ADMIN 14"

local NINJA_ICON = "rbxassetid://225342411"
local WIZARD_ICON = "rbxassetid://202738289"

--[[ Helper Functions ]]--
local function clamp(value, min, max)
	if value < min then
		value = min
	elseif value > max then
		value = max
	end
	
	return value
end

local function getFriendStatus(selectedPlayer)
	if selectedPlayer == Player then
		return Enum.FriendStatus.NotFriend
	else
		if Player:IsFriendsWith(selectedPlayer.userId) then
			return Enum.FriendStatus.Friend
		else
			return Enum.FriendStatus.NotFriend
		end
	end
end

local function getFriendStatusIcon(friendStatus)
	if friendStatus == Enum.FriendStatus.Friend then
		return FRIEND_ICON
	end
	return nil
end

local function getrankIcon(player, rank)
	-- Apparently GetRankInGroup throws a tantrum under some conditions.
	if not rank then
		local success, resultOrError = pcall(function() return player:GetRankInGroup(2915350) end)
		
		if success then
			rank = resultOrError
		else
			rank = 0
		end
	end
	
	if rank == 0 and player.Name ~= "Player1" and player.Name ~= "Player" then -- Not in fanclub! :(
		return nil
	elseif rank == 95 then
		return BRONZE_SURVIVOR_ICON, "Bronze Survivor"
	elseif rank == 96 then
		return IRON_SURVIVOR_ICON, "Iron Survivor"
	elseif rank == 98 or player.Name == "Player2" then
		return SILVER_SURVIVOR_ICON, "Silver Survivor"
	elseif rank == 99 or player.Name == "Player1" or player.Name == "Player" then
		return GOLD_SURVIVOR_ICON, "Gold Survivor"
	elseif rank == 100 then
		return PLATINUM_SURVIVOR_ICON, "Platinum Survivor"
	elseif rank == 251 then
		return MOD_ICON, "Moderator"
	elseif rank == 252 or rank == 253 or rank == 254 or rank == 255 then
		return ADMIN_ICON, "Administrator"
	else
		print("Unknown rank:", rank)
	end
end

local function sortPlayerEntries(a, b)
	if a.IsPrimary == b.IsPrimary then
		return a.Player.Name:upper() < b.Player.Name:upper()
	end
	if not a.IsPrimary then return false end
	if not b.IsPrimary then return true end
	return a.IsPrimary < b.IsPrimary
end

-- Start of Gui Creation
local Container = Instance.new('Frame')
Container.Name = "PlayerListContainer"
Container.Position = UDim2.new(1, -202, 0, 2)
Container.Size = MinContainerSize
Container.BackgroundTransparency = 1
Container.Visible = false
Container.Parent = PlayerListGui
Container.ZIndex = ZINDEX

-- Header
local Header = Instance.new('Frame')
Header.Name = "Header"
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = BG_TRANSPARENCY
Header.BackgroundColor3 = Color3.new()
Header.BorderSizePixel = 0
Header.Active = true
Header.ClipsDescendants = true
Header.Parent = Container
Header.ZIndex = ZINDEX

	local HeaderName = Instance.new('TextLabel')
	HeaderName.Name = "HeaderName"
	HeaderName.Size = UDim2.new(1, 0, 0.5, 0)
	HeaderName.Position = UDim2.new(-0.02, 0, 0.245, 0)
	HeaderName.BackgroundTransparency = 1
	HeaderName.Font = Enum.Font.SourceSansBold
	HeaderName.FontSize = Enum.FontSize.Size18
	HeaderName.TextColor3 = TEXT_COLOR
	HeaderName.TextStrokeTransparency = TEXT_STROKE_TRANSPARENCY
	HeaderName.TextStrokeColor3 = TEXT_STROKE_COLOR
	HeaderName.TextXAlignment = Enum.TextXAlignment.Right
	HeaderName.Text = Player.Name
	HeaderName.Parent = Header
	HeaderName.ZIndex = ZINDEX

-- Scrolling Frame
local ScrollList = Instance.new('ScrollingFrame')
ScrollList.Name = "ScrollList"
ScrollList.Size = UDim2.new(1, -1, 0, 0)
ScrollList.Position = UDim2.new(0, 0, 0.1, 1)
ScrollList.BackgroundTransparency = 1
ScrollList.BackgroundColor3 = Color3.new()
ScrollList.BorderSizePixel = 0
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)	-- NOTE: Look into if x needs to be set to anything
ScrollList.ScrollBarThickness = 6
ScrollList.BottomImage = 'rbxasset://textures/ui/scroll-bottom.png'
ScrollList.MidImage = 'rbxasset://textures/ui/scroll-middle.png'
ScrollList.TopImage = 'rbxasset://textures/ui/scroll-top.png'
ScrollList.Parent = Container
ScrollList.ZIndex = ZINDEX

-- Expand Frame
local ExpandFrame = Instance.new('Frame')
ExpandFrame.Name = "ExpandFrame"
ExpandFrame.Size = UDim2.new(1, 0, 0, 22)
ExpandFrame.Position = UDim2.new(0, 0, 0, 0)
ExpandFrame.BackgroundTransparency = 1
ExpandFrame.Active = true
ExpandFrame.Parent = Container
ExpandFrame.ZIndex = ZINDEX

	local ExpandImage = Instance.new('ImageLabel')
	ExpandImage.Name = "ExpandImage"
	ExpandImage.Size = UDim2.new(0, 27, 0, ExpandFrame.Size.Y.Offset/2)
	ExpandImage.Position = UDim2.new(0.5, -ExpandImage.Size.X.Offset/2, 0, 0)
	ExpandImage.BackgroundTransparency = 1
	ExpandImage.Image = EXPAND_ICON
	ExpandImage.Parent = ExpandFrame
	ExpandImage.ZIndex = ZINDEX
	
-- Context Menu Popup
local PopupFrame = nil
local PopupClipFrame = Instance.new('Frame')
PopupClipFrame.Name = "PopupClipFrame"
PopupClipFrame.Size = UDim2.new(0, 150, 1, 0)
PopupClipFrame.Position = UDim2.new(0, -151, 0, 2)
PopupClipFrame.BackgroundTransparency = 1
PopupClipFrame.ClipsDescendants = true
PopupClipFrame.Parent = Container
PopupClipFrame.ZIndex = ZINDEX

-- Report Abuse Gui
local ReportAbuseShield = Instance.new('TextButton')
ReportAbuseShield.Name = "ReportAbuseShield"
ReportAbuseShield.Size = UDim2.new(1, 0, 1, 0)
ReportAbuseShield.Position = UDim2.new(0, 0, 0, 0)
ReportAbuseShield.BackgroundColor3 = Color3.new(51/255, 51/255, 51/255)
ReportAbuseShield.BackgroundTransparency = 0.4
ReportAbuseShield.ZIndex = 1
ReportAbuseShield.Text = ""
ReportAbuseShield.AutoButtonColor = false
ReportAbuseShield.ZIndex = ZINDEX

	local ReportAbuseFrame = Instance.new('Frame')
	ReportAbuseFrame.Name = "ReportAbuseFrame"
	ReportAbuseFrame.Size = UDim2.new(0, 480, 0, 320)
	ReportAbuseFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
	ReportAbuseFrame.BackgroundTransparency = 0.7
	ReportAbuseFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	ReportAbuseFrame.Style = Enum.FrameStyle.DropShadow
	ReportAbuseFrame.Parent = ReportAbuseShield
	ReportAbuseFrame.ZIndex = ZINDEX
	
		local ReportAbuseDescription = Instance.new('TextLabel')
		ReportAbuseDescription.Name = "ReportAbuseDescription"
		ReportAbuseDescription.Text = "This will send a report to the Survival 303 staff. If a player is breaking Roblox rules, please report them from the main menu."
		ReportAbuseDescription.Size = UDim2.new(1, -20, 0, 40)
		ReportAbuseDescription.Position = UDim2.new(0, 10, 0, 10)
		ReportAbuseDescription.BackgroundTransparency = 1
		ReportAbuseDescription.Font = Enum.Font.SourceSans
		ReportAbuseDescription.FontSize = Enum.FontSize.Size18
		ReportAbuseDescription.TextColor3 = Color3.new(1, 1, 1)
		ReportAbuseDescription.TextWrap = true
		ReportAbuseDescription.TextXAlignment = Enum.TextXAlignment.Left
		ReportAbuseDescription.TextYAlignment = Enum.TextYAlignment.Top
		ReportAbuseDescription.Parent = ReportAbuseFrame
		ReportAbuseDescription.ZIndex = ZINDEX
		
		local ReportPlayerLabel = Instance.new('TextLabel')
		ReportPlayerLabel.Name = "ReportPlayerLabel"
		ReportPlayerLabel.Text = "Player Reporting:"
		ReportPlayerLabel.Size = UDim2.new(0.4, 0, 0, 36)
		ReportPlayerLabel.Position = UDim2.new(0.025, 20, 0, 80)
		ReportPlayerLabel.BackgroundTransparency = 1
		ReportPlayerLabel.Font = Enum.Font.SourceSans
		ReportPlayerLabel.FontSize = Enum.FontSize.Size18
		ReportPlayerLabel.TextColor3 = Color3.new(1, 1, 1)
		ReportPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
		ReportPlayerLabel.Parent = ReportAbuseFrame
		ReportPlayerLabel.ZIndex = ZINDEX
		
		local ReportPlayerName = Instance.new('TextLabel')
		ReportPlayerName.Name = "ReportPlayerName"
		ReportPlayerName.Text = "jmargh"
		ReportPlayerName.Size = UDim2.new(0.95, 0, 0, 36)
		ReportPlayerName.Position = UDim2.new(0.025, 0, 0, 80)
		ReportPlayerName.BackgroundTransparency = 1
		ReportPlayerName.Font = Enum.Font.SourceSans
		ReportPlayerName.FontSize = Enum.FontSize.Size18
		ReportPlayerName.TextColor3 = Color3.new(1, 1, 1)
		ReportPlayerName.TextXAlignment = Enum.TextXAlignment.Right
		ReportPlayerName.Parent = ReportAbuseFrame
		ReportPlayerName.ZIndex = ZINDEX
		
		local ReportReasonLabel = Instance.new('TextLabel')
		ReportReasonLabel.Name = "ReportReasonLabel"
		ReportReasonLabel.Text = "Type of Abuse:"
		ReportReasonLabel.Size = UDim2.new(0.4, 0, 0, 36)
		ReportReasonLabel.Position = UDim2.new(0.025, 20, 0, 119)
		ReportReasonLabel.BackgroundTransparency = 1
		ReportReasonLabel.Font = Enum.Font.SourceSans
		ReportReasonLabel.FontSize = Enum.FontSize.Size18
		ReportReasonLabel.TextColor3 = Color3.new(1, 1, 1)
		ReportReasonLabel.TextXAlignment = Enum.TextXAlignment.Left
		ReportReasonLabel.Parent = ReportAbuseFrame
		ReportReasonLabel.ZIndex = ZINDEX
		
		local ReportDescriptionLabel = Instance.new('TextLabel')
		ReportDescriptionLabel.Name = "ReportDescriptionLabel"
		ReportDescriptionLabel.Text = "Short Description: (optional)"
		ReportDescriptionLabel.Size = UDim2.new(0.95, 0, 0, 36)
		ReportDescriptionLabel.Position = UDim2.new(0.025, 0, 0, 165)
		ReportDescriptionLabel.BackgroundTransparency = 1
		ReportDescriptionLabel.Font = Enum.Font.SourceSans
		ReportDescriptionLabel.FontSize = Enum.FontSize.Size18
		ReportDescriptionLabel.TextColor3 = Color3.new(1, 1, 1)
		ReportDescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
		ReportDescriptionLabel.Parent = ReportAbuseFrame
		ReportDescriptionLabel.ZIndex = ZINDEX
		
		local ReportSubmitButton = Instance.new('TextButton')
		ReportSubmitButton.Name = "ReportSubmitButton"
		ReportSubmitButton.Text = "Submit Report"
		ReportSubmitButton.Size = UDim2.new(0.35, 0, 0, 40)
		ReportSubmitButton.Position = UDim2.new(0.1, 0, 1, -50)
		ReportSubmitButton.Font = Enum.Font.SourceSans
		ReportSubmitButton.FontSize = Enum.FontSize.Size18
		ReportSubmitButton.TextColor3 = Color3.new(163/255, 162/255, 165/255)
		ReportSubmitButton.Active = false
		ReportSubmitButton.AutoButtonColor = true
		ReportSubmitButton.Modal = true
		ReportSubmitButton.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
		ReportSubmitButton.Parent = ReportAbuseFrame
		ReportSubmitButton.ZIndex = ZINDEX
		
		local ReportCanelButton = Instance.new('TextButton')
		ReportCanelButton.Name = "ReportCanelButton"
		ReportCanelButton.Text = "Cancel"
		ReportCanelButton.Size = UDim2.new(0.35, 0, 0, 40)
		ReportCanelButton.Position = UDim2.new(0.55, 0, 1, -50)
		ReportCanelButton.Font = Enum.Font.SourceSans
		ReportCanelButton.FontSize = Enum.FontSize.Size18
		ReportCanelButton.TextColor3 = Color3.new(1, 1, 1)
		ReportCanelButton.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
		ReportCanelButton.Parent = ReportAbuseFrame
		ReportCanelButton.ZIndex = ZINDEX
		
		local AbuseDropDown, updateAbuseSelection = RbxGui.CreateDropDownMenu(ABUSES,
			function(abuseText)
				AbuseReason = 0
				for i,v in pairs(ABUSES) do
					if abuseText == v then
						AbuseReason = i
						break
					end
				end
				if AbuseReason and AbusingPlayer then
					ReportSubmitButton.Active = true
					ReportSubmitButton.TextColor3 = Color3.new(1, 1, 1)
				end
			end, false, true, ZINDEX)
		AbuseDropDown.Name = "AbuseDropDown"
		AbuseDropDown.Size = UDim2.new(0.55, 0, 0, 32)
		AbuseDropDown.Position = UDim2.new(0.425, 0, 0, 121)
		AbuseDropDown.Parent = ReportAbuseFrame
		AbuseDropDown.ZIndex = ZINDEX

		local ReportDescriptionTextFrame = Instance.new('Frame')
		ReportDescriptionTextFrame.Name = "ReportDescriptionTextFrame"
		ReportDescriptionTextFrame.Size = UDim2.new(0.95, 0, 1, -250)
		ReportDescriptionTextFrame.Position = UDim2.new(0.025, 0, 0, 195)
		ReportDescriptionTextFrame.BackgroundColor3 = Color3.new(206/255, 206/255, 206/255)
		ReportDescriptionTextFrame.BorderSizePixel = 0
		ReportDescriptionTextFrame.Parent = ReportAbuseFrame
		ReportDescriptionTextFrame.ZIndex = ZINDEX
		
			local ReportDescriptionBox = Instance.new('TextBox')
			ReportDescriptionBox.Name = "ReportDescriptionBox"
			ReportDescriptionBox.Text = ""
			ReportDescriptionBox.Size = UDim2.new(1, -6, 1, -6)
			ReportDescriptionBox.Position = UDim2.new(0, 3, 0, 3)
			ReportDescriptionBox.Font = Enum.Font.SourceSans
			ReportDescriptionBox.FontSize = Enum.FontSize.Size18
			ReportDescriptionBox.TextColor3 = Color3.new(0, 0, 0)
			ReportDescriptionBox.BackgroundColor3 = Color3.new(206/255, 206/255, 206/255)
			ReportDescriptionBox.BorderColor3 = Color3.new(206/255, 206/255, 206/255)
			ReportDescriptionBox.TextXAlignment = Enum.TextXAlignment.Left
			ReportDescriptionBox.TextYAlignment = Enum.TextYAlignment.Top
			ReportDescriptionBox.TextWrap = true
			ReportDescriptionBox.ClearTextOnFocus = false
			ReportDescriptionBox.Parent = ReportDescriptionTextFrame
			ReportDescriptionBox.ZIndex = ZINDEX
			
-- Report Confirm Gui
local ReportConfirmFrame = Instance.new('Frame')
ReportConfirmFrame.Name = "ReportConfirmFrame"
ReportConfirmFrame.Size = UDim2.new(0, 400, 0, 160)
ReportConfirmFrame.Position = UDim2.new(0.5, -200, 0.5, -80)
ReportConfirmFrame.BackgroundTransparency = 0.7
ReportConfirmFrame.BackgroundColor3 = Color3.new(0, 0, 0)
ReportConfirmFrame.Style = Enum.FrameStyle.DropShadow
ReportConfirmFrame.ZIndex = ZINDEX

	local ReportConfirmHeader = Instance.new('TextLabel')
	ReportConfirmHeader.Name = "ReportConfirmHeader"
	ReportConfirmHeader.Size = UDim2.new(0, 0, 0, 0)
	ReportConfirmHeader.Position = UDim2.new(0.5, 0, 0, 14)
	ReportConfirmHeader.BackgroundTransparency = 1
	ReportConfirmHeader.Text = "Thank You For Your Report"
	ReportConfirmHeader.Font = Enum.Font.SourceSans
	ReportConfirmHeader.FontSize = Enum.FontSize.Size36
	ReportConfirmHeader.TextColor3 = Color3.new(1, 1, 1)
	ReportConfirmHeader.Parent = ReportConfirmFrame
	ReportConfirmHeader.ZIndex = ZINDEX
	
	local ReportConfirmText = Instance.new('TextLabel')
	ReportConfirmText.Name = "ReportConfirmText"
	ReportConfirmText.Text = "Your report has successfully been sent to the Survival 303 staff."
	ReportConfirmText.Size = UDim2.new(1, -20, 0, 40)
	ReportConfirmText.Position = UDim2.new(0, 10, 0, 46)
	ReportConfirmText.BackgroundTransparency = 1
	ReportConfirmText.Font = Enum.Font.SourceSans
	ReportConfirmText.FontSize = Enum.FontSize.Size18
	ReportConfirmText.TextColor3 = Color3.new(1, 1, 1)
	ReportConfirmText.TextWrap = true
	ReportConfirmText.TextXAlignment = Enum.TextXAlignment.Left
	ReportConfirmText.TextYAlignment = Enum.TextYAlignment.Top
	ReportConfirmText.Parent = ReportConfirmFrame
	ReportConfirmText.ZIndex = ZINDEX
	
	local ReportConfirmButton = Instance.new('TextButton')
	ReportConfirmButton.Name = "ReportConfirmButton"
	ReportConfirmButton.Text = "OK"
	ReportConfirmButton.Size = UDim2.new(0, 162, 0, 40)
	ReportConfirmButton.Position = UDim2.new(0.5, -81, 1, -50)
	ReportConfirmButton.Font = Enum.Font.SourceSans
	ReportConfirmButton.FontSize = Enum.FontSize.Size18
	ReportConfirmButton.TextColor3 = Color3.new(1, 1, 1)
	ReportConfirmButton.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
	ReportConfirmButton.Parent = ReportConfirmFrame
	ReportConfirmButton.ZIndex = ZINDEX
	
	local function onReportConfirmPressed()
		ReportConfirmFrame.Parent = nil
		ReportAbuseShield.Parent = nil
		ReportAbuseFrame.Parent = ReportAbuseShield
	end
	ReportConfirmButton.MouseButton1Click:connect(onReportConfirmPressed)
	ReportConfirmButton.TouchTap:connect(onReportConfirmPressed)

--[[ Creation Helper Functions ]]--
local function createEntryFrame(name, sizeYOffset)
	local containerFrame = Instance.new('Frame')
	containerFrame.Name = name
	containerFrame.Position = UDim2.new(0, 0, 0, 0)
	containerFrame.Size = UDim2.new(1, 0, 0, sizeYOffset)
	containerFrame.BackgroundTransparency = 1
	containerFrame.Parent = ScrollList
	containerFrame.ZIndex = ZINDEX
	
	local nameFrame = Instance.new('Frame')
	nameFrame.Name = "BGFrame"
	nameFrame.Position = UDim2.new(0, 0, 0, 0)
	nameFrame.Size = UDim2.new(0, NameEntrySizeX * ScaleX, 0, sizeYOffset)
	nameFrame.BackgroundTransparency = BG_TRANSPARENCY
	nameFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	nameFrame.BorderSizePixel = 0
	nameFrame.ClipsDescendants = true
	nameFrame.Parent = containerFrame
	nameFrame.ZIndex = ZINDEX
	
	return containerFrame, nameFrame
end

local function createEntryNameText(name, text)
	local nameLabel = Instance.new('TextLabel')
	nameLabel.Name = name
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.SourceSans
	nameLabel.FontSize = Enum.FontSize.Size14
	nameLabel.TextColor3 = TEXT_COLOR
	nameLabel.TextStrokeTransparency = TEXT_STROKE_TRANSPARENCY
	nameLabel.TextStrokeColor3 = TEXT_STROKE_COLOR
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = text
	nameLabel.ZIndex = ZINDEX
	
	return nameLabel
end

local function createImageIcon(image, name, parent, tooltip)
	local imageLabel = Instance.new('ImageLabel')
	imageLabel.Name = name
	imageLabel.Size = UDim2.new(0, 16, 0, 16)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.BorderSizePixel = 0
	imageLabel.Parent = parent
	imageLabel.ZIndex = ZINDEX
	
	if tooltip then
		local ToolTipLabel = Instance.new("TextLabel")
		ToolTipLabel.Name = "ToolTipLabel"
		ToolTipLabel.Text = tooltip
		ToolTipLabel.BackgroundTransparency = BG_TRANSPARENCY
		ToolTipLabel.BorderSizePixel = 0
		ToolTipLabel.Visible = false
		ToolTipLabel.TextColor3 = Color3.new(1,1,1)
		ToolTipLabel.BackgroundColor3 = Color3.new(0,0,0)
		ToolTipLabel.TextStrokeTransparency = 0
		ToolTipLabel.Font = Enum.Font.SourceSansBold
		ToolTipLabel.FontSize = Enum.FontSize.Size14
		ToolTipLabel.ZIndex = 10

		imageLabel.MouseEnter:connect(function()
			ToolTipLabel.Parent = PlayerListGui
			local ToolTipSize = ToolTipLabel.TextBounds.X + 6
			local ToolTipPosition = imageLabel.AbsolutePosition
			ToolTipLabel.Size = UDim2.new(0,ToolTipSize,0,20)
			ToolTipLabel.Position = UDim2.new(0,ToolTipPosition.X - ToolTipSize/2,0,ToolTipPosition.Y - 30)
			ToolTipLabel.Visible = true
		end)
		imageLabel.MouseLeave:connect(function()
			ToolTipLabel.Parent = nil
			ToolTipLabel.Visible = false
		end)
		imageLabel.AncestryChanged:connect(function() -- In case the player leaves the game before the tooltip is gone
			ToolTipLabel.Parent = nil
			ToolTipLabel.Visible = false
		end)
	end
	
	return imageLabel
end

--[[ Resize Functions ]]--
local LastExpandPosition = ScrollList.Size.Y.Offset
local function setExpandFramePosition()
	local canvasOffset = ScrollList.AbsolutePosition.y + ScrollList.CanvasSize.Y.Offset
	local scrollListOffset = ScrollList.AbsolutePosition.y + ScrollList.AbsoluteSize.y
	local newPosition = math.min(canvasOffset, scrollListOffset)
	ExpandFrame.Position = UDim2.new(0, 0, 0, newPosition - Container.AbsolutePosition.y + 2)
end

local LastMaxScrollSize = 0
local function setScrollListSize()
	local playerSize = #PlayerEntries * PlayerEntrySizeY
	local spacing = #PlayerEntries * ENTRY_PAD
	local canvasSize = playerSize + spacing

	ScrollList.CanvasSize = UDim2.new(0, 0, 0, canvasSize)
	local newScrollListSize = math.min(canvasSize, Container.AbsoluteSize.y - Header.AbsoluteSize.y)
	if ScrollList.Size.Y.Offset == LastMaxScrollSize and not IsExpanding then
		ScrollList.Size = UDim2.new(1, 0, 0, newScrollListSize)
	end
	LastMaxScrollSize = newScrollListSize
	setExpandFramePosition()
	LastExpandPosition = ScrollList.Size.Y.Offset
end

--[[ Re-position Functions ]]--
local function setPlayerEntryPositions()
	local position = 0
	for i = 1, #PlayerEntries do
		PlayerEntries[i].Frame.Position = UDim2.new(0, 0, 0, position)
		position = position + PlayerEntrySizeY + 1
	end
end

local function setEntryPositions()
	setPlayerEntryPositions()
end

--[[ Context Menu Functions ]]--
local selectedEntryMovedCn = nil

local function hideContextMenu()
	if PopupFrame then
		PopupFrame:TweenPosition(UDim2.new(1, 1, 0, PopupFrame.Position.Y.Offset), Enum.EasingDirection.InOut,
			Enum.EasingStyle.Quad, TWEEN_TIME, true, function()
				PopupFrame:Destroy()
				PopupFrame = nil
				if selectedEntryMovedCn then
					selectedEntryMovedCn:disconnect()
					selectedEntryMovedCn = nil
				end
			end)
	end
	if LastSelectedFrame then
		for _,childFrame in pairs(LastSelectedFrame:GetChildren()) do
			if childFrame:IsA('Frame') then
				childFrame.BackgroundColor3 = Color3.new(0, 0, 0)
			end
		end
	end
	LastSelectedFrame = nil -- Bugs here
	LastSelectedPlayer = nil
	ScrollList.ScrollingEnabled = true
end

local function createPopupFrame(buttons, target)
	local frame = Instance.new('Frame')
	frame.Name = "PopupFrame"
	frame.Size = UDim2.new(1, 0, 0, (PlayerEntrySizeY * #buttons) + (#buttons - 1))
	frame.Position = UDim2.new(1, 1, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Parent = PopupClipFrame
	frame.ZIndex = ZINDEX
	
	for i,button in ipairs(buttons) do
		local btn = Instance.new('TextButton')
		btn.Name = button.Name
		btn.Size = UDim2.new(1, 0, 0, PlayerEntrySizeY)
		btn.Position = UDim2.new(0, 0, 0, PlayerEntrySizeY * (i - 1) + (i - 1))
		btn.BackgroundTransparency = BG_TRANSPARENCY
		btn.BackgroundColor3 = Color3.new(0, 0, 0)
		btn.BorderSizePixel = 0
		btn.Text = button.Text
		btn.Font = Enum.Font.SourceSans
		btn.FontSize = Enum.FontSize.Size14
		btn.TextColor3 = TEXT_COLOR
		btn.TextStrokeTransparency = TEXT_STROKE_TRANSPARENCY
		btn.TextStrokeColor3 = TEXT_STROKE_COLOR
		btn.AutoButtonColor = true
		btn.Parent = frame
		btn.ZIndex = ZINDEX
		
		if type(button.OnPress) == 'function' then
			local function Test()
				button.OnPress(target)
				hideContextMenu()
			end

			btn.MouseButton1Click:connect(Test)
			btn.TouchTap:connect(Test)
		elseif  type(button.OnPress) == 'string' then
			local FireEvent = function()
				PlayerlistControl:FireServer(button.OnPress, target)
				hideContextMenu()
			end

			btn.MouseButton1Click:connect(FireEvent)
			btn.TouchTap:connect(FireEvent)
		end
	end

	return frame
end

local function onReportButtonPressed(targetPlayer)
	if targetPlayer then
		AbusingPlayer = targetPlayer
		ReportPlayerName.Text = targetPlayer.Name
		ReportAbuseShield.Parent = PlayerListGui
	end
end

local function resetReportDialog()
	AbuseReason = nil
	AbusingPlayer = nil
	updateAbuseSelection(nil)
	ReportPlayerName.Text = ""
	ReportDescriptionBox.Text = ""
	ReportSubmitButton.Active = false
	ReportSubmitButton.TextColor3 = Color3.new(163/255, 162/255, 165/255)
end

local function onAbuseDialogCanceled()
	ReportAbuseShield.Parent = nil
	resetReportDialog()
end
ReportCanelButton.MouseButton1Click:connect(onAbuseDialogCanceled)
ReportCanelButton.TouchTap:connect(onAbuseDialogCanceled)

local function onAbuseDialogSubmit()
	if ReportSubmitButton.Active then
		if AbuseReason and AbusingPlayer then
			if ReportPlayer then
				ReportPlayer:FireServer(AbusingPlayer, AbuseReason, ReportDescriptionBox.Text)
				ReportConfirmText.Text = "Your report has successfully been sent to the Survival 303 staff."
			else
				ReportConfirmText.Text = "Error: Your report could not be sent to the game server."
			end
			resetReportDialog()
			ReportAbuseFrame.Parent = nil
			ReportConfirmFrame.Parent = ReportAbuseShield
		end
	end
end
ReportSubmitButton.MouseButton1Click:connect(onAbuseDialogSubmit)
ReportSubmitButton.TouchTap:connect(onAbuseDialogSubmit)

local function showContextMenu(selectedFrame, selectedPlayer)
	local buttons = {}
	if GetContextMenu then
		buttons = GetContextMenu:InvokeServer(selectedPlayer)
	end

	if Player.userId > 0 and selectedPlayer.userId > 0 and selectedPlayer ~= Player then
		table.insert(buttons, {
			Name = "ReportButton",
			Text = "Report Abuse",
			OnPress = onReportButtonPressed,
		})
	end

	if PopupFrame then
		PopupFrame:Destroy()
		if selectedEntryMovedCn then
			selectedEntryMovedCn:disconnect()
			selectedEntryMovedCn = nil
		end
	end

	if buttons and #buttons < 1 then
		table.insert(buttons, {
			Name = "CancelButton",
			Text = "Cancel",
			OnPress = function() end,
		})
	end

	PopupFrame = createPopupFrame(buttons, selectedPlayer)
	PopupFrame.Position = UDim2.new(1, 1, 0, selectedFrame.Position.Y.Offset - ScrollList.CanvasPosition.y + 39)
	PopupFrame:TweenPosition(UDim2.new(0, 0, 0, selectedFrame.Position.Y.Offset - ScrollList.CanvasPosition.y + 39), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, TWEEN_TIME, true)
	selectedEntryMovedCn = selectedFrame.Changed:connect(function(property)
		if property == "Position" then
			if PopupFrame then
				PopupFrame.Position = UDim2.new(0, 0, 0, selectedFrame.Position.Y.Offset - ScrollList.CanvasPosition.y + 39)
			end
		end
	end)
end

local function onEntryFrameSelected(selectedFrame, selectedPlayer)
	if LastSelectedFrame ~= selectedFrame then
		if LastSelectedFrame then
			for _,childFrame in pairs(LastSelectedFrame:GetChildren()) do
				if childFrame:IsA('Frame') then
					childFrame.BackgroundColor3 = Color3.new(0, 0, 0)
				end
			end
		end

		LastSelectedFrame = selectedFrame
		LastSelectedPlayer = selectedPlayer

		for _,childFrame in pairs(selectedFrame:GetChildren()) do
			if childFrame:IsA('Frame') then
				childFrame.BackgroundColor3 = Color3.new(0, 1, 1)
			end
		end

		ScrollList.ScrollingEnabled = false
		showContextMenu(selectedFrame, selectedPlayer)
	else
		hideContextMenu()
		ScrollList.ScrollingEnabled = true
		LastSelectedFrame = nil
		LastSelectedPlayer = nil
	end
end

local function updateLeaderstatFrames()
	if not true then return end

	for _,entry in ipairs(PlayerEntries) do
		local player = entry.Player
		local mainFrame = entry.Frame
		local offset = NameEntrySizeX * ScaleX
		
		Container.Position = IsPlayerListExpanded and UDim2.new(0.5, -offset/2, 0.15, 0) or
			UDim2.new(1, -offset - 2, 0, 2)
		Container.Size = UDim2.new(0, offset, 0.5, 0)
		local newMinContainerOffset = IsPlayerListExpanded and offset/2 or offset
		MinContainerSize = UDim2.new(0, newMinContainerOffset, 0.5, 0)
	end
end

local function createPlayerEntry(player, rank)
	local playerEntry = {}
	local name = player.Name

	local containerFrame, entryFrame = createEntryFrame(name, PlayerEntrySizeY)
	entryFrame.Active = true
	entryFrame.InputBegan:connect(function(inputObject)
		local inputType = inputObject.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
			onEntryFrameSelected(containerFrame, player)
		end
	end)

	local playerName = createEntryNameText("PlayerName", name)

	-- Icons
	local icons = {}
	local function positionElements() -- We make reference to icons
		local currentXOffset = 2;
		for index, icon in pairs(icons) do
			icon.Position = UDim2.new(0.01, currentXOffset, 0.5, -icon.Size.Y.Offset/2)
			currentXOffset = currentXOffset + icon.Size.X.Offset + 6
		end

		playerName.Size = UDim2.new(-0.01, entryFrame.Size.X.Offset - currentXOffset, 0.5, 0)
		playerName.Position = UDim2.new(0.01, currentXOffset, 0.245, 0)
	end

	local function addIcon(self, image, name, tooltip)
		if tooltip then -- playerEntry:addIcon() called
			table.insert(icons, createImageIcon(image, name, entryFrame, tooltip))
			positionElements()
		else
			table.insert(icons, createImageIcon(self, image, entryFrame, name))
		end
	end

	local function removeIcon(self, name)
		for i = #icons, 1, -1 do
			local icon = icons[i]
			if icon.Name == name then
				icon:Destroy()
				table.remove(icons, i)
			end
		end
		positionElements()
	end

	-- check fanclub rank
	local rankIconImage, rankToolTip = getrankIcon(player, rank)
	if rankIconImage then
		addIcon(rankIconImage, "RankIcon", rankToolTip)
	end

	-- check friendship
	local friendStatus = getFriendStatus(player)
	local friendshipIconImage = getFriendStatusIcon(friendStatus)
	if friendshipIconImage then
		addIcon(friendshipIconImage, "FriendshipIcon", "You are friends")
	end

	positionElements()

	playerName.Parent = entryFrame
	playerEntry.Player = player
	playerEntry.Frame = containerFrame
	playerEntry.Nametag = playerName
	playerEntry.Icons = icons
	playerEntry.AddIcon = addIcon
	playerEntry.RemoveIcon = removeIcon

	return playerEntry
end

--[[ Insert/Remove Player Functions ]]--
local function insertPlayerEntry(player, rank)
	if player:FindFirstChild("Hidden") and (player ~= Player and PlayerStaffLevel < 1) then
		return
	end

	local entry = createPlayerEntry(player, rank)
	if player == Player then
		MyPlayerEntry = entry.Frame
	end
	table.insert(PlayerEntries, entry)
	table.sort(PlayerEntries, sortPlayerEntries)
	setEntryPositions()
	updateLeaderstatFrames()
	setScrollListSize()

	return entry
end

local function removePlayerEntry(player)
	for i = 1, #PlayerEntries do
		if PlayerEntries[i].Player == player then
			PlayerEntries[i].Frame:Destroy()
			table.remove(PlayerEntries, i)
			break
		end
	end
	setEntryPositions()
	setScrollListSize()
end

local function getPlayerEntry(player)
	for i = 1, #PlayerEntries do
		if PlayerEntries[i].Player == player then
			return PlayerEntries[i]
		end
	end
end

--[[ Resize/Position Functions ]]--
local function clampCanvasPosition()
	local maxCanvasPosition = ScrollList.CanvasSize.Y.Offset - ScrollList.Size.Y.Offset
	if maxCanvasPosition >= 0 and ScrollList.CanvasPosition.y > maxCanvasPosition then
		ScrollList.CanvasPosition = Vector2.new(0, maxCanvasPosition)
	end
end

local function resizeScrollList()
	local desiredSize = Container.AbsoluteSize.y - Header.AbsoluteSize.y
	if ScrollList.Size.Y.Offset > desiredSize then
		ScrollList.Size = UDim2.new(1, 0, 0, desiredSize)
	else
		local newSize = math.min(desiredSize, LastExpandPosition)
		ScrollList.Size = UDim2.new(1, 0, 0, newSize)
	end
	ScrollList.Position = UDim2.new(0, 0, 0, Header.AbsoluteSize.y + 1)
	clampCanvasPosition()
	setExpandFramePosition()
end

local function resizeExpandedFrame(containerFrame, scale, name)
	local offset = 0
	local nameFrame = containerFrame:FindFirstChild(name)
	if nameFrame then
		nameFrame.Size = UDim2.new(0, nameFrame.Size.X.Offset * scale, 1, 0)
		nameFrame.Position = UDim2.new(0, offset, 0, 0)
		offset = offset + nameFrame.Size.X.Offset + 1
	end
end

local function expandPlayerList(endPosition, subFrameScale)
	local containerOffset = 5 * (ScaleX - 1)
	Container:TweenSizeAndPosition(
		UDim2.new(0, MinContainerSize.X.Offset * ScaleX - containerOffset, 0.5, 0),
		endPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, TWEEN_TIME, true)

	for _,entry in ipairs(PlayerEntries) do
		resizeExpandedFrame(entry.Frame, subFrameScale, 'BGFrame')
	end
end

local function resizePlayerList()
	resizeScrollList()
end

PlayerListGui.Changed:connect(function(property)
	if property == 'AbsoluteSize' then
		spawn(function()	-- must spawn because F11 delays when abs size is set
			resizePlayerList()
		end)
	end
end)

--[[ Input Connections ]]--
local ExpandInputObject = nil
local LastExpandInputPosition = nil
local ExpandOffset = nil
ExpandFrame.InputBegan:connect(function(inputObject)
	if LastSelectedFrame then return end
	local inputType = inputObject.UserInputType
	local inputState = inputObject.UserInputState
	if (inputType == Enum.UserInputType.Touch and inputState == Enum.UserInputState.Begin) or inputType == Enum.UserInputType.MouseButton1 then
		IsExpanding = true
		ExpandInputObject = inputObject
		LastExpandInputPosition = inputObject.Position.y
		ExpandOffset = inputObject.Position.y - (ScrollList.AbsolutePosition.y + ScrollList.AbsoluteSize.y)
	end
end)

UserInputService.InputChanged:connect(function(inputObject)
	if inputObject == ExpandInputObject or (ExpandInputObject and inputObject.UserInputType == Enum.UserInputType.MouseMovement) then
		local minExpand = ScrollList.AbsolutePosition.y + ExpandOffset
		local maxExpand = minExpand + LastMaxScrollSize
		local currentPosition = clamp(inputObject.Position.y, minExpand, maxExpand)
		local delta = LastExpandInputPosition - currentPosition
		local newPosition = clamp(ScrollList.Size.Y.Offset - delta, 0, Container.AbsoluteSize.y - Header.AbsoluteSize.y)
		ScrollList.Size = UDim2.new(1, 0, 0, newPosition)
		
		clampCanvasPosition()
		setExpandFramePosition()
		LastExpandInputPosition = currentPosition
	end
end)

UserInputService.InputEnded:connect(function(inputObject)
	if inputObject == ExpandInputObject then
		ExpandInputObject = nil
		LastExpandInputPosition = nil
		LastExpandPosition = ScrollList.Size.Y.Offset
		IsExpanding = false
	elseif ReportAbuseShield.Parent == PlayerListGui then
		if inputObject.KeyCode == Enum.KeyCode.Escape then
			onAbuseDialogCanceled()
		end
	end
end)

UserInputService.InputBegan:connect(function(inputObject, isProcessed)
	if isProcessed then return end
	local inputType = inputObject.UserInputType
	if (inputType == Enum.UserInputType.Touch and  inputObject.UserInputState == Enum.UserInputState.Begin) or
		inputType == Enum.UserInputType.MouseButton1 then
		if LastSelectedFrame then
			hideContextMenu()
		end
	end
end)

local function doListExpand()
	if not IsPlayerListExpanded then
		ScaleX = 2
		expandPlayerList(UDim2.new(0.5, -MinContainerSize.X.Offset, 0.15, 0), 2)
	else
		ScaleX = 1
		expandPlayerList(UDim2.new(1, -MinContainerSize.X.Offset - 2, 0, 2), 0.5)
	end
	IsPlayerListExpanded = not IsPlayerListExpanded
end

Header.InputBegan:connect(function(inputObject)
	if LastSelectedFrame then return end
	local inputType = inputObject.UserInputType
	local inputState = inputObject.UserInputState
	if inputObject == ExpandInputObject then return end
	if (inputType == Enum.UserInputType.Touch and inputState == Enum.UserInputState.Begin) or inputType == Enum.UserInputType.MouseButton1 then
		doListExpand()
	end
end)

UserInputService.InputBegan:connect(function(inputObject)
	local key = inputObject.KeyCode
	if key == Enum.KeyCode.Tab then
		doListExpand()
	end
end)

--[[ Player Add/Remove Connections ]]--
if PlayerlistControl then
	PlayerlistControl.OnClientEvent:connect(function(Evt, EventPlayer)
		if Evt == "ShowPlayer" then
			if PlayerStaffLevel > 0 then
				getPlayerEntry(EventPlayer):RemoveIcon("NinjaIcon")
			else
				insertPlayerEntry(EventPlayer)
			end
		elseif Evt == "HidePlayer" then
			if PlayerStaffLevel > 0 then
				getPlayerEntry(EventPlayer):AddIcon(NINJA_ICON, "NinjaIcon", "This unit is a flippin' Ninja.")
			else
				removePlayerEntry(EventPlayer)
			end
		end		
	end)
end

Players.ChildAdded:connect(function(child)
	if child:IsA('Player') then
		insertPlayerEntry(child)
	end
end)
for _,player in pairs(Players:GetPlayers()) do
	insertPlayerEntry(player)
end

Players.ChildRemoved:connect(function(child)
	if child:IsA('Player') then
		if LastSelectedPlayer and child == LastSelectedPlayer then
			hideContextMenu()
		end
		removePlayerEntry(child)
	end
end)

resizePlayerList()
Container.Visible = true