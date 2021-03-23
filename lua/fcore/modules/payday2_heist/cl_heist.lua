FCore.Heist = {}
FCore.Heist.Display = false

function FCore.Heist.Create()
    FCore.Heist.Text = "   ///   POLICE ASSAULT IN PROGRESS"

    surface.SetFont("FCore_Bahnschrift_24_500")
    local tw = surface.GetTextSize(FCore.Heist.Text)
    local x = 300 + tw

    FCore.Heist.Derma = vgui.Create("DPanel")
    FCore.Heist.Derma:SetSize(300, 50)
    FCore.Heist.Derma:SetPos(ScrW() / 2 - 150, 8)
    FCore.Heist.Derma:SetVisible(false)

    FCore.Heist.Derma.Paint = function(self, w, h)
        if LocalPlayer():IsValid() then
            if x < 0 then
                x = 300 + tw
            end

            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0, math.abs(math.sin(CurTime() * 3) * 50)))

            draw.RoundedBox(0, 0, 0, 2, 4, Color(255, 255, 0))
            draw.RoundedBox(0, 0, 0, 4, 2, Color(255, 255, 0))

            draw.RoundedBox(0, 296, 0, 4, 2, Color(255, 255, 0))
            draw.RoundedBox(0, 298, 0, 2, 4, Color(255, 255, 0))

            draw.RoundedBox(0, 0, 46, 2, 4, Color(255, 255, 0))
            draw.RoundedBox(0, 0, 48, 4, 2, Color(255, 255, 0))

            draw.RoundedBox(0, 298, 46, 2, 4, Color(255, 255, 0))
            draw.RoundedBox(0, 296, 48, 4, 2, Color(255, 255, 0))

            if FCore.Heist.Display then
                draw.DrawText(FCore.Heist.Text, "FCore_Bahnschrift_24_500", x, 12, Color(255,255,0), TEXT_ALIGN_RIGHT)

                x = x - 0.5
            else
                x = 300 + tw
            end
        end
    end
end

function FCore.Heist.RunRaid()
    if !FCore.Heist.Display then
        if !FCore.Heist.Audio or !IsValid(FCore.Heist.Audio) or FCore.Heist.Audio:GetState() != 1 then
            sound.PlayURL("http://fizi.pw/files/payday2_raid.mp3", "noblock", function(snd)
                if IsValid(snd) then
                    snd:Play()
                    snd:SetVolume(0.1)
                    FCore.Heist.Audio = snd
                end
            end)
        end

        FCore.Heist.Derma:SetSize(0, 50)
        FCore.Heist.Derma:SetVisible(true)

        FCore.Heist.Derma:SizeTo(300, 50, 1, 3, -1, function()
            FCore.Heist.Display = true
        end)
    end
end

function FCore.Heist.StopRaid()
    if FCore.Heist.Display then
        if FCore.Heist.Audio and IsValid(FCore.Heist.Audio) then
            FCore.Heist.Audio:Stop()
        end

        FCore.Heist.Derma:SizeTo(0, 50, 1, 0, -1, function()
            FCore.Heist.Derma:SetVisible(false)
            FCore.Heist.Display = false
        end)
    end
end

FCore.Heist.Create()