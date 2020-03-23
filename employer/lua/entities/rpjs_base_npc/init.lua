AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.lastUse = CurTime() + 0.5
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:DropToFloor()
end

function ENT:Think()
end

function ENT:AcceptInput( Name, Activator, Caller )
	local jobs = self:GetJobss()
	local title = self:GetTitle()
	if !self.lastUse then self.lastUse = CurTime() + 0.5 end
	if Caller:GetPos():Distance(self:GetPos()) >= rpjs.config.distance then return end
	if CurTime() >= self.lastUse then
		if Name == "Use" and Caller:IsPlayer() and Caller:Alive() then
			RPJS_RolePlayJobSystem( title, jobs, Caller )
		end
		self.lastUse = CurTime() + 0.5
	end
end