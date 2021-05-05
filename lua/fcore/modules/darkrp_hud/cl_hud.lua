FCore.HUD = FCore.HUD or {}

// https://github.com/astepantsov/gmod-advanced-door-system/blob/master/lua/advdoors/hud/cl_hud.lua
local function CalcDoorDrawPosition(door)
	local center = door:OBBCenter()
	local dimensions = door:OBBMins() - door:OBBMaxs()
	dimensions.x = math.abs(dimensions.x)
	dimensions.y = math.abs(dimensions.y)
	dimensions.z = math.abs(dimensions.z)

	local world_center = door:LocalToWorld(center)

	local trace = {
		endpos = world_center, 
		filter = ents.FindInSphere(world_center, 50),
		ignoreworld = true
	}

	table.RemoveByValue(trace.filter, door)

	local TraceStart, TraceStartRev, Width
	local x, y
	if dimensions.z < dimensions.x and dimensions.z < dimensions.y then
		x = "y"
		y = "x"
		TraceStart = trace.endpos + door:GetUp() * dimensions.z
		TraceStartRev = trace.endpos - door:GetUp() * dimensions.z
		Width = dimensions.y
	elseif dimensions.x < dimensions.y then
		x = "y"
		y = "z"
		Width = dimensions.y
		TraceStart = trace.endpos + door:GetForward() * dimensions.x
		TraceStartRev = trace.endpos - door:GetForward() * dimensions.x
	elseif dimensions.y < dimensions.x then
		x = "x"
		y = "z"
		Width = dimensions.x
		TraceStart = trace.endpos + door:GetRight() * dimensions.y
		TraceStartRev = trace.endpos - door:GetRight() * dimensions.y
	end

	trace.start = TraceStart;
	local tr = util.TraceLine(trace);
	trace.start = TraceStartRev
	local tr_rev = util.TraceLine(trace);

	local ang, ang_rev = tr.HitNormal:Angle(), tr_rev.HitNormal:Angle();
	ang:RotateAroundAxis(ang:Forward(), 90);
	ang:RotateAroundAxis(ang:Right(), 270);
	ang_rev:RotateAroundAxis(ang_rev:Forward(), 90);
	ang_rev:RotateAroundAxis(ang_rev:Right(), 270);
	local pos, pos_rev = tr.HitPos, tr_rev.HitPos

	return pos, ang, pos_rev, ang_rev, Width, x, y
end

function FCore.HUD.Player()
    local x = FCore.HUD.GetPos().x
    local y = FCore.HUD.GetPos().y

    local w = FCore.HUD.Config.Size.w
    local h = FCore.HUD.Config.Size.h

    local nickname = FCore.HUD.Text(LocalPlayer():Name(), 12)
    surface.SetFont("FCore_Open Sans_16_300")
    local _, nh = surface.GetTextSize(nickname)

    surface.SetFont("FCore_Open Sans_18_300")
    local sw, sh = surface.GetTextSize("Blossom Network")

    sw = sw + 32
    sh = sh + 8

    // Background
    FCore.HUD.DrawBox(x + 8, y - sh, sw, sh, FCore.Colors.secondary, true, true, false, false)
    FCore.HUD.DrawBox(x, y, w, h, FCore.Colors.secondary)
    FCore.HUD.DrawBox(x, y, w / 3, h, FCore.Colors.main, true, false, true, false)

    draw.DrawText("Blossom Network", "FCore_Open Sans_18_300", x + 8 + sw / 2, y - sh + 4, FCore.Colors.text, TEXT_ALIGN_CENTER)

    // Avatar
    FCore.HUD.DrawBox(x + 16, y + 24, 76, 76, FCore.Colors.secondary)
    if !FCore.HUD.Avatar then
        FCore.HUD.Avatar = vgui.Create("AvatarImage")
        FCore.HUD.Avatar:SetSize(70, 70)
        FCore.HUD.Avatar:SetPos(x + 19, y + 27)
        FCore.HUD.Avatar:SetPlayer(LocalPlayer(), 184)
        FCore.HUD.Avatar:SetPaintedManually(true)
        FCore.HUD.Avatar:ParentToHUD()
    end
    FCore.HUD.Avatar:PaintManual()

    // Nickname
    FCore.HUD.DrawBox(x + (w / 3) / 2 - 40, y + h - nh * 2.25, 80, nh * 1.5, FCore.Colors.secondary)
    draw.DrawText(nickname, "FCore_Open Sans_16_300", x + (w / 3) / 2, y + h - nh * 2.25 + 3, FCore.Colors.text, TEXT_ALIGN_CENTER)

    // Section HP
    FCore.HUD.DrawBox(x + (w / 3) + 8, y + 8, 60, FCore.HUD.Config.Size.h - 16, FCore.Colors.main)

    // HP
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 17, y + 18, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 17, y + 6 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * math.min(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 1), FCore.Colors.health, "", "FCore_Open Sans_14_300", FCore.Colors.text)

    draw.DrawText(LocalPlayer():Health(), "FCore_Open Sans_14_300", x + (w / 3) + 16 + 8, y + FCore.HUD.Config.Size.h / 2 - 12, FCore.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + (w / 3) + 14, y + ((FCore.HUD.Config.Size.h - 16) - 13), "heart", 12, FCore.Colors.secondary, TEXT_ALIGN_LEFT)

    // Armor
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 41, y + 18, 18, (FCore.HUD.Config.Size.h - 16) - 32, FCore.Colors.secondary, "", "FCore_Open Sans_14_300", FCore.Colors.transparent)
    FCore.HUD.DrawBarHorizontal(x + (w / 3) + 41, y + 6 + (FCore.HUD.Config.Size.h - 36) - ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), 18, ((FCore.HUD.Config.Size.h - 16) - 32) * (LocalPlayer():Armor() / 255), FCore.Colors.armor, LocalPlayer():Armor(), "FCore_Open Sans_14_300", FCore.Colors.text)

    draw.DrawText(LocalPlayer():Armor(), "FCore_Open Sans_14_300", x + (w / 3) + 41 + 8, y + FCore.HUD.Config.Size.h / 2 - 12, FCore.Colors.text, TEXT_ALIGN_CENTER)

    FCore.HUD.DrawIcon(x + (w / 3) + 41, y + ((FCore.HUD.Config.Size.h - 16) - 13), "armor", 12, FCore.Colors.secondary, TEXT_ALIGN_LEFT)

    // Section Info
    FCore.HUD.DrawBox(x + (w / 3) + 76, y + 8, 133, FCore.HUD.Config.Size.h - 16, FCore.Colors.main)

    // Job
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 16, "suitcase", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(LocalPlayer():getDarkRPVar("job"), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 20, FCore.Colors.text)

    // Money
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 46, "cash", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("money")), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 50, FCore.Colors.text)

    // Salary
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 78, "dollar", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText(FCore.HUD.FormatMoney(LocalPlayer():getDarkRPVar("salary")), "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 81, FCore.Colors.text)

    // Organisation
    FCore.HUD.DrawIconBox(x + (w / 3) + 84, y + 112, "users", 14, FCore.Colors.secondary, FCore.Colors.text, 0, 1, 12)
    draw.DrawText("NULL", "FCore_Open Sans_14_300", x + (w / 3) + 110, y + 115, FCore.Colors.text)
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
    local pos = ent:GetPos() + ent:OBBCenter()
    local ang = Vector(0, 90, 90)

    if ent:GetClass() == "prop_door_rotating" then
        pos, ang = CalcDoorDrawPosition(ent)
    elseif ent:GetClass() == "prop_vehicle_jeep" then

    end

    surface.SetFont("FCore_Open Sans_24_300")

    cam.Start3D2D(pos, ang, 0.1)

        draw.RoundedBox(4, 125, -80, 250, 50, FCore.Colors.secondary)
        FCore.HUD.DrawIconBox(-112, -70, "user", 24, FCore.Colors.main, FCore.Colors.text, 6, 3, 18)
        draw.DrawText(FCore.HUD.Text(ent:GetClass(), 18), "FCore_Open Sans_24_300", 10, -66, FCore.Colors.text, TEXT_ALIGN_CENTER)
    cam.End3D2D()
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
