FCore.Guayando = {}

function FCore.Guayando.Stage1()
    hook.Add("HUDPaint", "FCore::Guayando", function()
        if FCore.Guayando.Music:GetState() != 1 then FCore.Guayando.Stop() end
        if FCore.Guayando.Music:GetTime() > 3 then
            local fft = {}
            FCore.Guayando.Music:FFT(fft, FFT_16384)

            local barWidth = ScrW() / 192

            for i=1,192 do
                local color = HSVToColor((360 / 192) * i, 1, 1)

                surface.SetDrawColor(color)
                surface.DrawRect(ScrW() - barWidth * (i - 1), ScrH() + 2 - ScrH() * fft[i], barWidth, ScrH() * fft[i])
                surface.DrawRect(barWidth * (i - 1), 0, barWidth, ScrH() * fft[i])
            end
        elseif FCore.Guayando.Music:GetTime() > 1 then
            surface.SetDrawColor(0,0,0,200)
            surface.DrawRect(0, 0, ScrW(), ScrH())
            draw.DrawText("Guayando", "FCore_Open Sans_72_700", ScrW() - ScrW() / 2, ScrH() / 2 - 34 + math.sin(CurTime() * 4) * 16, Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER)
            draw.DrawText("Guayando", "FCore_Open Sans_72_700", ScrW() - ScrW() / 2, ScrH() / 2 - 36 + math.sin(CurTime() * 4) * 16, HSVToColor(CurTime() * 8 % 360, 1, 1), TEXT_ALIGN_CENTER)
        end
    end)
end

function FCore.Guayando.Stop()
    hook.Remove("HUDPaint", "FCore::Guayando")
    FCore.Guayando.Music:Stop()
end

function FCore.Guayando.Start()
    sound.PlayURL("https://fizi.pw/files/guayando.mp3", "noblock", function(snd, errCode, err)
        if snd and IsValid(snd) then
            FCore.Guayando.Music = snd

            FCore.Guayando.Stage1()
        end
    end)
end

net.Receive("FCore::Guayando", FCore.Guayando.Start)