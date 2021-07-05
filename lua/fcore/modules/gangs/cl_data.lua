FCore.Gangs = FCore.Gangs or {}
FCore.Gangs.Instances = FCore.Gangs.Instances or {}

function FCore.Gangs.LoadGangs()
    FCore.Gangs.Instances = net.ReadTable()

    for gangid,gangdata in ipairs(FCore.Gangs.Instances) do
        if !gangdata.active then continue end

        for memberid, memberdata in pairs(gangdata.members) do
            local ply = player.GetBySteamID64(memberid)

            if ply then
                ply:SetGang(gangid)
            end
        end
    end
end

function FCore.Gangs.Update()
    net.Start("fcore_getgangs")
    net.SendToServer()
end
net.Receive("fcore_getgangs", FCore.Gangs.LoadGangs)