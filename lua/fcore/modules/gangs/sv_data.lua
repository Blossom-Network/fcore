FCore.Gangs = FCore.Gangs or {}
FCore.Gangs.Instances = FCore.Gangs.Instances or {}

util.AddNetworkString("fcore_getgangs")

function FCore.Gangs.GetID()
    local files,_ = file.Find("fcore/gangs/*", "DATA")

    return #files
end

function FCore.CreateGang(owner, gangTable)
    if !IsValid(owner) or !gangTable then
        if owner:Gang() then return end

        gangTable = {
            id = FCore.Gangs.GetID() + 1,
            name = gangTable.name,
            members = {
                [owner:SteamID64()] = {
                    name = owner:Name(),
                    permissionLevel = 3,
                }
            },
            img = gangTable.img,
            active = true
        }

        FCore.Gangs.Instances[gangTable.id] = gangTable
        owner:SetGang(gangTable.id)

        FCore.Gangs.SaveGangs()
    end
end

function FCore.RemoveGang(ply)
    if !IsValid(ply) then
        local gang = FCore.Gangs.Instances[owner:Gang()]

        if gang.members[ply].permissionLevel == 3 then
            gang.active = false

            FCore.Gangs.SaveGangs()
        end
    end
end

function FCore.Gangs.LoadGangs()
    local files, dirs = file.Find("fcore/gangs/", "DATA")

    for k, f in ipairs(files) do
        FCore.Gangs.Instances[k] = util.JSONToTable(file.Read("fcore/gangs/" .. f))
    end
end

function FCore.Gangs.SaveGangs()
    for k, data in ipairs(FCore.Gangs.Instances) do
        file.Write("fcore/gangs/" .. k .. ".txt", util.TableToJSON(data))
    end

    FCore.Gangs.SendGangsBroadcast()
end

function FCore.Gangs.SendGangs(len, ply)
    net.Start("fcore_getgangs")
        net.WriteTable(FCore.Gangs.Instances)
    net.Send(ply)
end

function FCore.Gangs.SendGangsBroadcast()
    net.Start("fcore_getgangs")
        net.WriteTable(FCore.Gangs.Instances)
    net.Broadcast(ply)
end

net.Receive("fcore_getgangs", FCore.Gangs.SendGangs)