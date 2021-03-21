FCore.HUD = FCore.HUD or {}

function FCore.HUD.Player()
    local x = FCore.HUD.GetPos().x
    local y = FCore.HUD.GetPos().y

    local w = FCore.HUD.Config.Size.w
    local h = FCore.HUD.Config.Size.h

    local nickname = FCore.HUD.Text(LocalPlayer():Name(), 12)
    surface.SetFont("FCore_Open Sans_16_300")
    local nw,nh = surface.GetTextSize(nickname)

    surface.SetFont("FCore_Open Sans_18_300")
    local sw, sh = surface.GetTextSize("Blossom Network")

    sw = sw + 32
    sh = sh + 8

    // Background
    FCore.HUD.DrawBox(x + 8, y - sh, sw, sh, FCore.HUD.Config.Colors.secondary, true, true, false, false)
    FCore.HUD.DrawBox(x, y, w, h, FCore.HUD.Config.Colors.secondary)
    FCore.HUD.DrawBox(x, y, w / 3, h, FCore.HUD.Config.Colors.main, true, false, true, false)

    draw.DrawText("Blossom Network", "FCore_Open Sans_18_300", x + 8 + sw / 2, y - sh + 4, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    // Avatar
    FCore.HUD.DrawBox(x + 9, y + 24, 76, 76, FCore.HUD.Config.Colors.secondary)
    if !FCore.HUD.Avatar then
        FCore.HUD.Avatar = vgui.Create("AvatarImage")
        FCore.HUD.Avatar:SetSize(70, 70)
        FCore.HUD.Avatar:SetPos(x + 12, y + 27)
        FCore.HUD.Avatar:SetPlayer(LocalPlayer(), 184)
        FCore.HUD.Avatar:SetPaintedManually(true)
        FCore.HUD.Avatar:ParentToHUD()
    end
    FCore.HUD.Avatar:PaintManual()

    // Nickname
    FCore.HUD.DrawBox(x + (w / 3) / 2 - 40, y + h - nh * 2.25, 80, nh * 1.5, FCore.HUD.Config.Colors.secondary)
    draw.DrawText(nickname, "FCore_Open Sans_16_300", x + (w / 3) / 2, y + h - nh * 2.25 + 3, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    // Section HP
    FCore.HUD.DrawBox(x + (w / 3) + 8, y + 8, 60, FCore.HUD.Config.Size.h - 16, FCore.HUD.Config.Colors.main)

    // HP
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 16, y + 14, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.HUD.Config.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 16, y + 2 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), FCore.HUD.Config.Colors.health, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.text)

    draw.DrawText(LocalPlayer():Health(), "FCore_Open Sans_14_300", x + (w / 3) + 16 + 8, y + FCore.HUD.Config.Size.h / 2 - 16 - 7, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + (w / 3) + 13.5, y + ((FCore.HUD.Config.Size.h - 16) - 16), "heart", 14, FCore.HUD.Config.Colors.secondary, TEXT_ALIGN_LEFT)

    // Armor
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 40, y + 14, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.HUD.Config.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 40, y + 2 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), FCore.HUD.Config.Colors.armor, LocalPlayer():Armor(), "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.text)

    draw.DrawText(LocalPlayer():Armor(), "FCore_Open Sans_14_300", x + (w / 3) + 40 + 8, y + FCore.HUD.Config.Size.h / 2 - 16 - 7, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + (w / 3) + 39.5, y + ((FCore.HUD.Config.Size.h - 16) - 16), "armor", 14, FCore.HUD.Config.Colors.secondary, TEXT_ALIGN_LEFT)

    // Section Info
    FCore.HUD.DrawBox(x + (w / 3) + 76, y + 8, 100, FCore.HUD.Config.Size.h - 16, FCore.HUD.Config.Colors.main)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 16, "suitcase", 14, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 1, 1, 12)
    draw.DrawText(LocalPlayer():getDarkRPVar("job"), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 20, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 46, "cash", 14, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 1, 2, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("money")), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 50, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 78, "dollar", 14, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 4, 1, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("salary")), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 81, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 112, "users", 14, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 1, 1, 12)
    draw.DrawText("NULL", "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 115, FCore.HUD.Config.Colors.text)
end

function FCore.HUD.EntityPlayer(self)

end

function FCore.HUD.drawPlayerInfo(ply)
    local pos = ply:GetPos() + ply:OBBCenter() + Vector(0, 0, 0)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
    pos.z = pos.z + 15

    surface.SetFont("FCore_Open Sans_24_300")

    local x = 256

    cam.Start3D2D(pos, ang, 0.1)

        draw.RoundedBox(4, x + -125, -80, 250, 50, FCore.HUD.Config.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, -70, "user", 24, FCore.HUD.Config.Colors.main, FCore.HUD.Config.Colors.text, 6, 3, 18)
        draw.DrawText(FCore.HUD.Text(ply:Name(), 18), "FCore_Open Sans_24_300", x + 10, -66, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

        draw.RoundedBox(4, x + -125, -25, 250, 50, FCore.HUD.Config.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, -15, "suitcase", 24, FCore.HUD.Config.Colors.main, FCore.HUD.Config.Colors.text, 3, 3, 18)
        draw.DrawText(ply:getDarkRPVar("job"), "FCore_Open Sans_24_300", x + 8, -11, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

        draw.RoundedBox(4, x + -125, 30, 250, 50, FCore.HUD.Config.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, 40, "heart", 24, FCore.HUD.Config.Colors.main, FCore.HUD.Config.Colors.text, 3, 3, 18)
        draw.DrawText(ply:Health(), "FCore_Open Sans_24_300", x + 8, 42, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function FCore.HUD.drawOwnableInfo(ent)

end

function FCore.HUD.DrawEntity()
    local shootPos = LocalPlayer():GetShootPos()
    local aimVec = LocalPlayer():GetAimVector()

    for _, ply in ipairs(players or player.GetAll()) do
        if !IsValid(ply) or ply == LocalPlayer() or !ply:Alive() or ply:GetNoDraw() or ply:IsDormant() then continue end
        local hisPos = ply:GetShootPos()

        if GAMEMODE.Config.globalshow then
            FCore.HUD.drawPlayerInfo(ply)
        elseif hisPos:DistToSqr(shootPos) < 100000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
                if trace.Hit and trace.Entity ~= ply then
                    if trace.Entity:IsPlayer() then
                        FCore.HUD.drawPlayerInfo(trace.Entity)
                    end
                    break
                end
                FCore.HUD.drawPlayerInfo(ply)
            end
        end
    end

    local ent = LocalPlayer():GetEyeTrace().Entity

    if IsValid(ent) and ent:isKeysOwnable() and ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then
        FCore.HUD.drawOwnableInfo(ent)
    end
end

function FCore.HUD.Hook()
    FCore.HUD.Player()
end

hook.Run("FCore_ReplaceHUD")