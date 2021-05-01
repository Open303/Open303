local RunService = game:GetService("RunService")

local waitEvent = RunService:IsClient() and RunService.RenderStepped or RunService.Stepped
local unpack, tick = unpack, tick

local FunctionRunner = {}
FunctionRunner.__index = FunctionRunner

function FunctionRunner.new(func, duration)
	assert(type(func) == "function", "func must be a function")
	assert(type(duration) == "number", "duration must be a number")
	
	local self = {}
	self.Function = func
	self.Duration = duration
	
	return setmetatable(self, FunctionRunner)
end

function FunctionRunner:Stop()
	if not self.Running then
		return
	end
	
	self.Running = false
	self.StartTick = nil
	self.Function(1, unpack(self.Args))
	self.Connection:disconnect()
end

function FunctionRunner:Run(...)
	if self.Running then
		return
	end
	
	local start = tick()
	local func = self.Function
	local args = {...}
	
	self.Running = true
	self.Args = args
	func(0, ...)
	
	self.Connection = waitEvent:connect(function()
		local current = tick()
		local alpha = (current - start) / self.Duration
		func(alpha, unpack(args))
		
		if alpha >= 1 then
			self:Stop()
		end
	end)
end

function FunctionRunner:RunAsync(...)
	if self.Running then
		return
	end
	
	local args = {...}
	
	spawn(function()
		self:Run(unpack(args))
	end)
end

function FunctionRunner:Restart(...)
	if self.Running then
		self:Stop()
	end
	
	self:Run(...)
end

function FunctionRunner:RestartAsync(...)
	if self.Running then
		self:Stop()
	end
	
	self:RunAsync(...)
end

return FunctionRunner