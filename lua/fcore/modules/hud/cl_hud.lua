FCore.HUD = FCore.HUD or {}

function FCore.HUD.Player()
    local x = FCore.HUD.GetPos().x
    local y = FCore.HUD.GetPos().y

    local w = FCore.HUD.Config.Size.w
    local h = FCore.HUD.Config.Size.h

    local nickname = FCore.HUD.Text(LocalPlayer():Name(), 12)
    surface.SetFont("FCore_Open Sans_18_300")
    local nw, nh = surface.GetTextSize(nickname)

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
    FCore.HUD.DrawBox(x + 11, y + 24, 104, 104, FCore.HUD.Config.Colors.secondary)
    if !FCore.HUD.Avatar then
        FCore.HUD.Avatar = vgui.Create("AvatarImage")
        FCore.HUD.Avatar:SetSize(96, 96)
        FCore.HUD.Avatar:SetPos(x + 15, y + 28)
        FCore.HUD.Avatar:SetPlayer(LocalPlayer(), 184)
        FCore.HUD.Avatar:ParentToHUD()
    end

    // Nickname
    FCore.HUD.DrawBox(x + (w / 3) / 2 - 50, y + h - nh * 2.25, 100, nh * 1.5, FCore.HUD.Config.Colors.secondary)
    draw.DrawText(nickname, "FCore_Open Sans_18_300", x + (w / 3) / 2, y + h - nh * 2.25 + 4.5, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    // Section HP
    FCore.HUD.DrawBox(x + (w / 3) + 8, y + 8, 60, FCore.HUD.Config.Size.h - 16, FCore.HUD.Config.Colors.main)
    
    // HP
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 16, y + 12, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.HUD.Config.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 16, y + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), FCore.HUD.Config.Colors.health, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.text)
    
    draw.DrawText(LocalPlayer():Health(), "FCore_Open Sans_14_300", x + (w / 3) + 16 + 8, y + FCore.HUD.Config.Size.h / 2 - 16 - 7, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    
    FCore.HUD.DrawIcon(x + (w / 3) + 13.5, y + ((FCore.HUD.Config.Size.h - 16) - 16), "heart", 14, FCore.HUD.Config.Colors.secondary, TEXT_ALIGN_LEFT)

    // Armor
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 40, y + 12, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.HUD.Config.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 40, y + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), FCore.HUD.Config.Colors.armor, LocalPlayer():Armor(), "FCore_Open Sans_14_300", FCore.HUD.Config.Colors.text)
    
    draw.DrawText(LocalPlayer():Armor(), "FCore_Open Sans_14_300", x + (w / 3) + 40 + 8, y + FCore.HUD.Config.Size.h / 2 - 16 - 7, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + (w / 3) + 39.5, y + ((FCore.HUD.Config.Size.h - 16) - 16), "armor", 14, FCore.HUD.Config.Colors.secondary, TEXT_ALIGN_LEFT)

    // Section Info
    FCore.HUD.DrawBox(x + (w / 3) + 76, y + 8, 166, FCore.HUD.Config.Size.h - 16, FCore.HUD.Config.Colors.main)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 16, "suitcase", 18, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 2, 2, 14)
    draw.DrawText(LocalPlayer():getDarkRPVar("job"), "FCore_Open Sans_16_300", x + (w / 3) + 116, y + 20, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 56, "cash", 18, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 2, 2, 14)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("money")), "FCore_Open Sans_16_300", x + (w / 3) + 116, y + 60, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 98, "dollar", 18, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 5, 2, 14)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("salary")), "FCore_Open Sans_16_300", x + (w / 3) + 116, y + 102, FCore.HUD.Config.Colors.text)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 140, "users", 18, FCore.HUD.Config.Colors.secondary, FCore.HUD.Config.Colors.text, 2, 2, 14)
    draw.DrawText("NULL", "FCore_Open Sans_16_300", x + (w / 3) + 116, y + 144, FCore.HUD.Config.Colors.text)
end

function FCore.HUD.EntityPlayer(self)

end

function FCore.HUD.drawPlayerInfo(ply)
	local pos = ply:EyePos() - Vector(0, 0, 0)
    local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
    pos.z = pos.z + 15

    surface.SetFont("FCore.HUD.Open Sans.24.Regular")

    local nw, nh = surface.GetTextSize(ply:Name())
    local jw, jh = surface.GetTextSize(ply:getDarkRPVar("job"))

    local size = {
        w = math.max(nw, jw) + 32,
        h = 50
    }

    if !FCore.HUD.PlayerAvatar then
        FCore.HUD.PlayerAvatar = vgui.Create("AvatarImage")
        FCore.HUD.PlayerAvatar:SetSize(64, 64)
        FCore.HUD.PlayerAvatar:SetPlayer(ply, 184)

        FCore.HUD.PlayerAvatar:SetPaintedManually(true)
    end

    cam.Start3D2D(pos, ang, 0.1)
        draw.RoundedBox(4, -38, -68, 76, 76, FCore.HUD.Config.Colors.main)
        draw.RoundedBox(4, -size.w / 2, size.h / 2, size.w, size.h, FCore.HUD.Config.Colors.secondary)

        draw.DrawText(ply:Name(), "FCore.HUD.Open Sans.24.Regular", 0, 32, FCore.HUD.Config.Colors.white, TEXT_ALIGN_CENTER)
        draw.DrawText(ply:getDarkRPVar("job"), "FCore.HUD.Open Sans.24.Regular", 0, 48, FCore.HUD.Config.Colors.white, TEXT_ALIGN_CENTER)
        FCore.HUD.PlayerAvatar:SetPos(-32, -63.9)

        FCore.HUD.PlayerAvatar:PaintManual()
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
        elseif hisPos:DistToSqr(shootPos) < 160000 then
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