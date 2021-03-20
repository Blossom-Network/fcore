local scrw = ScrW()
local scrh = ScrH()

hook.Add("HUDPaint", "FCore::Watermark", function()
    draw.RoundedBoxEx(8, scrw / 2 - 100, 0, 200, 47.5, FCore.HUD.Config.Colors.secondary, false, false, true, true)

    draw.DrawText("Blossom Network", "FCore_Open Sans_24_500", scrw - scrw / 2, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    draw.DrawText("development server", "FCore_Open Sans_14_500", scrw - scrw / 2, 25, Color( 255, 64, 64, 255 ), TEXT_ALIGN_CENTER)
end)