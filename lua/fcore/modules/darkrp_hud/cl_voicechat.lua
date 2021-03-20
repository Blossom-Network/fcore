FCore.HUD.VCQueue = {}
FCore.HUD.VCQueue.Players = {}

local scrw = ScrW()
local scrh = ScrH()

function FCore.HUD.VCQueue.AddBar(ply)
    g_VoicePanelList:SetVisible(false)

    for k,v in ipairs(FCore.HUD.VCQueue.Players) do
        if v.ent == ply then
            return false
        end
    end

    table.insert(FCore.HUD.VCQueue.Players, {ent = ply, lastVoice = 0})
end

function FCore.HUD.VCQueue.RemoveBar(ply)
    g_VoicePanelList:SetVisible(false)

    for k,v in ipairs(FCore.HUD.VCQueue.Players) do
        if v.ent == ply then
            table.remove(FCore.HUD.VCQueue.Players, k)
        end
    end
end

function FCore.HUD.StartVoice(ply)
	if !IsValid(ply) then return end

    FCore.HUD.VCQueue.AddBar(ply)
end

function FCore.HUD.EndVoice(ply)
	if !IsValid(ply) then return end

    FCore.HUD.VCQueue.RemoveBar(ply)
end

function FCore.HUD.DrawVC()
    for k,v in ipairs(FCore.HUD.VCQueue.Players) do
        local ply = v.ent
        local col = team.GetColor(v.ent:Team())

        if !FCore.HUD.VCQueue.Players[k].avatar then
            FCore.HUD.VCQueue.Players[k].avatar = vgui.Create("AvatarImage")
            FCore.HUD.VCQueue.Players[k].avatar:SetSize(36, 36)
            FCore.HUD.VCQueue.Players[k].avatar:SetPlayer(v.ent, 184)
            FCore.HUD.VCQueue.Players[k].avatar:SetPaintedManually(true)
            FCore.HUD.VCQueue.Players[k].avatar:ParentToHUD()
        end

        draw.RoundedBox(4, scrw - 208, (scrh - 128) - 52 * k, 200, 48, FCore.HUD.Config.Colors.secondary)
        draw.RoundedBox(4, scrw - 208, (scrh - 82) - 52 * k, 200, 3, Color(col.r,col.g,col.b,Lerp((SysTime() - v.lastVoice) * 4, 255, 0)))

        draw.RoundedBox(4, scrw - 204, (scrh - 124) - 52 * k, 40, 40, FCore.HUD.Config.Colors.main)
        FCore.HUD.VCQueue.Players[k].avatar:PaintManual()
        FCore.HUD.VCQueue.Players[k].avatar:SetPos(scrw - 202, (scrh - 122) - 52 * k)

        draw.DrawText(v.ent:Name(), "FCore_Open Sans_18_300", scrw - 158, (scrh - 113) - 52 * k, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)

        if ply:VoiceVolume() > 0.05 then
            FCore.HUD.VCQueue.Players[k].lastVoice = SysTime()
        end
    end
end

hook.Add("PlayerStartVoice", "FCore::HUD::VCStart", FCore.HUD.StartVoice)
hook.Add("PlayerEndVoice", "FCore::HUD::VCEnd", FCore.HUD.EndVoice)
hook.Add("HUDPaint", "FCore::HUD::Draw", FCore.HUD.DrawVC)