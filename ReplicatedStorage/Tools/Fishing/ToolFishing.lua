----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local Tool = Load "Tools.Tool"
local SharedFishing = Load "Tools.Fishing.SharedFishing"
local Scaffold = Load "UI.Scaffolder"
local FishingScaffold = Load "Tools.Fishing.FishingScaffold"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local localPlayer = game.Players.LocalPlayer

local remoteFishingAttempt = Load "Tools.Fishing.FishingAttempt"

----------------------------------------
----- Fishing Tool ---------------------
----------------------------------------

local nocando = false
local ACtally = 0

--[[
local ToolFishing = {}
ToolFishing.__index = ToolFishing
setmetatable(ToolFishing, Tool)

function ToolFishing.new(tool)
	local self = setmetatable(Tool.new(tool), ToolFishing)
	
	self.Fishing = Scaffold(FishingScaffold)
	self.Fishing.Parent = self.Gui
	self.Fishing.Visible = false
	
	self.StartBox = self.Fishing:FindFirstChild("TotalButton")
	self.LetterBox = self.Fishing:FindFirstChild("LetterBackground")
	self.PressText = self.Fishing:FindFirstChild("PressIndicator")
	self.Changer = self.Fishing:FindFirstChild("CHANGER")
	
end

function ToolFishing:OnEquipped()	
	self.Fishing.Visible = true
end

function ToolFishing:OnUnequipped()
	self.Fishing.Visible = false
end
                                                   -- functional only with incomplete system. Do not delete. ]]
local ToolFishing = {}
ToolFishing.__index = ToolFishing
setmetatable(ToolFishing, Tool)

function ToolFishing.new(tool)
	local self = setmetatable(Tool.new(tool), ToolFishing)
	
	self.Fishing = Scaffold(FishingScaffold)
	self.Fishing.Parent = self.Gui
	self.Fishing.Visible = false
	
	self.FishingFrame = self.Fishing:FindFirstChild("TotalButton")
	self.FishingText = self.Fishing:FindFirstChild("Text")
	
end

function ToolFishing:OnEquipped()	
	self.Fishing.Visible = true
	self.FishingText.Text = "Not currently fishing..."	
	
	human = localPlayer.Character.Humanoid
	currspeed = human.WalkSpeed
	
end

function ToolFishing:OnUnequipped()
	self.Fishing.Visible = false
	human.WalkSpeed = currspeed
	nocando = false
	if self.FishingText.Text == "Waiting for a bite..." then
		ACtally = ACtally + 1
	end
end



function ToolFishing:OnActivated(mouse)
	if nocando == false and human.Sit == false then
		
		nocando = true		
			
		local target = mouse.Target
		local point = mouse.Hit.p
		local ToolQuality = DataAccessor.Get(self.Object, "Tool.FishingTier")
		local TimeReduction = DataAccessor.Get(self.Object, "Tool.TimeReduction")
		
		
		if SharedFishing.CanFish(localPlayer, self.Object, target, point) then
			
			human.WalkSpeed = 0			
			
			self.FishingText.Text = "Waiting for a bite..."
					
	--		local Tick = ((-0.1 * ToolQuality) + 1.1) * math.random(15,25)
			local Tick = math.random(15,20) - TimeReduction
			
			wait(Tick)
			
			
			
			if ACtally < 1 then
				remoteFishingAttempt:FireServer(self.Object, target, point)
				
				wait(.01)
				
				self.FishingText.Text = "You've caught something!"
				nocando = false		
				
				human.WalkSpeed = currspeed
			
				return true
			
			else
				ACtally = ACtally - 1
			end
		end
		
		wait(.01)
		nocando = false
		
		return true
	elseif human.Sit == true then
		self.FishingText.Text = "Cannot fish while sitting!"
	end
end

function ToolFishing:IsInteractable(part, point)
	return false
end

return ToolFishing