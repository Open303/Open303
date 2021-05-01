-- Accesses data.

----------------------------------------
----- Constants ------------------------
----------------------------------------
local DATA_CONTAINER_NAME = "Data"
local PROTOTYPE_KEY_NAME = "Prototype"

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local TypeFinder = Load "Data.TypeFinder"
local String = Load "Utility.String"
local ValueSerializer = Load "Data.ValueSerializer"
local Hierarchy = Load "Utility.Hierarchy"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local prototypeBin = Load "Data.Prototypes"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function GetDataObject(object, autoCreate)
	if object.Parent == prototypeBin then
		return object
	end
	
	local container = object:FindFirstChild(DATA_CONTAINER_NAME)
	
	if not container and autoCreate then
		container = Instance.new("Folder")
		container.Name = DATA_CONTAINER_NAME
		container.Parent = object
	end
	
	return container
end

local function GetPrototype(dataObject)
	local prototypeValue = dataObject:FindFirstChild(PROTOTYPE_KEY_NAME)
	
	if prototypeValue == nil then
		return nil
	end
	
	if prototypeValue:IsA("ObjectValue") then
		return prototypeValue.Value
	elseif prototypeValue:IsA("StringValue") then
		local prototype = prototypeBin:FindFirstChild(prototypeValue.Value)
		
		if prototype == nil then
			error("DataAccessor: String prototype name "..prototypeValue.Value.." does not exist.")
		end
		
		return prototype
	end
end

local function TunnelThrough(object, key)
	local parts = String.Split(key, "%.")
	local level = object
	
	if object:FindFirstChild(key) then
		return object:FindFirstChild(key)
	end
	
	for _, part in ipairs(parts) do
		level = level:FindFirstChild(part)
		
		if not level then
			return nil
		end
	end
	
	return level
end

local function GetObject(dataObject, key)
	local current = dataObject
	
	while current do
		local object = TunnelThrough(current, key)
		
		if object then
			return object
		else
			current = GetPrototype(current)
		end
	end
	
	return nil
end

local function RepresentsTable(object)
	return #object:GetChildren() > 0 or object:IsA("Folder")
end

local function ObjectToTable(object, destinationTable)
	destinationTable = destinationTable or {}
	
	for _, child in ipairs(object:GetChildren()) do
		if RepresentsTable(child) then
			destinationTable[child.Name] = ObjectToTable(child, destinationTable[child.Name])
		else
			destinationTable[child.Name] = child.Value
		end
	end
	
	return destinationTable
end

local function GetTableValue(dataObject, key)
	local prototype = GetPrototype(dataObject)
	local original
	
	if prototype then
		original = GetTableValue(prototype, key)
	else
		original = {}
	end
	
	local targetObject = GetObject(dataObject, key)
	
	if targetObject then
		original = ObjectToTable(targetObject, original)
	end
	
	return original
end

local function Get(object, key)
	local dataObject = GetDataObject(object)
	
	if not dataObject then
		return nil
	end
	
	local targetObject = GetObject(dataObject, key)
	
	if targetObject then
		if RepresentsTable(targetObject) then
			return GetTableValue(dataObject, key)
		else
			return targetObject.Value
		end
	end
	
	return nil
end

local function Set(object, key, value)
	local dataContainer = GetDataObject(object, true)
	
	local parts = String.Split(key, "%.")
	local level = dataContainer
	
	for index, part in ipairs(parts) do
		if index == #parts then
			if type(value) == "table" then
				ValueSerializer.StoreTable(level, part, value)
			else
				ValueSerializer.StoreValue(level, part, value)
			end
		else
			local nextLevel = level:FindFirstChild(part)
			
			if not nextLevel then
				nextLevel = Instance.new("Folder")
				nextLevel.Name = part
				nextLevel.Parent = level
			end
			
			if not RepresentsTable(nextLevel) then
				warn("Key "..key.." in object "..object:GetFullName().." may not be set because it leads through a non-table value at part "..part)
				return
			end
			
			level = nextLevel
		end
	end
end

----------------------------------------
----- Main Module ----------------------
----------------------------------------
local DataAccessor = {}

DataAccessor.Get = Get
DataAccessor.Set = Set

function DataAccessor.GetStoringObject(object, key)
	local data = object:WaitForChild(DATA_CONTAINER_NAME)
	
	local parts = String.Split(key, "%.")
	local level = data
	
	for index, part in ipairs(parts) do
		level = level:WaitForChild(part)
	end
	
	return level
end

function DataAccessor.Update(object, key, updater)
	local current = Get(object, key)
	local new = updater(current)
	Set(object, key, new)
end

function DataAccessor.Increment(object, key, delta)
	DataAccessor.Update(object, key, function(current)
		return current + delta
	end)
end

function DataAccessor.GetFromAncestors(object, key, stopAt)
	stopAt = stopAt or workspace
	local level = object
	
	while true do
		local value = Get(level, key)
		
		if value ~= nil then
			return value
		else
			level = level.Parent
			
			if level == nil or level == stopAt then
				break
			end
		end
	end
	
	return nil
end

return DataAccessor