FCore.JoinLeave = {}

if SERVER then
    util.AddNetworkString("FCore::JoinLeave")

    if !file.Exists("fcore/", "DATA") then
        file.CreateDir("fcore/")
    else
        if !file.Exists("fcore/join_leave/", "DATA") then
            file.CreateDir("fcore/join_leave/")
        end
    end

    function FCore.JoinLeave.GetTime(sid)
        if !file.Exists("fcore/join_leave/" .. sid .. ".txt", "DATA") then
            return 0
        else
            return file.Read("fcore/join_leave/" .. sid .. ".txt", "DATA")
        end
    end

    function FCore.JoinLeave.SetTime(sid)
        file.Write("fcore/join_leave/" .. sid .. ".txt", os.time())
    end

    function FCore.JoinLeave.Parse(data, eventType)
        local sid = data.networkid
        local time = FCore.JoinLeave.GetTime(data.networkid)

        data.networkid = string.Replace(sid, "_", "")
        data.networkid = string.Replace(sid, ":", "")

        if eventType == "leave" then
            FCore.JoinLeave.SetTime(data.networkid)
        end

        net.Start("FCore::JoinLeave")
            net.WriteString(data.name .. " (" .. sid .. ")")
            if time == 0 then
                net.WriteString("nigdy")
            else
                net.WriteString(os.date("%d/%m/%Y %H:%M", time))
            end
            net.WriteString(eventType)
        net.Broadcast()
    end

    gameevent.Listen("player_connect")
    gameevent.Listen("player_disconnect")

    hook.Add("player_connect", "FCore::Connection", function(data)
        FCore.JoinLeave.Parse(data, "join")
    end)

    hook.Add("player_disconnect", "FCore::Connection", function(data)
        FCore.JoinLeave.Parse(data, "leave")
    end)
else
    function FCore.JoinLeave.Print()
        local plyName = net.ReadString()
        local lastJoined = net.ReadString()
        local event = net.ReadString()

        FCore.Scoreboard.Refresh()

        if event == "join" then
            FCore.AddText(Color(255,255,255), "Gracz ", plyName, Color(0,255,0), " dołączył ", Color(255,255,255), "na serwer!\nOstatni raz dołączył " .. lastJoined .. ".")
        elseif event == "leave" then
            FCore.AddText(Color(255,255,255), "Gracz ", plyName, Color(255,0,0), " wyszedł ", Color(255,255,255), "z serwera!")
        end
    end

    net.Receive("FCore::JoinLeave", FCore.JoinLeave.Print)
end