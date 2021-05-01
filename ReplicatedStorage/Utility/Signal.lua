local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		Object = Instance.new("BindableEvent");
		Arguments = {};
	}, Signal)
end

function Signal:Fire(...)
	self.Arguments = {...}
	self.Object:Fire()
end

function Signal:Connect(...)
	local connections = {}
	
	for i = 1, select("#", ...) do
		local listener = select(i, ...)
		
		if type(listener) ~= "function" then
			error("Argument #"..i.." to Signal:Connect is not a function!")
		end
		
		local connection = self.Object.Event:connect(function()
			listener(unpack(self.Arguments))
		end)
		
		table.insert(connections, connection)
	end
	
	return unpack(connections)
end

function Signal:Wait()
	self.Object.Event:wait()
	return unpack(self.Arguments)
end

Signal.connect = Signal.Connect
Signal.wait = Signal.Wait

return Signal