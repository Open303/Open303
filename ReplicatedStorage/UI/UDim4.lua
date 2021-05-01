local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local Class = Load "Utility.Class"
local Lerp = Load "Utility.Lerp"

local UDim4 = {}
UDim4.ClassName = "UDim4"
UDim4.__index = Class.__index
UDim4.__newindex = Class.__newindex
setmetatable(UDim4, { __index = Class })

function UDim4.new(...)
	local args = {...}
	local self = setmetatable(Class.new(), UDim4)
	
	if #args == 8 then
		self.X = UDim2.new(args[1], args[2], args[3], args[4])
		self.Y = UDim2.new(args[5], args[6], args[7], args[8])
	elseif #args == 4 then
		self.X = UDim2.new(args[1], args[2], 0, 0)
		self.Y = UDim2.new(0, 0, args[3], args[4])
	elseif #args == 2 then
		self.X = args[1]
		self.Y = args[2]
	elseif #args == 1 then
		self.X = UDim2.new(args[1].X.Scale, args[1].X.Offset, 0, 0)
		self.Y = UDim2.new(0, 0, args[1].Y.Scale, args[1].Y.Offset)
	else
		error("UDim4.new: Invalid number of arguments ("..#args..")")
	end
	
	return self
end

function UDim4.FromAbsolute(absolute)
	return UDim4.new(UDim2.new(0, absolute.X, 0, 0), UDim2.new(0, 0, 0, absolute.Y))
end

function UDim4.FromUDim2(udim2)
	return UDim4.new(udim2)
end

function UDim4:ToAbsolute(absBounds)
	local x = self.X.X.Scale * absBounds.X + self.X.X.Offset + self.X.Y.Scale * absBounds.Y + self.X.Y.Offset
	local y = self.Y.X.Scale * absBounds.X + self.Y.X.Offset + self.Y.Y.Scale * absBounds.Y + self.Y.Y.Offset
	
	return Vector2.new(x, y)
end

function UDim4:Lerp(goal, alpha)
	return UDim4.new(
		UDim2.new(
			Lerp(self.X.X.Scale, goal.X.X.Scale, alpha), 
			Lerp(self.X.X.Offset, goal.X.X.Offset, alpha),
			Lerp(self.X.Y.Scale, goal.X.Y.Scale, alpha),
			Lerp(self.X.Y.Offset, goal.X.Y.Offset, alpha)
		),
		UDim2.new(
			Lerp(self.Y.X.Scale, goal.Y.X.Scale, alpha),
			Lerp(self.Y.X.Offset, goal.Y.X.Offset, alpha),
			Lerp(self.Y.Y.Scale, goal.Y.Y.Scale, alpha),
			Lerp(self.Y.Y.Offset, goal.Y.Y.Offset, alpha)
		)
	)
end

function UDim4:__add(other)
	return UDim4.new(self.X + other.X, self.Y + other.Y)
end

function UDim4:__sub(other)
	return UDim4.new(self.X - other.X, self.Y - other.X)
end

function UDim4:__unm()
	return UDim4.new(-self.X, -self.Y)
end

function UDim4:__tostring()
	return "{ "..tostring(self.X).." }, { "..tostring(self.Y).." }"
end

function UDim4:__eq(other)
	return self.X == other.X and self.Y == other.Y
end

return UDim4