local scrw = ScrW()
local scrh = ScrH()

hook.Add("HUDPaint", "FCore::Watermark", function()
    for i=0,1 do
        draw.DrawText("Blossom Network", "FCore_Open Sans_24_500", scrw - scrw / 2, 9 - i, Color( 0 + (255 * i), 0 + (255 * i), 0 + (255 * i), 255 ), TEXT_ALIGN_CENTER)
        draw.DrawText("development server", "FCore_Open Sans_14_500", scrw - scrw / 2, 29 - i, Color( 0 + (255 * i), 0 + (64 * i), 0 + (64 * i), 255 ), TEXT_ALIGN_CENTER)
    end
end)