wait(1) -- Obscure bug

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

local Button = script.Parent
local Quarry = Button.Parent

local ClickDetector = Button:FindFirstChild("ClickDetector") or Instance.new("ClickDetector", Button)
local GeneratorPosition = Quarry:WaitForChild("CraneRope")

local Foragables = Quarry:WaitForChild("Foragables")

local Size = Quarry:GetModelSize()
local MaxSize = math.max( Size.X, Size.Y, Size.Z )
local MaxSizeVector = Vector3.new(MaxSize, MaxSize, MaxSize)

local Range = Vector3.new(7.5,7.5,7.5)

local CraftableItems = game:GetService("ReplicatedStorage"):WaitForChild("Items")

function GetQuarryableSource()
	local Center = Quarry:GetModelCFrame().p
	local Region = Region3.new(
		Center - MaxSizeVector - Range,
		Center + MaxSizeVector + Range
	)
	
	
--[[
	for _,Child in pairs(workspace:FindPartsInRegion3(Region, nil, 100)) do
		local Quarryable = Child:FindFirstChild("Quarryable")
		if Quarryable then
			return (Quarryable:IsA("StringValue") and Quarryable.Value) or "Boulder"  --temporarily disabled until feedback added
		end
	end
	
	return false
]]

	return "Boulder"

end

local Debounce = false
local Yellow, Green = BrickColor.Yellow(), BrickColor.new('Bright green')

local QuarriedItem = CraftableItems:WaitForChild(GetQuarryableSource())

ClickDetector.MouseClick:connect(function()
	if Debounce == true then
		return
	end

	Debounce = true

	if #Foragables:GetChildren() < 2 then
		
		QuarriedItem = CraftableItems:WaitForChild(GetQuarryableSource())
	

		local NewQuarriedItem = QuarriedItem:Clone()
		
		DataAccessor.Set(NewQuarriedItem, "DenyGather", false)
	
		Button.BrickColor = Yellow
	
		NewQuarriedItem.Parent = Foragables
		NewQuarriedItem.Locked = false
		NewQuarriedItem.CFrame = GeneratorPosition.CFrame
	
		wait(math.random(15,30))
	
		Button.BrickColor = Green
	end	
	
	Debounce = false
end)