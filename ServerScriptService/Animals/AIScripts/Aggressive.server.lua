local ai = require(game.ServerScriptService.Animals.SharedAI).new(script.Parent)
ai.Disposition = ai.Dispositions.Aggressive

local last = tick()

while wait(0.25) do
	local current = tick()
	local delta = current - last
	ai:Step(delta)
	last = current
end