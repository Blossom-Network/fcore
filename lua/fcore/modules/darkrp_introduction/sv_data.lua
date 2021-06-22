FCore.Introduction = {}

util.AddNetworkString("fcore_loadpoints")
util.AddNetworkString("fcore_savepoints")

function FCore.Introduction.LoadPoints(_, ply)
    local map = game.GetMap()

    net.Start("fcore_loadpoints")
    net.WriteTable(util.JSONToTable(file.Read("fcore/introduction/" .. map .. ".txt", "DATA")))
    net.Send(ply)
end

function FCore.Introduction.SavePoints(_, ply)
    if ply:IsSuperAdmin() or ply:IsDev() then
        local map = game.GetMap()

        file.Write("fcore/introduction/" .. map .. ".txt", util.TableToJSON(net.ReadTable()))

        net.Start("fcore_savepoints")
        net.WriteString("Zapisano do bazy danych!")
        net.Send(ply)
    end
end

net.Receive("fcore_loadpoints", FCore.Introduction.LoadPoints)
net.Receive("fcore_savepoints", FCore.Introduction.SavePoints)