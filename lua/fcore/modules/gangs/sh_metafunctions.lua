FCore.Gangs = FCore.Gangs or {}
FCore.Gangs.Instances = FCore.Gangs.Instances or {}

local plyMeta = FindMetaTable("Player")

function plyMeta:SetGang(id)
    self:SetNWInt("gangid", id)
end

function plyMeta:Gang()
    return self:GetNWInt("gangid", 0)
end