
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


-----------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local notifyplayer = Load "HolidayItems.NotifyPlayer"

----------------

local function GetRandomValue(Table)
	return Table[math.random(#Table)]
end

local GiftList = ReplicatedStorage.Items:GetChildren()

local GiftTemplates = ReplicatedStorage["HolidayItems"]:WaitForChild("Giftboxes"):GetChildren()

local function GetGiftAndFormatName()
	local Gift = GetRandomValue(GiftList)
	
	return Gift
end

local function CreateGiftbox(namestring)
	local Giftbox = GetRandomValue(GiftTemplates):Clone()
	
	local owner = game.Players:FindFirstChild(namestring)

	Instance.new("ClickDetector", Giftbox).MouseClick:connect(function(Player)
		if Giftbox.Name ~= "CLAIMED" then
		
		
			local Gift = GetGiftAndFormatName()
			Giftbox.Name = "CLAIMED"
			
			if Player.Name == namestring then
				if Gift:IsA("BasePart") then
					local uID = Player.UserId	
					Gift:Clone().Parent = ReplicatedStorage.StarterTools.Inventory.Inventories:FindFirstChild(""..uID.."")
				else
					Gift:Clone().Parent = Player.Backpack
					
				end
				Giftbox:destroy()
				notifyplayer:FireClient(Player, "You've recieved a "..Gift.Name.." from the gift!")
			
			else
				if Gift:IsA("BasePart") then
					local uID = Player.UserId
					local oID = owner.UserId		
					Gift:Clone().Parent = ReplicatedStorage.StarterTools.Inventory.Inventories:FindFirstChild(""..uID.."")
					Gift:Clone().Parent = ReplicatedStorage.StarterTools.Inventory.Inventories:FindFirstChild(""..oID.."")
				else
					Gift:Clone().Parent = Player.Backpack	
					Gift:Clone().Parent = owner.Backpack
				end
				
				Giftbox:destroy()
				notifyplayer:FireClient(Player, "You've recieved a "..Gift.Name.." from the gift!")
				notifyplayer:FireClient(owner, "For sharing a gift, you've recieved a "..Gift.Name.." too!")
				
			end
		
		end
		
	end)

	return Giftbox
end


Players.PlayerAdded:connect(function(Player)
	local startergift = CreateGiftbox(Player.Name)
	startergift.Parent = ReplicatedStorage.StarterTools.Inventory.Inventories:FindFirstChild(""..Player.UserId.."")
end)

while true do
	wait(math.random(5,9)*30)
	local Trees = {}
	for i,v in pairs(workspace.Constructables:GetChildren()) do
		if v.Name == 'Holiday Tree' and not v:FindFirstChild("Gift") and v:FindFirstChild("Bulb") --[[verify tree is intact]] then
			table.insert(Trees, v)
		end
	end

	if #Trees > 0 then
		
		
		local Tree = GetRandomValue(Trees)
		
		local owneroftree = Tree.Data.Owner.Value
		local Giftbox = CreateGiftbox(owneroftree.Name)
		Giftbox.CFrame = Tree.Stump.CFrame * CFrame.new(0,-Tree.Stump.Size.Y/2,0) * CFrame.new(2.5,Giftbox.Size.Y/2,0)
		Giftbox.Parent = Tree
		
		
		print("Gift delivered to one of "..owneroftree.Name.."'s tree")
		
		
		
		notifyplayer:FireClient(owneroftree, "One of your trees has recieved a new gift!")
		
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name ~= owneroftree.Name then
				notifyplayer:FireClient(v, "A new gift has appeared under a tree!")
			end
		end
		
	end
end