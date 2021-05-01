local MIN_SPEED = 10
local MAX_SPEED = 1000

local Load = require(game:GetService("ReplicatedStorage"):WaitForChild("Load"))
local RankChecker = Load "Commands.RankChecker"
local PlayerMatcher = Load "Commands.PlayerMatcher"
local CommandAdder = Load "Commands.CommandAdder"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local ChatSettings = Load("ClientChatModules.ChatSettings", game:GetService("Chat"))

local errorExtraData = {ChatColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)}
local successExtraData = {ChatColor = ChatSettings.AdminSuccessTextColor}

local function Run(ChatService, Logs)
	local panels = {}
	
	local function StartPanels(character, color)
		local panelCount = 3
		local panelParts = {}
		
		for i = 1, panelCount do
			local panel = Instance.new("Part")
			panel.FormFactor = Enum.FormFactor.Custom
			panel.Size = Vector3.new(2.2, 3.8, 0.6)
			panel.BrickColor = color
			panel.Transparency = 0.375
			panel.Material = Enum.Material.Neon
			panel.CanCollide = false
			panel.Locked = true
			
			local light = Instance.new("SurfaceLight")
			light.Range = 24
			light.Angle = 30
			light.Face = Enum.NormalId.Front
			light.Color = color.Color
			light.Parent = panel
			light.Brightness = 5
			
			local weld = Instance.new("Weld", panel)
			weld.Part0 = character:FindFirstChild("HumanoidRootPart")
			weld.Part1 = panel
			weld.C1 = CFrame.new(0, 0, 3)
			table.insert(panelParts, { Panel = panel; Rotation = i * (360 / panelCount); Weld=weld; })
		end
		
		panels[character] = panelParts
		
		spawn(function()
			while wait(0) and panels[character] == panelParts and character.Parent == workspace do
				local r = tick() % 360 * 32.5
				for _, p in ipairs(panelParts) do
					p.Panel.Parent = character
					p.Weld.Parent = p.Panel
					p.Panel.Weld.C0 = CFrame.new(0, math.sin((tick() + p.Rotation) * 3) / 4, 0) * CFrame.Angles(0, math.rad(p.Rotation + r), 0)
				end
			end
			
			for _, p in ipairs(panelParts) do
				p.Panel:Destroy()
				p.Weld:Destroy()
			end
		end)
	end
	
	local function StopPanels(character)
		panels[character] = nil
	end
	
	local function HandlePanels(channelName, speaker, parts)
		local color = BrickColor.new(table.concat(parts, " "))
		local character = speaker:GetPlayer().Character
		
		if panels[character] == nil then
			StartPanels(character, color)
			speaker:SendSystemMessage("Panels enabled; color: "..color.Name, channelName, successExtraData)
		else
			StopPanels(character)
			
			if #parts > 0 then
				StartPanels(character, color)
				speaker:SendSystemMessage("Panels enabled; color: "..color.Name, channelName, successExtraData)
			else
				speaker:SendSystemMessage("Panels disabled", channelName, successExtraData)
			end
		end
	end
	
	CommandAdder.AddCommand(ChatService, {
		Name = "panels";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = HandlePanels;
	})
	
	CommandAdder.AddCommand(ChatService, {
		Name = "chatcolor";
		MinimumRank = RankChecker.MODERATOR_RANK;
		Execute = function(channelName, speaker, parts)
			if #parts > 0 then
				local color = BrickColor.new(table.concat(parts, " "))
				speaker:SendSystemMessage(("Chat color set to %s."):format(color.Name), channelName, successExtraData)
				speaker:SetExtraData("ChatColor", color.Color)
			else
				speaker:SendSystemMessage("Cleared custom chat color.", channelName, successExtraData)
				speaker:SetExtraData("ChatColor", nil)
			end
		end;
	})
end

return Run
