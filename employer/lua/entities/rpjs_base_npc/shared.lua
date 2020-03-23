ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Author = "@NicolasStr_"
ENT.PrintName = "RolePlayJobSystem Entity Base"  -- DONT CHANGE THIS OR YOUR ADDON WILL CAUSE ERRORS, I USE THIS NAME TO CHECK TIMERS ETC
ENT.Category = "RolePlayJobSystem"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.NPCModel = "models/mossman.mdl" -- default model

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "Jobss" )
    self:NetworkVar( "String", 1, "Title" )
end

function ENT:Initialize()
end