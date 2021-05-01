----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"
local PlayerCharacter = Load "Utility.PlayerCharacter"
local SharedStats = Load "Stats.SharedStats"
local SharedWaterContainer = Load "Tools.WaterContainer.SharedWaterContainer"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local remoteFillAttempt = Load "Tools.WaterContainer.FillAttempt"
local remoteWetAttempt = Load "Tools.WaterContainer.WetAttempt"
local remoteDrinkAttempt = Load "Tools.WaterContainer.DrinkAttempt"

local itemsBin = Load "Items"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function OnFillAttempt(player, tool, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or DataAccessor.Get(equippedTool, "Tool.Class") ~= "WaterContainer" or tool ~= equippedTool then
		return
	end
	
	if SharedWaterContainer.CanFill(player, tool, part, pointOnPart) then
		local amount = DataAccessor.Get(part, "Edible.Portions")
		local missing = DataAccessor.Get(tool, "Tool.MaximumAmount") - DataAccessor.Get(tool, "Tool.StoredAmount")
		local removed = math.min(missing, amount)
		
		DataAccessor.Increment(part, "Edible.Portions", -removed)
		
		if removed == amount and not DataAccessor.Get(part, "Edible.LeaveOnDepletion") then
			part:Destroy()
		end
		
		DataAccessor.Increment(tool, "Tool.StoredAmount", removed)
		tool.Water.Transparency = DataAccessor.Get(tool, "Tool.StoredAmount") > 0 and 0.5 or 1
	end
end

local function OnWetAttempt(player, tool, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or DataAccessor.Get(equippedTool, "Tool.Class") ~= "WaterContainer" or tool ~= equippedTool then
		return
	end
	
	if SharedWaterContainer.CanWet(player, tool, part, pointOnPart) then
		local wetsTo = DataAccessor.Get(part, "WetsTo")
		local onFire = DataAccessor.Get(part, "OnFire")
		local flammable = DataAccessor.Get(part, "Flammable")
		
		if wetsTo ~= nil then
			local clone = itemsBin:FindFirstChild(wetsTo):Clone()
			clone.Parent = part.Parent
			part:Destroy()
			clone.CFrame = part.CFrame
			clone:MakeJoints()
		elseif onFire then
			part:FindFirstChild("FireScript"):Destroy()
			part:FindFirstChild("BurningLightEffect"):Destroy()
			part:FindFirstChild("BurningFireEffect"):Destroy()
			part.BrickColor = DataAccessor.Get(part, "OriginalColor")
			DataAccessor.Set(part, "OnFire", false)
		elseif flammable then
			DataAccessor.Set(part, "Flammable", false)
		end
		
		DataAccessor.Increment(tool, "Tool.StoredAmount", -1)
		tool.Water.Transparency = DataAccessor.Get(tool, "Tool.StoredAmount") > 0 and 0.5 or 1
	end
end

local function OnDrinkAttempt(player, tool)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or DataAccessor.Get(equippedTool, "Tool.Class") ~= "WaterContainer" or tool ~= equippedTool then
		return
	end
	
	if DataAccessor.Get(tool, "Tool.StoredAmount") > 0 then
		DataAccessor.Increment(tool, "Tool.StoredAmount", -1)
		tool.Water.Transparency = DataAccessor.Get(tool, "Tool.StoredAmount") > 0 and 0.5 or 1
		SharedStats.Increment(player, "Thirst", 10)
	end
end

----------------------------------------
----- Server Water Container -----------
----------------------------------------
remoteDrinkAttempt.OnServerEvent:connect(OnDrinkAttempt)
remoteFillAttempt.OnServerEvent:connect(OnFillAttempt)
remoteWetAttempt.OnServerEvent:connect(OnWetAttempt)