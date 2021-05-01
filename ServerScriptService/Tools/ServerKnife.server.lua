local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local SharedInventory = Load "StarterTools.Inventory.SharedInventory"
local DataAccessor = Load "Data.DataAccessor"
local SharedKnife = Load "Tools.Knife.SharedKnife"
local PlayerCharacter = Load "Utility.PlayerCharacter"

local remoteCarveAttempt = Load "Tools.Knife.CarveAttempt"
local remoteSliceAttempt = Load "Tools.Knife.SliceAttempt"

local function OnCarveAttempt(player, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or DataAccessor.Get(equippedTool, "Tool.Class") ~= "Knife" then
		return
	end
	
	if SharedKnife.CanCarve(player, part, pointOnPart) then
		for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
			part[face.Name.."Surface"] = Enum.SurfaceType.Weld
		end
		
		DataAccessor.Set(part, "WeldWood", false)
	end
end

local function OnSliceAttempt(player, part, pointOnPart)
	local equippedTool = PlayerCharacter.GetEquippedTool(player)
	
	if equippedTool == nil or DataAccessor.Get(equippedTool, "Tool.Class") ~= "Knife" then
		return
	end
	
	if SharedKnife.CanSlice(player, part, pointOnPart) then
		local connection, wasRemoved
		connection = equippedTool.Changed:connect(function()
			if equippedTool.Parent ~= player.Character and equippedTool.Parent ~= player.Backpack then
				connection:disconnect()
				wasRemoved = true
			end
		end)
		
		local sliceResultName = DataAccessor.Get(part, "SliceResult")
		local sliceResult = game.ReplicatedStorage.Items:FindFirstChild(sliceResultName)
		local sliceTime = DataAccessor.Get(equippedTool, "Tool.SliceTime")
		local sliceCount = DataAccessor.Get(part, "Slices")
		
		part:Destroy()
		
		for i = 1, sliceCount do
			wait(sliceTime)
			
			if not wasRemoved then
				sliceResult:Clone().Parent = SharedInventory.GetPlayerInventory(player)
			else
				break
			end
		end
	end
end

remoteCarveAttempt.OnServerEvent:connect(OnCarveAttempt)
remoteSliceAttempt.OnServerEvent:connect(OnSliceAttempt)