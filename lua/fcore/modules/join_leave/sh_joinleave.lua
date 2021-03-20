FCore.JoinLeave = {}

if SERVER then
    util.AddNetworkString("FCore::JoinLeave")

    function FCore.JoinLeave.Parse(data, eventType)
        net.Start("FCore::JoinLeave")
            net.WriteString(data.name)
            net.WriteString("0")
            net.WriteString(eventType)
        net.Broadcast()
    end

    gameevent.Listen("player_connect")
    gameevent.Listen("player_disconnect")

    hook.Add("player_connect", "FCore::Connection", function(data)
        
    end)

    hook.Add("player_disconnect", "FCore::Connection", function(data)
        
    end)
else
    function FCore.JoinLeave.Print()
        local plyName = net.ReadString()
        local lastJoined = net.ReadString()
        local event = net.ReadString()
    end

    net.Receive("FCore::JoinLeave", FCore.JoinLeave.Print)
end