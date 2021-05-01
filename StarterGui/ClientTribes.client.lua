----------------------------------------
----- Constants ------------------------
----------------------------------------

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"
local TribesGuiScaffold = Load "TribesMenu.TribesGuiScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local tribesGui = Instance.new("ScreenGui", playerGui)
tribesGui.Name = "TribesGui"
local tribesToggle = Scaffold({
	Scaffold = "TextButton";
	Name = "ToggleButton";
	Parent = tribesGui;
	BackgroundColor3 = Colors.Blue;
	Text = "Tribes";
	Position = UDim4.new(0.5, 10, 0, 10);
	Size = UDim4.new(0.1, 0, 0.025, 0);
})

local tribesContainer = Scaffold(TribesGuiScaffold)
tribesContainer.Parent = tribesGui

local displayzone = tribesContainer:FindOnPath("DisplayZone")
local CREATETRIBEBUTTON = tribesContainer:FindOnPath("DisplayZone.CREATE")
local INVITEMEMBERBUTTON = tribesContainer:FindOnPath("DisplayZone.INVITEMEMBER")
local LEAVETRIBEBUTTON = tribesContainer:FindOnPath("DisplayZone.LEAVETRIBE")
local TOGGLEINVITESBUTTON = tribesContainer:FindOnPath("DisplayZone.YESNO")
local CURRENTSELECTEDCOLORDISPLAY = tribesContainer:FindOnPath("DisplayZone.colordisplay")
local tribenameobject = tribesContainer:FindOnPath("DisplayZone.nameinput")
local feedbackbar = tribesContainer:FindOnPath("DisplayZone.feedbackbar")
local activetribe = tribesContainer:FindOnPath("DisplayZone.activetribe")
local activecolor = tribesContainer:FindOnPath("DisplayZone.TribeColorDisplay.currentcolor")
local memberinput = tribesContainer:FindOnPath("DisplayZone.memberinput")

local invitezone = tribesContainer:FindOnPath("InviteSector")
local ACCEPTBUTTON = tribesContainer:FindOnPath("InviteSector.ACCEPT")
local IGNOREBUTTON = tribesContainer:FindOnPath("InviteSector.IGNORE")
local UpperVariable = tribesContainer:FindOnPath("InviteSector.UpperVariable")
local LowerVariable = tribesContainer:FindOnPath("InviteSector.LowerVariable")
local hiddencolor = tribesContainer:FindOnPath("InviteSector.HIDECOL")

-- can the following be handled more eloquently? Yes, it sure can - if you're reading this, feel free to fix this mess of a script. all I can do is make things work.
local L1Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L1")
local L2Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L2")
local L3Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L3")
local L4Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L4")
local L5Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L5")
local L6Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L6")
local L7Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L7")
local L8Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L8")
local L9Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L9")
local L10Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.L10")
local R1Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R1")
local R2Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R2")
local R3Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R3")
local R4Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R4")
local R5Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R5")
local R6Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R6")
local R7Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R7")
local R8Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R8")
local R9Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R9")
local R10Button = tribesContainer:FindOnPath("DisplayZone.ColorPalletZone.R10")

local remoteCNTAttempt = Load "TribesMenu.CNTAttempt"
local remoteLTAttempt = Load "TribesMenu.LTAttempt"
local remoteIMAttempt = Load "TribesMenu.IMAttempt"
local remoteIMReturn = Load "TribesMenu.IMReturn"
local remoteTIAttempt = Load "TribesMenu.TIAttempt"
local remoteFBReturn = Load "TribesMenu.FBReturn"
local remoteFNAttempt = Load "TribesMenu.FNAttempt"
local remoteUIReturn = Load "TribesMenu.UIReturn"

--[[
local hidepos = UDim4.FromUDim2(UDim2.new(1.05, -5, 0.375, 0))
local showpos = UDim4.FromUDim2(UDim2.new(0.80, -5, 0.375, 0))

local subtractby = UDim4.FromUDim2(UDim2.new(0.01, -0.01, 0, 0))
--]]


----------------------------------------
----- Variables ------------------------
----------------------------------------
local guiOpen = false

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ToggleGui()
	guiOpen = not guiOpen
	displayzone.Visible = guiOpen
	sendmsg("")
end

function SETUPCOLORBUTTONS(certaincolorbuttonhit, textcolor)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			CURRENTSELECTEDCOLORDISPLAY.BackgroundColor3 = certaincolorbuttonhit.BackgroundColor3
			CURRENTSELECTEDCOLORDISPLAY.TextColor3 = textcolor
				
			
		end
		
	end
end



function CREATENEWTRIBE(createbutton)
	return function(input)
		local debouncemarker = false
		local text = tribenameobject.Text
	
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then	
			
			
			if debouncemarker == false then	
			
				debouncemarker = true
				if localPlayer.Neutral == true then
					if text ~= "" and text ~= "Type name here..." and text:lower() ~= "neutral" then			
						if #text <= 24 then	
							
							local symbolcheck = text:lower():match("[abcdefghijklmnopqrstuvwxyz1234567890 ]+") --will use character classes to organize this up when I get back to it eventually.
							
							
							--print (symbolcheck)		
							
							if symbolcheck ~= nil and #symbolcheck >= #text then
								if not game.Teams:FindFirstChild(""..text.."") then
									if CURRENTSELECTEDCOLORDISPLAY.BackgroundColor3 ~= Color3.fromRGB(255,255,255) then
	
										local colorrunner = BrickColor.new(CURRENTSELECTEDCOLORDISPLAY.BackgroundColor3)
										local currentteams = game.Teams:GetChildren()
										local truefalse = false
										
										for index, team in pairs(currentteams) do
											if team.TeamColor == colorrunner then
												truefalse = true
											end						
										end				
										
										if truefalse == false then
											remoteCNTAttempt:FireServer(text,CURRENTSELECTEDCOLORDISPLAY.BackgroundColor3)
											
											sendmsg("Checking that tribe name...")
											
											
											
										else sendmsg("That color is already claimed!")							
										end
									else sendmsg("You need to select a color first!")
									end	
								else sendmsg("That tribe name is already taken!")
								end
							else sendmsg("Tribe names can only be alphanumeric!")
							end
						else sendmsg("The maximum name length is 24 characters!")
						end
					else sendmsg("Your tribe needs a name!")
					end
				else sendmsg("You're already in a tribe!")
				end
				debouncemarker = false
			end
		end
	end
end

function LEAVETRIBE(leavebutton)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local leavebounce = false	
			if leavebounce == false then	
				
				leavebounce = true
				if localPlayer.Neutral == false then
					
					
					sendmsg("Leaving your current tribe...")
					wait(.1)
					remoteLTAttempt:FireServer()
							
					activetribe.Text = "NOT IN ANY TRIBE"
					activecolor.BackgroundColor3 = Color3.fromRGB(255,255,255)
					
					
							
				else sendmsg("You're not in any tribe!")
				end
				leavebounce = false
			end
		end
	end
end

function findObject(Name, ObjectList)
	if type(Name) ~= 'string' or Name:len() < 1 then
		return {}
	end

	Name = Name:lower()
	ObjectList = type(ObjectList) == 'table' and ObjectList or ObjectList:GetChildren() -- Legacy code

	local Objects = {}
	for _,v in pairs(ObjectList) do
		local CurrentName = v.Name:lower()
		if CurrentName == Name then
			return {v}
		elseif CurrentName:match( "^" .. Name ) then
			table.insert(Objects, v)
		end
	end

	return Objects
end

function findplayer(name)
	local usename = string.lower(name)
	local allPlayers = game.Players:GetPlayers()

	return findObject(usename, allPlayers)

end
					
function INVITEMEMBER(invitebutton)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if localPlayer.Neutral == false then
				
				local tname = activetribe.Text
				local legitcheck = tname:match("[#]")
				 	
				if legitcheck == nil then
					if memberinput.Text ~= "" and memberinput.Text ~= "Type player's name here..." then
						
						local playerIDname = findplayer(memberinput.Text)
						
						if playerIDname ~= nil then
							if #playerIDname < 2 then
								local IDstring = playerIDname[1]
								
								if IDstring ~= nil then
									local playerIDstring = IDstring.Name
									
									
									if localPlayer.Name ~= playerIDstring then
										remoteIMAttempt:FireServer(playerIDstring, localPlayer.TeamColor, activetribe.Text)
										
										
									else sendmsg("No, you cannot invite yourself.")
									end
								else sendmsg ("Cannot find that player!")
								end
							else sendmsg("Multiple results - be more exact!")
							end
						else sendmsg("Cannot find that player!")
						end
					else sendmsg("You must enter a name!")
					end
				else sendmsg("Illegitimate tribe name!")
				end
			else sendmsg("You are not in a tribe!")
			end
		end
	end
end

function sendmsg(text)
	feedbackbar.Text = text
end

remoteFBReturn.OnClientEvent:connect(function(message)
	feedbackbar.Text = message
end)

remoteUIReturn.OnClientEvent:connect(function(filtname, color)
	activetribe.Text = filtname
	activecolor.BackgroundColor3 = color
end)

remoteIMReturn.OnClientEvent:connect(function(sender, newcolor, newtribe)
	local inviteui = invitezone
	
	if inviteui.Visible == false then 
		--if localPlayer.Neutral == true then        --whether already-tribed players get new invites
		if TOGGLEINVITESBUTTON.Text == "YES" then
			remoteFNAttempt:FireServer(sender, "An invite has been sent!")
			
			UpperVariable.Text = [["]]..newtribe..[["]]
			LowerVariable.Text = ""..sender..""
			inviteui.Visible = true
			--[[
			inviteui.Position = hidepos
			for i = 1, 25 do
				inviteui.Position = inviteui.Position - subtractby
				wait(1/(25*2))
			end
			inviteui.Position = showpos
			--]]
		--end
		else
			remoteFNAttempt:FireServer(sender, "Player has disabled tribe invites!")
		end
	end
end)

function ACCEPT(acceptbutton)
	return function(input)
		if invitezone.Visible == true then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local tribename = UpperVariable.Text
				local tribenamesendable = string.sub(tribename, 2, (#tribename - 1))
				remoteTIAttempt:FireServer(tribenamesendable)
				invitezone.Visible = false
				activetribe.Text = tribenamesendable
				
				local refcolor = game.Teams:FindFirstChild(tribenamesendable).TeamColor
				local rgbcolor = refcolor.Color
				--activecolor.BackgroundColor3 = hiddencolor.BackgroundColor3
				activecolor.BackgroundColor3 = rgbcolor
				--invitezone.Position = hidepos
			end
		end
	end
end

function IGNORE(ignorebutton)
	return function(input)
		if invitezone.Visible == true then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				invitezone.Visible = false
				--invitezone.Position = hidepos
			end
		end
	end
end

function YESNO(thatbutton)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local yes = "YES"
			local no = "NO"
			
			if thatbutton.Text == yes then
				thatbutton.Text = no
			else
				thatbutton.Text = yes
			end
		end
	end
end
----------------------------------------
----- Buildings Menu -------------------
----------------------------------------
tribesToggle.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
		
		--print("SERVERCODE: #Filter2")  --[[for testing purposes alone]]
	end
end)

displayzone.Visible = false
invitezone.Visible = false

local PureWhite = Color3.fromRGB(255,255,255)
local PureBlack = Color3.fromRGB(0,0,0)

L1Button.InputEnded:connect(SETUPCOLORBUTTONS(L1Button, PureWhite))
L2Button.InputEnded:connect(SETUPCOLORBUTTONS(L2Button, PureWhite))
L3Button.InputEnded:connect(SETUPCOLORBUTTONS(L3Button, PureWhite))
L4Button.InputEnded:connect(SETUPCOLORBUTTONS(L4Button, PureBlack))
L5Button.InputEnded:connect(SETUPCOLORBUTTONS(L5Button, PureWhite))
L6Button.InputEnded:connect(SETUPCOLORBUTTONS(L6Button, PureWhite))
L7Button.InputEnded:connect(SETUPCOLORBUTTONS(L7Button, PureWhite))
L8Button.InputEnded:connect(SETUPCOLORBUTTONS(L8Button, PureBlack))
L9Button.InputEnded:connect(SETUPCOLORBUTTONS(L9Button, PureWhite))
L10Button.InputEnded:connect(SETUPCOLORBUTTONS(L10Button, PureWhite))

R1Button.InputEnded:connect(SETUPCOLORBUTTONS(R1Button, PureWhite))
R2Button.InputEnded:connect(SETUPCOLORBUTTONS(R2Button, PureWhite))
R3Button.InputEnded:connect(SETUPCOLORBUTTONS(R3Button, PureWhite))
R4Button.InputEnded:connect(SETUPCOLORBUTTONS(R4Button, PureBlack))
R5Button.InputEnded:connect(SETUPCOLORBUTTONS(R5Button, PureWhite))
R6Button.InputEnded:connect(SETUPCOLORBUTTONS(R6Button, PureWhite))
R7Button.InputEnded:connect(SETUPCOLORBUTTONS(R7Button, PureWhite))
R8Button.InputEnded:connect(SETUPCOLORBUTTONS(R8Button, PureBlack))
R9Button.InputEnded:connect(SETUPCOLORBUTTONS(R9Button, PureWhite))
R10Button.InputEnded:connect(SETUPCOLORBUTTONS(R10Button, PureWhite))

CREATETRIBEBUTTON.InputEnded:connect(CREATENEWTRIBE(CREATETRIBEBUTTON))
LEAVETRIBEBUTTON.InputEnded:connect(LEAVETRIBE(LEAVETRIBEBUTTON))
INVITEMEMBERBUTTON.InputEnded:connect(INVITEMEMBER(INVITEMEMBERBUTTON))
TOGGLEINVITESBUTTON.InputEnded:connect(YESNO(TOGGLEINVITESBUTTON))

ACCEPTBUTTON.InputEnded:connect(ACCEPT(ACCEPTBUTTON))
IGNOREBUTTON.InputEnded:connect(IGNORE(IGNOREBUTTON))