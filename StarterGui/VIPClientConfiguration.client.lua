wait(.1)
local ownerId = game.VIPServerOwnerId
--print("ownerId: "..ownerId)



local Load = require(game.ReplicatedStorage:WaitForChild("Load"))
local connec = Load "VIPMenu.Check"
local dest = Load "VIPMenu.Destroy"





---------------------------------------




----------------------------------------
----- Constants ------------------------
----------------------------------------

----------------------------------------
----- Modules --------------------------
----------------------------------------

local Create = Load "Create"
local DataAccessor = Load "Data.DataAccessor"
local Scaffold = Load "UI.Scaffolder"
local Colors = Load "UI.Colors"
local UDim4 = Load "UI.UDim4"
local ConfigScaffold = Load "VIPMenu.VIPScaffoldConfiguration"

----------------------------------------
----- Objects --------------------------
----------------------------------------
local RunService = game:GetService("RunService")

local localPlayer = game.Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local VIPGui = Instance.new("ScreenGui", playerGui)
VIPGui.Name = "VIPConfig"
local VIPToggle = Scaffold({
	Scaffold = "TextButton";
	Name = "ToggleButton";
	Parent = VIPGui;
	BackgroundColor3 = Colors.Red;
	Text = "Server Settings";
	Position = UDim4.new(0.7, 20, 0, 10);
	Size = UDim4.new(0.1, 0, 0.025, 0);
	Visible = false;
})

local VIPContainer = Scaffold(ConfigScaffold)
VIPContainer.Parent = VIPGui

connec.OnClientEvent:connect(function()
	VIPToggle.Visible = true
end)

dest.OnClientEvent:connect(function()
	VIPToggle:Destroy()
	VIPGui:Destroy()
	script:Destroy()
end)



local Button1A = VIPContainer:FindOnPath("Setting1back.Button1")
local Button1B = VIPContainer:FindOnPath("Setting1back.Button2")
local Button1C = VIPContainer:FindOnPath("Setting1back.Button3")
local Button1D = VIPContainer:FindOnPath("Setting1back.Button4")
local Button1Save = VIPContainer:FindOnPath("Setting1back.Save")

local Button2A = VIPContainer:FindOnPath("Setting2back.Button1")
local Button2B = VIPContainer:FindOnPath("Setting2back.Button2")
local Button2C = VIPContainer:FindOnPath("Setting2back.Button3")
local Button2D = VIPContainer:FindOnPath("Setting2back.Button4")
local Button2Save = VIPContainer:FindOnPath("Setting2back.Save")

local Button3A = VIPContainer:FindOnPath("Setting3back.Button1")
local Button3B = VIPContainer:FindOnPath("Setting3back.Button2")
local Button3C = VIPContainer:FindOnPath("Setting3back.Button3")
local Button3D = VIPContainer:FindOnPath("Setting3back.Button4")
local Button3Save = VIPContainer:FindOnPath("Setting3back.Save")

local Button4A = VIPContainer:FindOnPath("Setting4back.Button1")
local Button4B = VIPContainer:FindOnPath("Setting4back.Button2")
local Button4C = VIPContainer:FindOnPath("Setting4back.Button3")
local Button4D = VIPContainer:FindOnPath("Setting4back.Button4")
local Button4Save = VIPContainer:FindOnPath("Setting4back.Save")

local Button5A = VIPContainer:FindOnPath("Setting5back.Button1")
local Button5B = VIPContainer:FindOnPath("Setting5back.Button2")
local Button5C = VIPContainer:FindOnPath("Setting5back.Button3")
local Button5D = VIPContainer:FindOnPath("Setting5back.Button4")
local Button5Save = VIPContainer:FindOnPath("Setting5back.Save")

local onc = Colors.TribesSandYellow
local offc = Colors.ElementsGrey
local savec = Colors.ElementsLightLightRed


healthmultiplier = 1
statsmultiplier = 1
daynightmultiplier = 1
regenmultiplier = 1
growthmultiplier = 1

origs = game.ReplicatedStorage.ConfigValues.StatMultiplier
origr = game.ReplicatedStorage.ConfigValues.RegenMultiplier
origd = game.ReplicatedStorage.ConfigValues.DayNightMultiplier
origh = game.ReplicatedStorage.ConfigValues.HealthMultiplier
origg = game.ReplicatedStorage.ConfigValues.GrowthMultiplier

local mathno = (2/3)

function onJoinCheck(which,ba,bb,bc,bd,uno,dos,tres)
	if which == "stats" then
		if uno == origs.Value then
			ba.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif dos == origs.Value then
			bc.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif tres == origs.Value then
			bd.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		end
	elseif which == "regen" then
		if uno == origr.Value then
			ba.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif dos == origr.Value then
			bc.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif tres == origr.Value then
			bd.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		end
	elseif which == "daynight" then
		if uno == origd.Value then
			ba.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif dos == origd.Value then
			bc.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif tres == origd.Value then
			bd.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		end
	elseif which == "health" then
		if uno == origh.Value then
			ba.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif dos == origh.Value then
			bc.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif tres == origh.Value then
			bd.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		end
	elseif which == "growth" then
		if uno == origg.Value then
			ba.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif dos == origg.Value then
			bc.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		elseif tres == origg.Value then
			bd.BackgroundColor3 = onc
			bb.BackgroundColor3 = offc
		end
	end
end



if origs.Value ~= 1 then
	onJoinCheck("stats",Button1A,Button1B,Button1C,Button1D,0.5,1.5,2)
	--print("sfail")
end
if origr.Value ~= 1 then
	onJoinCheck("regen",Button2A,Button2B,Button2C,Button2D,1.5,mathno,0.5)
	--print("rfail")
end
if origd.Value ~= 1 then
	onJoinCheck("daynight",Button3A,Button3B,Button3C,Button3D,0,1.5,2.25)
	--print("dfail")
end
if origh.Value ~= 1 then
	onJoinCheck("health",Button4A,Button4B,Button4C,Button4D,0.75,1.25,1.5)
	--print("hfail")
end
if origg.Value ~= 1 then
	onJoinCheck("growth",Button5A,Button5B,Button5C,Button5D,1.5,1,0.75,0.5)
end
----------------------------------------
----- Variables ------------------------
----------------------------------------
local guiOpen = false




local apply = Load "VIPMenu.Apply"

----------------------------------------
----- Functions ------------------------
----------------------------------------
local function ToggleGui()
	guiOpen = not guiOpen
	VIPContainer.Visible = guiOpen
end

function CLICKED(multi,amt,on,off1,off2,off3,sav)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local comp
			
			if multi == "stats" then
				statsmultiplier = amt
				--print ("statsmult "..statsmultiplier)
				--print ("amt "..amt)
				comp = origs.Value
			elseif multi == "regen" then
				regenmultiplier = amt
				comp = origr.Value
			elseif multi == "daynight" then
				daynightmultiplier = amt
				comp = origd.Value
			elseif multi == "health" then
				healthmultiplier = amt
				comp = origh.Value
			elseif multi == "growth" then
				growthmultiplier = amt
				comp = origg.Value
			end
			if on.BackgroundColor3 ~= onc then
				on.BackgroundColor3 = onc
				off1.BackgroundColor3 = offc
				off2.BackgroundColor3 = offc
				off3.BackgroundColor3 = offc
				
				if comp ~= amt then
					sav.BackgroundColor3 = savec
				else
					sav.BackgroundColor3 = offc
				end

				
				--print(""..multi.." set to "..amt.."")
			end
			--print("t1 "..amt)
		end
		--print("t2 "..amt)
	end
end


function APPLIED(multip,NOUSE,no1,n02,no3,no4,app)
	return function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if app.BackgroundColor3 == savec then
				
				app.BackgroundColor3 = offc
				
				local multiplier = 1				
				
				if multip == "stats" then
					multiplier = statsmultiplier
				
				elseif multip == "regen" then
					multiplier = regenmultiplier
				elseif multip == "daynight" then
					multiplier = daynightmultiplier
				elseif multip == "health" then
					multiplier = healthmultiplier
				elseif multip == "growth" then
					multiplier = growthmultiplier
				end
				
				--print(multip.." applied as "..multiplier)
				apply:FireServer(multip,multiplier)
			end
		end
	end
end
----------------------------------------
----- Buildings Menu -------------------
----------------------------------------
VIPToggle.InputEnded:connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		ToggleGui()
		
		
	--	print("SERVERCODE: #Filter2")  --[[for testing purposes alone]]
	end
end)



Button1A.InputEnded:connect(CLICKED("stats",0.5,Button1A,Button1B,Button1C,Button1D,Button1Save))
Button1B.InputEnded:connect(CLICKED("stats",1,Button1B,Button1A,Button1C,Button1D,Button1Save))
Button1C.InputEnded:connect(CLICKED("stats",1.5,Button1C,Button1B,Button1A,Button1D,Button1Save))
Button1D.InputEnded:connect(CLICKED("stats",2,Button1D,Button1B,Button1C,Button1A,Button1Save))

Button2A.InputEnded:connect(CLICKED("regen",1.5,Button2A,Button2B,Button2C,Button2D,Button2Save))
Button2B.InputEnded:connect(CLICKED("regen",1,Button2B,Button2A,Button2C,Button2D,Button2Save))
Button2C.InputEnded:connect(CLICKED("regen",mathno,Button2C,Button2B,Button2A,Button2D,Button2Save))
Button2D.InputEnded:connect(CLICKED("regen",0.5,Button2D,Button2B,Button2C,Button2A,Button2Save))

Button3A.InputEnded:connect(CLICKED("daynight",0,Button3A,Button3B,Button3C,Button3D,Button3Save))
Button3B.InputEnded:connect(CLICKED("daynight",1,Button3B,Button3A,Button3C,Button3D,Button3Save))
Button3C.InputEnded:connect(CLICKED("daynight",1.5,Button3C,Button3B,Button3A,Button3D,Button3Save))
Button3D.InputEnded:connect(CLICKED("daynight",2.250,Button3D,Button3B,Button3C,Button3A,Button3Save))

Button4A.InputEnded:connect(CLICKED("health",.75,Button4A,Button4B,Button4C,Button4D,Button4Save))
Button4B.InputEnded:connect(CLICKED("health",1.00,Button4B,Button4A,Button4C,Button4D,Button4Save))
Button4C.InputEnded:connect(CLICKED("health",1.25,Button4C,Button4B,Button4A,Button4D,Button4Save))
Button4D.InputEnded:connect(CLICKED("health",1.50,Button4D,Button4B,Button4C,Button4A,Button4Save))

Button5A.InputEnded:connect(CLICKED("growth",1.5,Button5A,Button5B,Button5C,Button5D,Button5Save))
Button5B.InputEnded:connect(CLICKED("growth",1,Button5B,Button5A,Button5C,Button5D,Button5Save))
Button5C.InputEnded:connect(CLICKED("growth",.75,Button5C,Button5B,Button5A,Button5D,Button5Save))
Button5D.InputEnded:connect(CLICKED("growth",.50,Button5D,Button5B,Button5C,Button5A,Button5Save))
	
Button1Save.InputEnded:connect(APPLIED("stats",statsmultiplier,Button1A,Button1B,Button1C,Button1D,Button1Save))
Button2Save.InputEnded:connect(APPLIED("regen",regenmultiplier,Button2A,Button2B,Button2C,Button2D,Button2Save))
Button3Save.InputEnded:connect(APPLIED("daynight",daynightmultiplier,Button3A,Button3B,Button3C,Button3D,Button3Save))
Button4Save.InputEnded:connect(APPLIED("health",healthmultiplier,Button4A,Button4B,Button4C,Button4D,Button4Save))
Button5Save.InputEnded:connect(APPLIED("growth",growthmultiplier,Button5A,Button5B,Button5C,Button5D,Button5Save))
