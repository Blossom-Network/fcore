local deaths = {}
local defaultProperties = {
    x = ScrW() + 100,
    y = 0,
    w = 100,
    h = 52,
    marginX = 8,
    marginY = 8
}

function GAMEMODE:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
    for _,ply in ipairs(player.GetAll()) do
        if attacker == ply:Name() then
            attacker = ply
        elseif victim == ply:Name() then
            victim = ply
        end
    end

    if type(attacker) != "Player" then attacker = "" end

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
    surface.SetFont("FCore_Open Sans_18_300")

    for k,v in ipairs(deaths) do
        local aw = 0
        local vw = 0
        local vavpos = 0
        local vtpos = 0
        local tmp = v.w

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

        if type(v.attacker) == "Player" then
            aw = select(1, surface.GetTextSize(v.attacker:Name()))

            tmp = tmp + aw * 1.25 + 24
        else
            aw = surface.GetTextSize(v.attacker)
            tmp = tmp + aw * 1.25
        end

        if type(v.victim) == "Player" then
            vw = select(1, surface.GetTextSize(v.victim:Name()))

            tmp = tmp + vw * 1.25 + 24
        else
            vw = surface.GetTextSize(v.victim)
            tmp = tmp + vw * 1.25
        end

        v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - tmp - defaultProperties.marginX or ScrW() + defaultProperties.x )
        v.y = Lerp( FrameTime() * 10, v.y, ((k - 1) * v.h) + (k * defaultProperties.marginY) )

        draw.RoundedBox(4, v.x, v.y, tmp, v.h, FCore.HUD.Config.Colors.secondary)

        if v.attackerAvatar then
            draw.RoundedBox(4, v.x + 6, v.y + 6, 40, 40, FCore.HUD.Config.Colors.main)
            v.attackerAvatar:PaintManual()
            v.attackerAvatar:SetPos(v.x + 8, v.y + 8)

            draw.DrawText(v.attacker:Name(), "FCore_Open Sans_18_300", v.x + 52, v.y + 16, FCore.HUD.Config.Colors.text)
        else
            draw.DrawText(v.attacker or "", "FCore_Open Sans_18_300", v.x + select(1, surface.GetTextSize(v.attacker)) + 8, v.y + 16, FCore.HUD.Config.Colors.text)
        end

        if v.victimAvatar then
            if v.attacker != "" then
                vavpos = v.x + tmp - vw - 48
                vtpos = v.x + tmp - vw - 8
            else
                vavpos = v.x + tmp / 2 - 50
                vtpos = v.x + tmp / 2 - 10
            end

            draw.RoundedBox(4, vavpos - 3, v.y + 7, 40, 40, FCore.HUD.Config.Colors.main)
            v.victimAvatar:PaintManual()
            v.victimAvatar:SetPos(vavpos, v.y + 9)
            draw.DrawText(v.victim:Name(), "FCore_Open Sans_18_300", vtpos, v.y + 16, FCore.HUD.Config.Colors.text)
        else
            vtpos = v.x + tmp / 2 + 16

            draw.DrawText(v.victim, "FCore_Open Sans_18_300", vtpos, v.y + 16, FCore.HUD.Config.Colors.text)
        end

        if v.attacker != "" then
            draw.DrawText(utf8.char(0xf05b), "FCore_FontAwesome_24_300", v.x + tmp / 2 - 10, v.y + 13, FCore.HUD.Config.Colors.text, TEXT_ALIGN_LEFT)
        else
            draw.DrawText(utf8.char(0xf05b), "FCore_FontAwesome_24_300", v.x + 10, v.y + 13, FCore.HUD.Config.Colors.text, TEXT_ALIGN_LEFT)
        end
    end

    for k, v in ipairs(deaths) do
        if v.x >= defaultProperties.x and v.time < CurTime() then
            table.remove(deaths, k)
        end
    end
end)