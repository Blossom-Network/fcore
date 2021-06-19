if (engine.ActiveGamemode() ~= "darkrp") then return end

local hideHUDElements = {
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = true,
    ["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add("HUDShouldDraw", "FCore::NoDefault", function(name)
    if hideHUDElements[name] then return false end
end)