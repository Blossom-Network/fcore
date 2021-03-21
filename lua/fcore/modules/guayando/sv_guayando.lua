util.AddNetworkString("FCore::Guayando")

function guayando()
    net.Start("FCore::Guayando")
    net.Broadcast()
end

hook.Add("PlayerSay", "FCore::Guayando", function(ply, text)
    if (ply:IsSuperAdmin() or ply:IsDev()) and string.lower(text) == "!guayando" then
        guayando()
        return ""
    end
end)