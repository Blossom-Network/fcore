FCore.HUD = FCore.HUD or {}
FCore.HUD.ArrestedTime = {
    Start = 0,
    Until = 0
}

usermessage.Hook("GotArrested", function(msg)
    FCore.HUD.ArrestedTime.Start = CurTime()
    FCore.HUD.ArrestedTime.Until = msg:ReadFloat()
end)

function FCore.HUD.Player()
    local x = FCore.HUD.GetPos().x
    local y = FCore.HUD.GetPos().y

    local w = FCore.HUD.Config.Size.w
    local h = FCore.HUD.Config.Size.h

    if LocalPlayer():getDarkRPVar("Arrested") then
            FCore.HUD.DrawBox(ScrW() / 2 - 200, ScrH() - 64, 400, 54, FCore.Colors.secondary, true, true, true, true)

            draw.DrawText(string.format("Jesteś aresztowany jeszcze przez %d sekund.", (FCore.HUD.ArrestedTime.Until + FCore.HUD.ArrestedTime.Start) - CurTime()), "FCore_Open Sans_18_500", ScrW() / 2, ScrH() - 60, FCore.Colors.white, TEXT_ALIGN_CENTER)
        
            surface.SetDrawColor(FCore.Colors.main)
            surface.DrawOutlinedRect(ScrW() / 2 - 175, ScrH() - 36, 350, 18, 2)

            local barwidth = 1 + ((FCore.HUD.ArrestedTime.Until + FCore.HUD.ArrestedTime.Start) - CurTime()) / -FCore.HUD.ArrestedTime.Until

            surface.DrawRect(ScrW() / 2 - 175, ScrH() - 36, 350 * barwidth, 18, 2)
            return
    end

    local nickname = LocalPlayer():Name()
    surface.SetFont("FCore_Open Sans_16_300")
    local nw, nh = surface.GetTextSize(nickname)

    surface.SetFont("FCore_Open Sans_18_500")
    local sw, sh = surface.GetTextSize("ChillRP")

    sw = sw + 32
    sh = sh + 8

    local sow = 0

    // Background
    FCore.HUD.DrawBox(x + 8, y - sh, sw, sh, FCore.Colors.secondary, true, true, false, false)
    if nw + 16 >= 80 then
        FCore.HUD.DrawBox(x + nw + 32, y, w - w / 3, h, FCore.Colors.secondary, false, true, false, true)
        FCore.HUD.DrawBox(x, y, nw + 32, h, FCore.Colors.main, true, false, true, false)
        sow = nw + 32
    else
        FCore.HUD.DrawBox(x + 96, y, w - w / 3, h, FCore.Colors.secondary, false, true, false, true)
        FCore.HUD.DrawBox(x, y, 96, h, FCore.Colors.main, true, false, true, false)
        sow = 96
    end

    draw.DrawText("ChillRP", "FCore_Open Sans_18_500", x + 8 + sw / 2, y - sh + 4, FCore.Colors.text, TEXT_ALIGN_CENTER)

    // Avatar
    FCore.HUD.DrawBox(x + sow / 2 - 76 / 2, y + 24, 76, 76, FCore.Colors.secondary)
    if !FCore.HUD.Avatar then
        FCore.HUD.Avatar = vgui.Create("AvatarImage")
        FCore.HUD.Avatar:SetSize(70, 70)
        FCore.HUD.Avatar:SetPlayer(LocalPlayer(), 184)
        FCore.HUD.Avatar:SetPaintedManually(true)
        FCore.HUD.Avatar:ParentToHUD()
    end
    FCore.HUD.Avatar:SetPos(x + sow / 2 - 70 / 2, y + 27)
    FCore.HUD.Avatar:PaintManual()

    // Nickname
    FCore.HUD.DrawBox(x + sow / 2 - (nw + 8) / 2, y + h - nh * 2.25, nw + 8, nh * 1.5, FCore.Colors.secondary, true, true, true, true, 4)
    draw.DrawText(nickname, "FCore_Open Sans_16_500", x + sow / 2, y + h - nh * 2.25 + 3, FCore.Colors.text, TEXT_ALIGN_CENTER)

    // Section HP
    FCore.HUD.DrawBox(x + sow + 8, y + 8, 60, FCore.HUD.Config.Size.h - 16, FCore.Colors.main)

    // HP
    FCore.HUD.DrawBarHorizontal(x + sow + 17, y + 18, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + sow + 17, y + 6 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), FCore.Colors.health, "", "FCore_Open Sans_14_300", FCore.Colors.text)

    draw.DrawText(LocalPlayer():Health(), "FCore_Open Sans_12_300", x + sow + 16 + 9, y + FCore.HUD.Config.Size.h / 2 - 12, FCore.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + sow + 14, y + ((FCore.HUD.Config.Size.h - 16) - 13), "heart", 12, FCore.Colors.secondary, TEXT_ALIGN_LEFT)

    // Armor
    FCore.HUD.DrawBarHorizontal(x + sow + 41, y + 18, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + sow + 41, y + 6 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), FCore.Colors.armor, LocalPlayer():Armor(), "FCore_Open Sans_14_300", FCore.Colors.text)

    draw.DrawText(LocalPlayer():Armor(), "FCore_Open Sans_12_300", x + sow + 41 + 9, y + FCore.HUD.Config.Size.h / 2 - 12, FCore.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + sow + 41, y + ((FCore.HUD.Config.Size.h - 16) - 13), "armor", 12, FCore.Colors.secondary, TEXT_ALIGN_LEFT)

    // Section Info
    local padding = w - w / 3

    FCore.HUD.DrawBox(x + sow + 76, y + 8, 133, FCore.HUD.Config.Size.h - 16, FCore.Colors.main)

    // Job
    FCore.HUD.DrawIconBox(x + sow + 84, y + 16, "suitcase", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(LocalPlayer():getDarkRPVar("job"), "FCore_Open Sans_16_300", x + sow + 110, y + 18, FCore.Colors.text)

    // Money
    FCore.HUD.DrawIconBox(x + sow + 84, y + 46, "cash", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("money")), "FCore_Open Sans_16_300", x + sow + 110, y + 48, FCore.Colors.text)

    // Salary
    FCore.HUD.DrawIconBox(x + sow + 84, y + 78, "dollar", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("salary")), "FCore_Open Sans_16_300", x + sow + 110, y + 80, FCore.Colors.text)

    // Organisation
    FCore.HUD.DrawIconBox(x + sow + 84, y + 112, "users", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText("NULL", "FCore_Open Sans_16_300", x + sow + 110, y + 114, FCore.Colors.text)

    // License
    if LocalPlayer():getDarkRPVar("HasGunlicense") then
        FCore.HUD.DrawIconBox(x + w + 8, y + 117, "paper", 24, FCore.Colors.secondary, FCore.Colors.text, 2, 4, 18)
    end

    // Wanted
    if LocalPlayer():getDarkRPVar("wanted") and !FCore.Heist.Display then
        FCore.Heist.RunRaid()
        FCore.Heist.Display = true
    end

    if !LocalPlayer():getDarkRPVar("wanted") and FCore.Heist.Display then
        FCore.Heist.StopRaid()
        FCore.Heist.Display = false
    end
end

function FCore.HUD.drawPlayerInfo(ply)
    local pos = ply:GetPos() + ply:OBBCenter() + Vector(0, 0, 0)
    pos.z = pos.z + 15

    surface.SetFont("FCore_Open Sans_24_300")

    local x = 256

    // #onelinegang
    local lookAngle = (Vector(LocalPlayer():GetPos().x, LocalPlayer():GetPos().y, 0) - Vector(ply:GetPos().x, ply:GetPos().y, 0)):Angle()

    cam.Start3D2D(pos, lookAngle + Angle(0, 90, 90), 0.1)

        draw.RoundedBox(4, x + -125, -80, 250, 50, FCore.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, -70, "user", 24, FCore.Colors.main, FCore.Colors.text, 6, 3, 18)
        draw.DrawText(FCore.HUD.Text(ply:Name(), 18), "FCore_Open Sans_24_300", x + 10, -66, FCore.Colors.text, TEXT_ALIGN_CENTER)

        draw.RoundedBox(4, x + -125, -25, 250, 50, FCore.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, -15, "suitcase", 24, FCore.Colors.main, FCore.Colors.text, 3, 3, 18)
        draw.DrawText(ply:getDarkRPVar("job"), "FCore_Open Sans_24_300", x + 8, -11, FCore.Colors.text, TEXT_ALIGN_CENTER)

        draw.RoundedBox(4, x + -125, 30, 250, 50, FCore.Colors.secondary)
        FCore.HUD.DrawIconBox(x + -112, 40, "heart", 24, FCore.Colors.main, FCore.Colors.text, 3, 3, 18)
        draw.DrawText(ply:Health(), "FCore_Open Sans_24_300", x + 8, 42, FCore.Colors.text, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function FCore.HUD.drawOwnableInfo(ent)
    local pos1 = Vector(0,0,0)
    local pos2 = Vector(0,0,0)
    local ang = Angle(0,0,0)
    local entType = ""

    if ent:GetClass() == "prop_door_rotating" then
        pos1, pos2, ang = FCore.HUD.getDoorPos(ent)
        entType = "door"
    elseif ent:GetClass() == "prop_vehicle_jeep" then
        ang = (Vector(LocalPlayer():GetPos().x, LocalPlayer():GetPos().y - 180) - Vector(ent:GetPos().x, ent:GetPos().y, 0)):Angle()
        ang = ang + Angle(0, LocalPlayer():EyeAngles().yaw, 90)
        pos1 = ent:GetPos() + ent:OBBCenter()
        pos1.z = pos1.z + 15
        entType = "vehicle"
    end

    surface.SetFont("FCore_Open Sans_24_300")

    local doorInfo = {}

    local blocked = ent:getKeysNonOwnable()
    local doorTeams = ent:getKeysDoorTeams()
    local doorGroup = ent:getKeysDoorGroup()
    local playerOwned = ent:isKeysOwned() or table.GetFirstValue(ent:getKeysCoOwners() or {}) ~= nil
    local owned = playerOwned or doorGroup or doorTeams

    local title = ent:getKeysTitle()
    if title then table.insert(doorInfo, title) end

    if owned then
        table.insert(doorInfo, DarkRP.getPhrase("keys_owned_by"))
    end

    if playerOwned then
        if ent:isKeysOwned() then table.insert(doorInfo, ent:getDoorOwner():Nick()) end
        for k in pairs(ent:getKeysCoOwners() or {}) do
            local ply = Player(k)
            if not IsValid(ply) or not ply:IsPlayer() then continue end
            table.insert(doorInfo, ply:Nick())
        end

        local allowedCoOwn = ent:getKeysAllowedToOwn()
        if allowedCoOwn and not fn.Null(allowedCoOwn) then
            table.insert(doorInfo, DarkRP.getPhrase("keys_other_allowed"))

            for k in pairs(allowedCoOwn) do
                local ply = Player(k)
                if not IsValid(ply) or not ply:IsPlayer() then continue end
                table.insert(doorInfo, ply:Nick())
            end
        end
    elseif doorGroup then
        table.insert(doorInfo, doorGroup)
    elseif doorTeams then
        for k, v in pairs(doorTeams) do
            if not v or not RPExtraTeams[k] then continue end

            table.insert(doorInfo, RPExtraTeams[k].name)
        end
    elseif blocked and changeDoorAccess then
        table.insert(doorInfo, DarkRP.getPhrase("keys_allow_ownership"))
    elseif not blocked then
        table.insert(doorInfo, DarkRP.getPhrase("keys_unowned"))
        if changeDoorAccess then
            table.insert(doorInfo, DarkRP.getPhrase("keys_disallow_ownership"))
        end
    end

    if ent:IsVehicle() then
        local driver = ent:GetDriver()
        if driver:IsPlayer() then
            table.insert(doorInfo, DarkRP.getPhrase("driver", driver:Nick()))
        end
    end

    local text = table.concat(doorInfo, "\n")

    surface.SetFont("FCore_Open Sans_18_300")
    local tw, th = surface.GetTextSize(text)

    if entType == "door" then
        cam.Start3D2D(ent:LocalToWorld(pos1 + ent:OBBCenter()), ent:LocalToWorldAngles(ang), 0.1)
            draw.RoundedBox(4, -(tw + 16) / 2, 25, tw + 16, 10 + th, FCore.Colors.secondary)
            FCore.HUD.DrawIconBox(-24, -30, "door", 42, FCore.Colors.main, FCore.Colors.text, 5, 3, 32)
            draw.DrawText(text, "FCore_Open Sans_18_300", 0, 10 + th / 2, FCore.Colors.text, TEXT_ALIGN_CENTER)
        cam.End3D2D()

        cam.Start3D2D(ent:LocalToWorld(pos2 - ent:OBBCenter()), ent:LocalToWorldAngles(ang + Angle(0, 180, 0)), 0.1)
            draw.RoundedBox(4, -(tw + 16) / 2, 25, tw + 16, 10 + th, FCore.Colors.secondary)
            FCore.HUD.DrawIconBox(-24, -30, "door", 42, FCore.Colors.main, FCore.Colors.text, 5, 3, 32)
            draw.DrawText(text, "FCore_Open Sans_18_300", 0, 10 + th / 2, FCore.Colors.text, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    else
        cam.Start3D2D(pos1, ang, 0.2)
            draw.RoundedBox(4, -tw / 2, 25, tw, 10 + th, FCore.Colors.secondary)
            FCore.HUD.DrawIconBox(-21, -30, "vehicle", 42, FCore.Colors.main, FCore.Colors.text, 3, 3, 32)
            draw.DrawText(text, "FCore_Open Sans_18_300", 0, 10 + th / 2, FCore.Colors.text, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
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

    if IsValid(ent) and ent:isKeysOwnable() and ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 100000 then
        FCore.HUD.drawOwnableInfo(ent)
    end
end

function FCore.HUD.Agenda()
    local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_Agenda")
    if shouldDraw == false or !LocalPlayer():getAgendaTable() then return end

    surface.SetFont("FCore_Open Sans_18_300")
    local sw, sh = surface.GetTextSize("Ogłoszenia")

    sw = sw + 32
    sh = sh + 8

    // Background
    if !LocalPlayer():getDarkRPVar("agenda") then return end

    FCore.HUD.AgendaText = DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda")):gsub("//", "\n"):gsub("\\n", "\n"), "FCore_Open Sans_18_300", 314)
    local aw,ah = surface.GetTextSize(FCore.HUD.AgendaText)

    aw = aw + 32
    ah = ah + 8

    FCore.HUD.DrawBox(12, 36, sw, sh, FCore.Colors.secondary, true, true, false, false)
    draw.DrawText("Ogłoszenia", "FCore_Open Sans_18_300", 12 + sw / 2, 39, FCore.Colors.text, 1)

    draw.RoundedBox(4, 4, 34 + sh, 336, ah, FCore.Colors.main)
    draw.DrawNonParsedText(FCore.HUD.AgendaText, "FCore_Open Sans_18_300", 20, 63, FCore.Colors.text, 0)
end

function FCore.HUD.AmmoHUD()
    local wep = LocalPlayer():GetActiveWeapon()
    if !IsValid(wep) then return false end

    local wepText = string.upper(wep:GetPrintName())
    local wepAmmo = 0
    local wepSecondary = 0

    if wep.Primary and wep.Primary.ClipSize > 0 then
        wepAmmo = wep:Clip1()
        wepSecondary = wep:Ammo1()
    else
        return false
    end

    surface.SetFont("FCore_Open Sans_14_300")
    local sw, sh = surface.GetTextSize(wepText)

    sw = sw + 32
    sh = sh + 8

    local x = ScrW() - FCore.HUD.GetPos().x
    local y = ScrH() - 83

    draw.RoundedBoxEx(4, x - 75 - sw / 2, y - sh, sw, sh, FCore.Colors.secondary, true, true, false, false)
    draw.DrawText(wepText, "FCore_Open Sans_14_300", x - 75, y - sh + 3, FCore.Colors.text, 1)

    draw.RoundedBoxEx(4, x - 150, y, 75, 75, FCore.Colors.main, true, false, true, false)
    draw.DrawText(wepAmmo, "FCore_Open Sans_36_300", x - 112.5, y - sh + 40, FCore.Colors.text, 1)

    draw.RoundedBoxEx(4, x - 75, y, 75, 75, FCore.Colors.secondary, false, true, false, true)
    draw.DrawText(wepSecondary, "FCore_Open Sans_36_300", x - 37.5, y - sh + 40, FCore.Colors.text, 1)
end

function FCore.HUD.Hook()
    if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
        FCore.HUD.Player()
        FCore.HUD.Agenda()
        FCore.HUD.AmmoHUD()
    end
end

hook.Run("FCore_ReplaceHUD")
