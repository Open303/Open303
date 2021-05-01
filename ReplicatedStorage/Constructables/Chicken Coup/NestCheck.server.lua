wait(1)

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

script.Parent.ChildRemoved:connect(function(child)
	if child.Name ~= "Nest" then return end
	script.Parent:Remove()
end)

local Coop = script.Parent

local item = game.ReplicatedStorage.Items:FindFirstChild("Egg"):Clone()
local gen = Coop:WaitForChild('Nest')

local Foragables = Coop:WaitForChild("Foragables")

while wait(math.random(3,9) * 20) do
	if not Foragables:FindFirstChild("Egg") then
		local new = item:clone()
		new.CFrame = gen.CFrame - Vector3.new(0,1,0)
		new.Parent = Foragables
		DataAccessor.Set(new, "DenyGather", false)

	end
end