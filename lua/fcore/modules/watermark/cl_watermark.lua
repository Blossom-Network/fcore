hook.Add("HUDPaint", "FCore::Watermark", function()
    draw.RoundedBox(4, 8, 8, 100, 24, FCore.HUD.Config.Colors.secondary)

    draw.DrawText(utf8.char(0xf126), "FCore_FontAwesome_14_500", 16, 13, FCore.HUD.Config.Colors.white, TEXT_ALIGN_LEFT)
    draw.DrawText("fcore/main", "FCore_Open Sans_14_500", 62, 12, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
end)