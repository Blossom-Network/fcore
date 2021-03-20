-- https://github.com/PolskiSandbox/tcore/blob/master/lua/tcore/dynamichostname/client/client.lua

local activeHostname = ""

net.Receive("FCore_HostnameSync", function()
    local text = net.ReadString()

    if text and #text > 0 then
        activeHostname = text
    end
end)

function GetHostName()
    return activeHostname
end