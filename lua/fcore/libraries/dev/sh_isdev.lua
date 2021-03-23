local steamid = {
    "STEAM_0:1:5481727",
    "STEAM_0:0:36777420"
}

local plyMeta = FindMetaTable("Player")

function plyMeta:IsDev()
    return table.HasValue(self:SteamID(), steamid)
end