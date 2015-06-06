AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/coffee_mug.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetPlaybackRate(1)
end

function ENT:Use(activator, caller)
	self:Remove()
	net.Start("CoffeeCup_Pressed")
	net.Send(activator)
	if CoffeeCup.EnablePointshop then
		activator:PS_GivePoints(CoffeeCup.Points)
	end
	
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("[Coffee-Cup]"..activator:Nick().." found the coffee cup and won "..CoffeeCup.Points.." points!")
	end	
end
 
function ENT:Think()
end
