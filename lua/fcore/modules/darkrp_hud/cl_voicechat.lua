FCore.HUD.VCQueue = {}
FCore.HUD.VCQueue.Players = {}

local defaultProperties = {
    x = ScrW() + 100,
    y = ScrH() - 48,
    w = 200,
    h = 48,
    marginX = 8,
    marginY = 8
}

function FCore.HUD.VCQueue.AddBar(ply)
    g_VoicePanelList:SetVisible(false)

    for k,v in ipairs(FCore.HUD.VCQueue.Players) do
        if v.ent == ply then
            return false
        end
    end

    local y = (ScrH() - defaultProperties.h) - ((#FCore.HUD.VCQueue.Players - 1) * defaultProperties.h) - (#FCore.HUD.VCQueue.Players * defaultProperties.marginY) - 58

    table.insert(FCore.HUD.VCQueue.Players, {ent = ply, lastVoice = 0, x = defaultProperties.x, y = y, w = defaultProperties.w, h = defaultProperties.h, active = true})
end

function FCore.HUD.VCQueue.RemoveBar(ply)
    g_VoicePanelList:SetVisible(false)

    for k,v in ipairs(FCore.HUD.VCQueue.Players) do
        if v.ent == ply then
            FCore.HUD.VCQueue.Players[k].active = false
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
        if !IsValid(v.ent) then table.remove(k, FCore.HUD.VCQueue.Players) end

        v.x = Lerp( FrameTime() * 10, v.x, v.active and ScrW() - v.w - defaultProperties.marginX or ScrW() + defaultProperties.x )
        v.y = Lerp( FrameTime() * 10, v.y, (ScrH() - v.h) - ((k - 1) * v.h) - (k * defaultProperties.marginY) )

        local ply = v.ent
        local col = team.GetColor(v.ent:Team())

        if !FCore.HUD.VCQueue.Players[k].avatar then
            FCore.HUD.VCQueue.Players[k].avatar = vgui.Create("AvatarImage")
            FCore.HUD.VCQueue.Players[k].avatar:SetSize(36, 36)
            FCore.HUD.VCQueue.Players[k].avatar:SetPlayer(v.ent, 184)
            FCore.HUD.VCQueue.Players[k].avatar:SetPaintedManually(true)
            FCore.HUD.VCQueue.Players[k].avatar:ParentToHUD()
        end

        draw.RoundedBox(4, v.x - 8, v.y - 128, 200, 48, FCore.Colors.secondary)
        draw.RoundedBox(4, v.x - 8, v.y - 82, 200, 3, Color(col.r,col.g,col.b,Lerp((SysTime() - v.lastVoice) * 4, 255, 0)))

        draw.RoundedBox(4, v.x - 4, v.y - 124, 40, 40, FCore.Colors.main)
        FCore.HUD.VCQueue.Players[k].avatar:PaintManual()
        FCore.HUD.VCQueue.Players[k].avatar:SetPos(v.x - 2, v.y - 121)

        draw.DrawText(v.ent:Name(), "FCore_Open Sans_18_300", v.x + 42, v.y - 113, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)

        if ply:VoiceVolume() > 0.05 then
            FCore.HUD.VCQueue.Players[k].lastVoice = SysTime()
        end

        if v.x > ScrW() and v.active == false then
            table.remove(FCore.HUD.VCQueue.Players, k)
        end
    end
end

hook.Add("PlayerStartVoice", "FCore::HUD::VCStart", FCore.HUD.StartVoice)
hook.Add("PlayerEndVoice", "FCore::HUD::VCEnd", FCore.HUD.EndVoice)
hook.Add("HUDPaint", "FCore::HUD::Draw", FCore.HUD.DrawVC)