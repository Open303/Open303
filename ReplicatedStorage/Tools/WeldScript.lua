--[[
	This is a substitute for the LinkedSource "WeldScript" script.
	I've pretty much just dropped the script into a function and this module returns that function.
]]--

local function module(callingScript)
	-- Script written by SCARFACIAL
	-- 26 December 2014
	
	local CFrames = {}
	local Welds = {}
	
	local Handle = callingScript.Parent:WaitForChild("Handle")
	for i,v in pairs(callingScript.Parent:GetChildren()) do
	    if v:IsA("BasePart") and v ~= Handle then
	        CFrames[v] = Handle.CFrame:toObjectSpace(v.CFrame)
	        v.Anchored = false -- Legacy compatability
	    end
	end
	Handle.Anchored = false
	
	callingScript.Parent.Equipped:connect(function()
	    for i,v in pairs(callingScript.Parent:GetChildren()) do
	        if v:IsA("BasePart") and v ~= Handle then
	            local Weld = Instance.new("Weld", game:FindFirstChild("JointsService") or Handle)
	            Weld.Part0 = Handle
	            Weld.Part1 = v
	            Weld.C0 = CFrames[v]
	        end
	    end
	end)
	
	callingScript.Parent.Unequipped:connect(function()
	    for _, weld in pairs(Welds) do
	        weld:Destroy()
	    end
	end)
end

return module