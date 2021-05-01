local RunService = game:GetService("RunService")

local waitEvent = RunService:IsClient() and RunService.RenderStepped or RunService.Stepped

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

function FunctionRunner:Start(...)
	if self.Running then
		return
	end
	
	local start = tick()
	self.Running = true
	self.StartTick = start
	self.Args = {...}
	
	self.Function(0, ...)
end

function FunctionRunner:Step()
	if not self.Running then
		return
	end
	
	local current = tick()
	local delta = current - self.StartTick
	local alpha = delta / self.Duration
	
	if alpha >= 1 then
		self:Stop()
	else
		self.Function(alpha, unpack(self.Args))
	end
end

function FunctionRunner:Stop()
	if not self.Running then
		return
	end
	
	self.Running = false
	self.StartTick = nil
	self.Function(1, unpack(self.Args))
end

function FunctionRunner:Run(...)
	if self.Running then
		return
	end
	
	self:Start(...)
	
	while self.Running do
		self:Step()
		waitEvent:wait()
	end
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