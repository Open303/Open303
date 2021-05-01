-- Determines storable types.

----------------------------------------
----- Constants ------------------------
----------------------------------------
local TYPE_CLASS_MAPPING = {
	["string"] = "StringValue";
	["number"] = "NumberValue";
	["boolean"] = "BoolValue";
	["Instance"] = "ObjectValue";
	["Vector3"] = "Vector3Value";
	["CFrame"] = "CFrameValue";
	["BrickColor"] = "BrickColorValue";
	["Color3"] = "Color3Value";
}

----------------------------------------
----- Modules --------------------------
----------------------------------------
local Load = require(game.ReplicatedStorage:WaitForChild("Load"))

----------------------------------------
----- Variables ------------------------
----------------------------------------
local objectCache = {}

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function Set(object, key, value)
	object[key] = value
end

local function TryAssign(value, class, property)
	property = property or "Value"
	local object
	
	if objectCache[class] then
		object = objectCache[class]
	else
		object = Instance.new(class)
		objectCache[class] = object
	end
	
	local success = pcall(Set, object, property, value)
	return success
end

local function IsVector3(value)
	return TryAssign(value, "Vector3Value")
end

local function IsColor3(value)
	return TryAssign(value, "Color3Value")
end

local function IsInstance(value)
	return TryAssign(value, "ObjectValue")
end

local function IsBrickColor(value)
	return TryAssign(value, "BrickColorValue")
end

local function IsCFrame(value)
	return TryAssign(value, "CFrameValue")
end

----------------------------------------
----- Main Module ----------------------
----------------------------------------
local TypeFinder = {}

function TypeFinder.GetType(value)
	local luaType = type(value)
	
	if luaType == "nil" then
		return "Instance"
	end
	
	if luaType ~= "userdata" then
		return luaType
	else
		if IsBrickColor(value) then
			return "BrickColor"
		elseif IsCFrame(value) then
			return "CFrame"
		elseif IsColor3(value) then
			return "Color3"
		elseif IsInstance(value) then
			return "Instance"
		elseif IsVector3(value) then
			return "Vector3"
		else
			return "userdata"
		end
	end
	
	return "unknown"
end

function TypeFinder.GetClass(value)
	local inferredType = TypeFinder.GetType(value)
	local mapping = TYPE_CLASS_MAPPING[inferredType]
	
	return mapping
end

return TypeFinder