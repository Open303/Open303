----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local DataAccessor = Load "Data.DataAccessor"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local animalBin = workspace.Animals
local aiScripts = game.ServerScriptService.Animals.AIScripts

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function InitializeAnimal(animal)
	local aiType = DataAccessor.Get(animal, "Animal.AIDisposition")
	
	if aiType == nil or aiScripts:FindFirstChild(aiType) == nil then
		error(animal:GetFullName().." has invalid AI disposition: "..tostring(aiType))
	end
	
	local controller = aiScripts:FindFirstChild(aiType):Clone()
	controller.Parent = animal
	controller.Disabled = false
end

----------------------------------------
----- Animals --------------------------
----------------------------------------
for _, animal in ipairs(animalBin:GetChildren()) do
	InitializeAnimal(animal)
end