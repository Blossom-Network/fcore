FCore.InformationSystem = FCore.InformationSystem or {}

util.AddNetworkString("FCore::InformationSystem::Send")
util.AddNetworkString("FCore::InformationSystem::Receive")

net.Receive("FCore::InformationSystem::Send", function(len, ply)
    if !IsValid(ply) then
        local information = {}

        local informationType = net.ReadInt(3) // zmienić potem bit, nie pamiętam z pamięci do ilu to jest
        local informationText = net.ReadString()
        local informationSender = ply

        information.pos = informationSender:GetPos() + informationSender:OBBCenter()
        information.type = informationType
        information.text = informationText
        information.sender = informationSender
        information.time = os.time()
        
        net.Start("FCore::InformationSystem::Receive")
        net.WriteTable(information)
        if FCore.InformationSystem.Config[informationType].allowed then
            local teams = FCore.InformationSystem.Config[informationType].allowed()
            local validPlayers = {}

            for _,v in ipairs(player.GetAll()) do
                if !IsValid(v) then continue end

                if table.HasValue(teams, v:Team()) then
                        table.insert(validPlayers, v)
                end
            end

            net.Send(validPlayers)
        else
            net.Broadcast()
        end
    end
end)

local function test()
    local information = {}

    local informationType = 1
    local informationText = "test"
    local informationSender = Entity(1)

    information.pos = informationSender:GetPos() + informationSender:OBBCenter()
    information.type = informationType
    information.text = informationText
    information.sender = informationSender
    information.time = os.time()

    net.Start("FCore::InformationSystem::Receive")
    net.WriteTable(information)
    if FCore.InformationSystem.Config[informationType].allowed then
        local teams = FCore.InformationSystem.Config[informationType].allowed()
        local validPlayers = {}

        for _,v in ipairs(player.GetAll()) do
            if !IsValid(v) then continue end

            if table.HasValue(teams, v:Team()) then
                    table.insert(validPlayers, v)
            end
        end

        net.Send(validPlayers)
    else
        net.Broadcast()
    end
end
concommand.Add("infotest", test)