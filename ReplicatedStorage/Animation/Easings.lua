local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin  = math.asin

local Easing = {}

function Easing.Linear(t, d)
	return t / d
end

function Easing.EaseIn(power)
	return function(t, d)
		return pow(t / d, power)
	end
end

function Easing.EaseOut(power)
	return function(t, d)
		return 1 - pow(1 - (t / d), power)
	end
end

function Easing.EaseInOut(power)
	local inFunc = Easing.EaseIn(power)
	local outFunc = Easing.EaseOut(power)
	
	return function(t, d)
		if t < d / 2 then
			return inFunc(t * 2, d) / 2
		else
			return outFunc(t * 2 - d, d) / 2
		end
	end
end

function Easing.BackIn(value)
	value = value or 1.70158
	
	return function(t, d)
		t = t / d
		return t * t * ((value + 1) * t - value)
	end
end

function Easing.BackOut(value)
	value = value or 1.70158
	
	return function(t, d)
		t = t / d - 1
		return (t * t * ((value + 1) * t + value) + 1)
	end
end

function Easing.BackInOut(value)
	local inBack = Easing.BackIn(value)
	local outBack = Easing.BackOut(value)
	
	return function(t, d)
		if t < d / 2 then
			return inBack(t * 2, d) / 2
		else
			return outBack(t * 2 - d, d) / 2 + t
		end
	end
end

return Easing