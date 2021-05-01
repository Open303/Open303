-- Class module.

local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Signal = Load "Utility.Signal"

----------------------------------------
----- Class ----------------------------
----------------------------------------
local Class = {}
Class.ClassName = "CustomClass"

function Class.new()
	local self = setmetatable({}, Class)
	self._childArray = {}
	self.ChildAdded = Signal.new()
	self.ChildRemoved = Signal.new()
	
	return self
end

function Class:__index(key)
	local class = getmetatable(self)
	local getter = class["get_"..key]
	
	if getter then
		return getter(self)
	else
		return class[key]
	end
end

function Class:__newindex(key, value)
	local class = getmetatable(self)
	local getter = class["get_"..key]
	
	if getter then
		local setter = class["set_"..key]
		
		if setter then
			setter(self, value)
		else
			error("Cannot set read-only property "..key)
		end
	else
		if class[key] then
			warn("Class key "..key.." is being occluded.")
			print(debug.traceback())
		end
		
		rawset(self, key, value)
	end
end

function Class:IsA(name)
	if name == "CustomClass" then
		return true
	end
	
	local current = getmetatable(self)
	
	while true do
		if current == nil then
			return false
		elseif current.ClassName == name then
			return true
		elseif current == Class then
			return false
		end
		
		current = getmetatable(current).__index
	end
end

function Class:GetChildren()
	return self._childArray
end

function Class:FindFirstChild(name, recursive)
	for _, child in ipairs(self._childArray) do
		if child.Name == name then
			return child
		elseif recursive then
			local result = child:FindFirstChild(name, recursive)
			if result ~= nil then
				return result
			end
		end
	end
	
	return nil
end

function Class:FindOnPath(path)
	local level = self
	
	for chunk in path:gmatch("[^%.]+") do
		level = level:FindFirstChild(chunk)
		
		if level == nil then
			return nil
		end
	end
	
	return level
end

function Class:get_Parent()
	return self._parent
end

function Class:set_Parent(value)
	local current = self._parent
	
	if current ~= nil and current:IsA("CustomClass") then
		current:_removeChild(self)
	end
	
	if value ~= nil and value:IsA("CustomClass") then
		value:_addChild(self)
	end
	
	self._parent = value
	self:_parentChangeCallback(value)
end

function Class:_parentChangeCallback() end

function Class:_removeChild(object)
	for i = #self._childArray, 1, -1 do
		if self._childArray[i] == object then
			table.remove(self._childArray, i)
		end
	end
end

function Class:_addChild(object)
	table.insert(self._childArray, object)
end

return Class