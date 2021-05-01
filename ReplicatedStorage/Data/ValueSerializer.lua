-- Serializes Lua values into instances.

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local TypeFinder = Load "Data.TypeFinder"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function SerializeValue(value)
	local guessType = TypeFinder.GetType(value)
	local instanceClass = TypeFinder.GetClass(value)
	
	assert(instanceClass ~= nil, "Cannot serialize a "..guessType.." type.")
	
	local object = Instance.new(instanceClass)
	object.Value = value
	
	return object
end

local function SerializeTable(inputTable)
	local container = Instance.new("Folder")
	
	for key, value in pairs(inputTable) do
		local object
		
		if type(value) == "table" then
			object = SerializeTable(value)
		else
			object = SerializeValue(value)
		end
		
		object.Name = tostring(key)
		object.Parent = container
	end
	
	return container
end

----------------------------------------
----- Main Module ----------------------
----------------------------------------
local ValueSerializer = {}

function ValueSerializer.StoreValue(object, key, value)
	local existingObject = object:FindFirstChild(key)
	
	if not existingObject or existingObject.ClassName ~= TypeFinder.GetClass(value) then
		if existingObject then 
			existingObject:Destroy()
		end
		
		local storage = SerializeValue(value)
		storage.Name = key
		storage.Parent = object
	else
		existingObject.Value = value
	end
end

function ValueSerializer.StoreTable(object, key, storingTable)
	local container = object:FindFirstChild(key)
	
	if not container or not container:IsA("Folder") then
		if container then
			container:Destroy()
		end
		
		container = SerializeTable(storingTable)
		container.Name = key
		container.Parent = object
	else
		for subKey, value in pairs(storingTable) do
			if type(value) == "table" then
				ValueSerializer.StoreTable(container, subKey, value)
			else
				ValueSerializer.StoreValue(container, subKey, value)
			end
		end
	end
end

return ValueSerializer