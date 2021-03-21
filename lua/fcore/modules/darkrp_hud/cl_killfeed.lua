FCore.Killfeed = {}
FCore.Killfeed.Deaths = {}
FCore.Killfeed.Config = {
    AvatarSize = 40,
    Margin = 8
}

function GAMEMODE:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
    surface.SetFont("FCore_Open Sans_18_300")

    local tmp = {
        attacker = attacker or "",
        attackerTeam = attackerTeam,
        inflictor = inflictor,
        victim = victim,
        victimTeam = victimTeam,
        time = CurTime() + 5,
        w = 52,
        h = 52,
        x = ScrW(),
        y = 0,
    }

    tmp.aw = select(1, surface.GetTextSize(tmp.attacker))
    tmp.vw = select(1, surface.GetTextSize(tmp.victim))

    for _,ply in ipairs(player.GetAll()) do
        if tmp.attacker == ply:Name() then
            tmp.w = tmp.w + tmp.aw + FCore.Killfeed.Config.AvatarSize + (FCore.Killfeed.Config.Margin * 2)
            tmp.attacker = ply
        elseif tmp.victim == ply:Name() then
            tmp.w = tmp.w + tmp.vw + FCore.Killfeed.Config.AvatarSize + (FCore.Killfeed.Config.Margin * 2)
            tmp.victim = ply
        end
    end

    if type(tmp.attacker) != "Player" then
        tmp.attacker = ""
    end

    table.insert(FCore.Killfeed.Deaths, tmp)
end

hook.Add("DrawDeathNotice", "FCore::HUD::KillFeed", function()   
    for k,v in ipairs(FCore.Killfeed.Deaths) do
        surface.SetFont("FCore_Open Sans_18_300")
        surface.SetTextColor(FCore.HUD.Config.Colors.text)

        v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - FCore.Killfeed.Config.Margin or ScrW() + v.w )
        v.y = Lerp( FrameTime() * 10, v.y, ((k - 1) * v.h) + (k * FCore.Killfeed.Config.Margin ))

        draw.RoundedBox(4, v.x, v.y, v.w, v.h, FCore.HUD.Config.Colors.secondary)

        if type(v.attacker) == "Player" and !v.attackerAvatar then
            v.attackerAvatar = vgui.Create("AvatarImage")
            v.attackerAvatar:SetSize(36, 36)
            v.attackerAvatar:SetPaintedManually(true)
            v.attackerAvatar:SetPlayer(v.attacker, 184)
            v.attackerAvatar:ParentToHUD()
        end

        if !v.victimAvatar then
            v.victimAvatar = vgui.Create("AvatarImage")
            v.victimAvatar:SetSize(36, 36)
            v.victimAvatar:SetPaintedManually(true)
            v.victimAvatar:SetPlayer(v.victim, 184)
            v.victimAvatar:ParentToHUD()
            v.victimAvatar:PaintManual()
        end

        if v.attackerAvatar then
            draw.RoundedBox(4, v.x + FCore.Killfeed.Config.Margin - 2, v.y + 5, 40, 40, FCore.HUD.Config.Colors.main)
            v.attackerAvatar:SetPos(v.x + FCore.Killfeed.Config.Margin, v.y + 8)
            v.attackerAvatar:PaintManual()

            surface.SetTextPos(v.x + 36 + FCore.Killfeed.Config.Margin * 2, v.y + v.h / 2 - 9)
            surface.DrawText(v.attacker:Name())
        else
            surface.SetTextPos(v.x + (v.aw / 2) + FCore.Killfeed.Config.Margin, v.y + v.h / 2 - 9)
            surface.DrawText(v.attacker)
        end

        draw.RoundedBox(4, v.x + v.w - FCore.Killfeed.Config.Margin - 38, v.y + 5, 40, 40, FCore.HUD.Config.Colors.main)
        v.victimAvatar:SetPos(v.x + v.w - FCore.Killfeed.Config.Margin - 36, v.y + 8)
        v.victimAvatar:PaintManual()

        surface.SetTextPos(v.x + v.w - 72 - FCore.Killfeed.Config.Margin * 2, v.y + v.h / 2 - 9)
        surface.DrawText(v.victim:Name())

        if v.attacker != "" then
            draw.DrawText(utf8.char(0xf05b), "FCore_FontAwesome_24_300", v.x + v.w / 2 - 10, v.y + 13, FCore.HUD.Config.Colors.text, TEXT_ALIGN_LEFT)
        else
            draw.DrawText(utf8.char(0xf05b), "FCore_FontAwesome_24_300", v.x + FCore.Killfeed.Config.Margin + 6, v.y + 13, FCore.HUD.Config.Colors.text, TEXT_ALIGN_LEFT)
        end
    end

    for k, v in ipairs(FCore.Killfeed.Deaths) do
        if v.x >= ScrW() and v.time < CurTime() then
            table.remove(FCore.Killfeed.Deaths, k)
        end
    end
end)