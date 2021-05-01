wait(1)

local model = script.Parent
local mainPart = model.MainPart
local firingPart = model.FiringPart
local bf = firingPart.BodyForce
local button = model.Button
local cd = button.ClickDetector
local spawn = model.Spawn

local debounce = true
local reloadTime = 10

function onClick()
	if debounce == false then return end

	debounce = false

	button.BrickColor = BrickColor.new("Bright red")

	wait(0.1)

	mainPart.Anchored = true
	bf.force = Vector3.new(0, 1000000, 0)

	wait(0.5)

	mainPart.Anchored = false
	bf.force = Vector3.new(0, 0, 0)

	button.BrickColor = BrickColor.new("Bright yellow")

	wait(reloadTime)

	button.BrickColor = BrickColor.new("Bright green")

	debounce = true
end

cd.MouseClick:connect(onClick)

button.Locked = false
wait()
button.Locked = true
