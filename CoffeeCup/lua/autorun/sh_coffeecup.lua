if SERVER then
	util.AddNetworkString("CoffeeCup_Pressed")
end

CoffeeCup = CoffeeCup or {}

CoffeeCup.EnablePointshop = true -- Should Pointshop mode be enabled?
CoffeeCup.Points = 5 -- How many points should players be given upon finding it?

CoffeeCup.ReplacementTypes = {
	"prop_physics",
	"prop_physics_multiplayer",
	"prop_dynamic"
}

CoffeeCup.Models = {
	"models/props/cs_office/coffee_mug.mdl",
	"models/props/cs_office/coffee_mug2.mdl",
	"models/props/cs_office/coffee_mug3.mdl"
}

if SERVER then
function CoffeeCup.CheckRequirements()
	
	if CoffeeCup.ReplacementTypes and #CoffeeCup.ReplacementTypes > 0 then
		CoffeeCup.EntityType = table.Random(CoffeeCup.ReplacementTypes)
		CoffeeCup.PropToReplace = table.Random(ents.FindByClass(CoffeeCup.EntityType))
		if not CoffeeCup.PropToReplace then
			table.RemoveByValue(CoffeeCup.ReplacementTypes, CoffeeCup.EntityType)
			CoffeeCup.CheckRequirements()
		else
			CoffeeCup.GenerateEntity()
		end
	else
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("[COFFEE-CUP] Could not create Coffee-Cup!")
		end	
	end
	
end

function CoffeeCup.GenerateEntity()
	local original_prop_pos = CoffeeCup.PropToReplace:GetPos()
	CoffeeCup.PropToReplace:Remove()
	
	local coffee_cup = ents.Create("ent_coffeecup")
	coffee_cup:SetPos(original_prop_pos)
	coffee_cup:Spawn()
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("[COFFEE-CUP] A Coffee Cup has spawned! Press E on it for "..CoffeeCup.Points.." points!")
	end	
end

hook.Add("TTTBeginRound", "CC_ChooseProp", function()
	CoffeeCup.CheckRequirements()
end)

hook.Add("TTTEndRound", "CC_KillProp", function(result)
	local cup = ents.FindByClass("ent_coffeecup")
	if cup then
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("[COFFEE-CUP] No one found the coffee-cup this round!")
		end	
	end
end)
end

if CLIENT then

net.Receive("CoffeeCup_Pressed", function()

	surface.PlaySound("buttons/button17.wav")

	local frame = vgui.Create("DFrame")
	frame:SetSize(300,125)
	frame:ShowCloseButton(false)
	frame:SetPos(ScrW()/2-150,ScrH()+125)
	frame:SetTitle("")
	frame.Paint = function()
		draw.RoundedBox(0, 0, 0, 300,150, Color(236,236,236))
		draw.RoundedBox(0, 0, 0, 100,150, Color(65, 131, 215))
	end
	
	frame:MoveTo(ScrW()/2-150,ScrH()-125, 3, -1, 5,
	function()
		timer.Simple(3, function()
			frame:MoveTo(ScrW()/2-150,ScrH()+125, 3, -1, 5, 
			function()
				frame:Remove()
			end)
		end)	
	end)
	
	local coffeecup_img = vgui.Create("DImage", frame)
	coffeecup_img:SetPos(0,0)
	coffeecup_img:SetImage("materials/niandralades/cc/coffeecup.png")
	coffeecup_img:SetSize(128,128)
	
	local coffeecup_txt = vgui.Create("DLabel", frame)
	coffeecup_txt:SetText("Congrats! \nYou found the coffee cup.")
	coffeecup_txt:SetPos(110, 10)
	coffeecup_txt:SetColor(Color(0,0,0,255))
	coffeecup_txt:SizeToContents()
	
	local coffeecup_txt = vgui.Create("DLabel", frame)
	coffeecup_txt:SetText("+"..CoffeeCup.Points.." points!")
	coffeecup_txt:SetPos(110, 50)
	coffeecup_txt:SetFont("Bebas20")
	coffeecup_txt:SetColor(Color(0,0,0,255))
	coffeecup_txt:SizeToContents()
end)
end
