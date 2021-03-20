local deaths = {}
local defaultProperties = {
    x = ScrW() + 100,
    y = 0,
    w = 250,
    h = 52,
    marginX = 8,
    marginY = 8
}

function GAMEMODE:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
    table.insert(deaths, {
        attacker = attacker or "",
        attackerTeam = attackerTeam,
        inflictor = inflictor,
        victim = victim,
        victimTeam = victimTeam,
        time = CurTime() + 5,
        x = defaultProperties.x,
        y = defaultProperties.marginY + (defaultProperties.h * #deaths),
        w = defaultProperties.w,
        h = defaultProperties.h
    })
end

// TODO: Suicide

hook.Add("DrawDeathNotice", "FCore::HUD::KillFeed", function()
    for k,v in ipairs(deaths) do
        v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - defaultProperties.marginX or ScrW() + defaultProperties.x )
        v.y = Lerp( FrameTime() * 10, v.y, ((k - 1) * v.h) + (k * defaultProperties.marginY) )

        draw.RoundedBox(4, v.x, v.y, v.w, v.h, FCore.HUD.Config.Colors.secondary)

        if type(v.attacker) != "Player" then
            for _,ply in ipairs(player.GetAll()) do
                if v.attacker == ply:Name() then
                    v.attacker = ply
                end
            end
        end

        if type(v.victim) != "Player" then
            for _,ply in ipairs(player.GetAll()) do
                if v.victim == ply:Name() then
                    v.victim = ply
                end
            end
        end

        if type(v.attacker) == "Player" and !v.attackerAvatar then
            v.attackerAvatar = vgui.Create("AvatarImage")
            v.attackerAvatar:SetSize(36, 36)
            v.attackerAvatar:SetPaintedManually(true)
            v.attackerAvatar:SetPlayer(v.attacker, 184)
            v.attackerAvatar:ParentToHUD()
        end

        if type(v.victim) == "Player" and !v.victimAvatar then
            v.victimAvatar = vgui.Create("AvatarImage")
            v.victimAvatar:SetSize(36, 36)
            v.victimAvatar:SetPaintedManually(true)
            v.victimAvatar:SetPlayer(v.victim, 184)
            v.victimAvatar:ParentToHUD()
            v.victimAvatar:PaintManual()
        end

        surface.SetFont("FCore_Open Sans_18_300")

        if v.attackerAvatar then
            draw.RoundedBox(4, v.x + 6, v.y + 6, 40, 40, FCore.HUD.Config.Colors.main)
            v.attackerAvatar:PaintManual()
            v.attackerAvatar:SetPos(v.x + 8, v.y + 9)

            draw.DrawText(v.attacker:Name(), "FCore_Open Sans_18_300", v.x + 48, v.y + 16, FCore.HUD.Config.Colors.text)
        else
            draw.DrawText(v.attacker or "", "FCore_Open Sans_18_300", v.x + select(1, surface.GetTextSize(v.attacker)) + 8, v.y + 16, FCore.HUD.Config.Colors.text)
        end

        if v.victimAvatar then
            draw.RoundedBox(4, v.x + v.w - select(1, surface.GetTextSize(v.victim:Name())) - 50, v.y + 6, 40, 40, FCore.HUD.Config.Colors.main)

            v.victimAvatar:PaintManual()

            v.victimAvatar:SetPos(v.x + v.w - select(1, surface.GetTextSize(v.victim:Name())) - 48, v.y + 9)
            draw.DrawText(v.victim:Name(), "FCore_Open Sans_18_300", v.x + v.w - select(1, surface.GetTextSize(v.victim:Name())) - 8, v.y + 16, FCore.HUD.Config.Colors.text)
        else
            draw.DrawText(v.victim, "FCore_Open Sans_18_300", v.x + v.w - select(1, surface.GetTextSize(v.victim:Name())) - 8, v.y + 16, FCore.HUD.Config.Colors.text)
        end

        draw.DrawText(utf8.char(0xf05b), "FCore_FontAwesome_24_300", v.x + v.w / 2 - 10, v.y + 13, FCore.HUD.Config.Colors.text, TEXT_ALIGN_LEFT)
    end

    for k, v in ipairs(deaths) do
        if v.x >= defaultProperties.x and v.time < CurTime() then
            table.remove(deaths, k)
        end
    end
end)