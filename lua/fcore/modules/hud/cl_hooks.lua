hook.Add("FCore_ReplaceHUD", "FCore::HUD::Hooks", function()
    hook.Add("HUDPaint", "FCore::HUD::Core", FCore.HUD.Hook)
    hook.Add("PostDrawOpaqueRenderables", "FCore::HUD::Entity", FCore.HUD.DrawEntity)

    local hideHUDElements = {
        -- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
        -- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
        ["DarkRP_HUD"] = true,

        -- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
        -- This also draws the information on doors and vehicles
        ["DarkRP_EntityDisplay"] = true,

        -- This is the one you're most likely to replace first
        -- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
        -- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
        ["DarkRP_LocalPlayerHUD"] = true,

        -- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
        -- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
        ["DarkRP_Hungermod"] = false,

        -- Drawing the DarkRP agenda
        ["DarkRP_Agenda"] = false,

        -- Lockdown info on the HUD
        ["DarkRP_LockdownHUD"] = false,

        -- Arrested HUD
        ["DarkRP_ArrestedHUD"] = false,

        -- Chat receivers box when you open chat or speak over the microphone
        ["DarkRP_ChatReceivers"] = false,

        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true,
        ["CHudHealth"] = true,
        ["CHudBattery"] = true
    }

    -- this is the code that actually disables the drawing.
    hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
        if hideHUDElements[name] then return false end
    end)
end)