util.AddNetworkString("FCore_HostnameSync")

local texts = {
    "Klasyczek",
    "Kreatywność",
    "Miła Atmosfera",
    "Szambo"
}

local symbols = {
    "☀",
    "♻",
    "♡",
    "☺",
    "⛭",
    "⚡",
    "★",
    "☢",
    "⛱"
}

local language = "PL"
local serverName = "blossom-network.xyz"
local gamemode = gmod.GetGamemode().Name

local function changeHostname()
    local hostname = string.format(
        "%s %s | %s - %s | %s",
        symbols[math.random(1, #symbols)],
        language,
        serverName,
        gamemode,
        texts[math.random(1, #texts)]
    )

    RunConsoleCommand("hostname", hostname)

    net.Start("FCore_HostnameSync")
        net.WriteString(hostname)
    net.Broadcast()
end

timer.Create("FCore::DynamicHostname", 5, 0, changeHostname)