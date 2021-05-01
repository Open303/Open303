-- By Scarfacial, will be in shipped version. Do not remove
local Players = game:GetService("Players")
local Debounce = {}

for _, Part in pairs(script.Parent:GetChildren()) do
	if Part.Name == "Lava" or "Magma" and Part:IsA("BasePart") then
		Part.Touched:connect(function(Hit)
			local Player = Players:GetPlayerFromCharacter(Hit.Parent)
			if Player and not Debounce[Player] then
				Debounce[Player] = true
				Hit.Parent:BreakJoints()
				for _,Limb in pairs(Hit.Parent:GetChildren()) do
					if Limb:IsA("BasePart") then
						Instance.new("Fire", Limb)
					end
				end
				wait(10)
				Debounce[Player] = false
			elseif not Hit.Locked or Hit.Parent.Name == "Cave-In" then
				Hit:Destroy()
			elseif Hit.Parent:IsA("Hat") or Hit.Parent:IsA("Tool") then
				Hit.Parent:Destroy()
			end
		end)
	end
end