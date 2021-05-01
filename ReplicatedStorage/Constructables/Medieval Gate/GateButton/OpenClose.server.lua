wait(0.5)

local button = script.Parent
local click = button.ClickDetector
local gate = script.Parent.Parent.Gate
local gateWeld = script.Parent.Parent["Top Wall"].GateWeld
local baseOffset = gateWeld.C0

local closed = true
local inprogress = false

---------------------------

function openGate()

	inprogress = true
	
	for down = 0, gate.Size.y + 1, 0.1 do
		gateWeld.C0 = baseOffset - Vector3.new(0, down, 0)
		wait(0.1)
	end
	
	closed = false
	inprogress = false

end

function closeGate()

	inprogress = true
	
	for up = gate.Size.y + 1, 0, -0.1 do
		gateWeld.C0 = baseOffset - Vector3.new(0, up, 0)
		wait(0.1)
	end
	
	closed = true
	inprogress = false

end

function SwitchPosition()
	if inprogress == true then 
		return	
	else
		if closed == true then 
			openGate()
		elseif closed == false then
			closeGate()
		end
	end
end

click.MouseClick:connect(SwitchPosition)


