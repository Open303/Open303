----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Create = Load "Create"
local Bar = Load "UI.Elements.Bar"
local UDim4 = Load "UI.UDim4"
local Colors = Load "UI.Colors"
local FunctionRunner = Load "Animation.FunctionRunner"
local PlayerCharacter = Load "Utility.PlayerCharacter"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local toolGuiTemplate = Load "Tools.ToolGui"

local humanoid = PlayerCharacter.WaitForCurrentHumanoid(localPlayer)
----------------------------------------
----- Tool -----------------------------
----------------------------------------


local Tool = {}
Tool.__index = Tool

function Tool.new(object)
	local self = setmetatable({}, Tool)
	self.Object = object
	self.Gui = Create "ScreenGui" {
		Name = "ToolGui-"..object.Name;
		Parent = playerGui;
	}
	self.EquipTime = 1
	self.Selection = Create "SelectionBox" {
		Name = "ToolSelection";
		Parent = playerGui;
		LineThickness = 0.05;
		Transparency = 0.25;
	}
	
	local cooldownBar = Bar.new()
	cooldownBar.Parent = self.Gui
	cooldownBar.BackgroundColor3 = Colors.LightGray
	cooldownBar.BarColor3 = Colors.Blue
	cooldownBar.Size = UDim4.new(0.05, 0, 0.015, 0)
	cooldownBar.Visible = false
	
	local cooldownRunner = FunctionRunner.new(function(alpha)
		cooldownBar.Percent = 1 - alpha
	end, 1)
	
	local equipped = false
	
	local function Cooldown(duration)
		self.CoolingDown = true
		cooldownRunner:Stop()
		cooldownRunner.Duration = duration
		cooldownRunner:Run()
		self.CoolingDown = false
	end
	
	local function UpdatePreview(mouseTarget, mouseHit)
		if not self.CoolingDown and mouseTarget ~= nil and self:IsInteractable(mouseTarget, mouseHit) then
			self.Selection.Adornee = mouseTarget
		else
			self.Selection.Adornee = nil
		end
	end
	
	local debounce		

	object.Equipped:connect(function(mouse)
		self:OnEquipped(mouse)
		
		equipped = true
		self.Selection.Visible = true
		
		mouse.Move:connect(function()
			local x = mouse.X + 10 - cooldownBar.AbsoluteSize.X / 2
			local y = mouse.Y + 15 + cooldownBar.AbsoluteSize.Y
			cooldownBar.Position = UDim4.new(0, x, 0, y)
		end)
		
		mouse.Button1Down:connect(function()
			if not self.CoolingDown then
				local shouldCooldown, cooldownTime = self:OnActivated(mouse)
				
				cooldownTime = cooldownTime or DataAccessor.Get(object, "Tool.Cooldown")
				
				if shouldCooldown then
					self:Swing()
					Cooldown(cooldownTime)
				end
			end
		end)
		
		wait(0)
		cooldownBar.Visible = true
		local x = mouse.X + 10 - cooldownBar.AbsoluteSize.X / 2
		local y = mouse.Y + 15 + cooldownBar.AbsoluteSize.Y
		cooldownBar.Position = UDim4.new(0, x, 0, y)
		
		if not self.CoolingDown then
			Cooldown(self.EquipTime)
		end
		
		local stepConnection
		stepConnection = RunService.Stepped:connect(function()
			local success, mouseTarget, mouseHit = pcall(function() return mouse.Target, mouse.Hit.p end)
			
			if not success or not equipped then
				stepConnection:disconnect()
			else
				UpdatePreview(mouse.Target, mouse.Hit.p)
			end
		end)
	end)
	
	object.Unequipped:connect(function()
		self:OnUnequipped()
		cooldownBar.Visible = false
		self.Selection.Visible = false
		equipped = false
		wait(.1)
		cooldownBar.Visible = false
		self.Selection.Visible = false
		equipped = false
	end)
	
	game:GetService("RunService").RenderStepped:connect(function()
		self.Selection.Color3 = Color3.fromHSV(tick() % 1, 1, 1)
	end)
	
	humanoid.Died:connect(function()
		wait(.1)
		cooldownBar.Parent:Destroy()
	end)
	
	local connection
	connection = localPlayer.CharacterAdded:connect(function()
		self.Gui:Destroy()
		connection:disconnect()
	end)
	
	return self
end

function Tool:OnEquipped(mouse) end
function Tool:OnUnequipped() end
function Tool:OnActivated(mouse) end
function Tool:IsInteractable(target, point) end


function Tool:Swing()
	local animation = Instance.new("StringValue")
	animation.Name = "toolanim"
	animation.Value = "Slash"
	animation.Parent = self.Object
end

return Tool