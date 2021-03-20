function FCore.HUD.GetPos()
    return {
        x = FCore.HUD.Config.Margin.x,
        y = ScrH() - FCore.HUD.Config.Size.h - FCore.HUD.Config.Margin.y
    }
end

function FCore.HUD.Text(txt, length)
    if #txt > length then
        return string.Left(txt, length) .. "..."
    else
        return txt
    end
end

function FCore.HUD.AttachCurrency(value)
    return value .. " PLN"
end

function FCore.HUD.FormatMoney(value)
    if not value then return FCore.HUD.AttachCurrency("0") end

    if value >= 1e14 then return FCore.HUD.AttachCurrency(tostring(value)) end
    if value <= -1e14 then return "-" .. FCore.HUD.AttachCurrency(tostring(math.abs(value))) end

    local negative = value < 0

    value = tostring(math.abs(value))
    local dp = string.find(value, "%.") or #value + 1

    for i = dp - 4, 1, -3 do
        value = value:sub(1, i) .. "," .. value:sub(i + 1)
    end

    -- Make sure the amount is padded with zeroes
    if value[#value - 1] == "." then
        value = value .. "0"
    end

    return negative and "-" or "" and FCore.HUD.AttachCurrency(value)
end

function FCore.HUD.DrawBox(x, y, w, h, color, rtl, rtr, rbl, rbr)
    if rtl == nil then rtl = true end
    if rtr == nil then rtr = true end
    if rbl == nil then rbl = true end
    if rbr == nil then rbr = true end

    draw.RoundedBoxEx(6, x, y, w, h, color or FCore.HUD.Config.Colors.transparent, rtl, rtr, rbl, rbr)
end

function FCore.HUD.DrawBarHorizontal(x, y, w, h, color, text, font, textColor)
    surface.SetFont(font)
    local tw, th = surface.GetTextSize(text)

    local bar1 = {
        x = x,
        y = y,
        w = w / 2,
        h = h,
        color = color
    }

    local bar2 = {
        x = x + w / 2,
        y = y,
        w = w / 2,
        h = h,
        color = Color(color.r, color.g, color.b, color.a / 1.5)
    }

    FCore.HUD.DrawBox(bar1.x, bar1.y, bar1.w, bar1.h, bar1.color, true, false, true, false)
    FCore.HUD.DrawBox(bar2.x, bar2.y, bar2.w, bar2.h, bar2.color, false, true, false, true)

    draw.DrawText(text, font, bar1.x - tw / 2, bar2.h / 2 - th, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
end

function FCore.HUD.DrawBarVertical(x, y, w, h, color, text, font, textColor)
    surface.SetFont(font)
    local tw, th = surface.GetTextSize(text)

    local bar1 = {
        x = x,
        y = y,
        w = w,
        h = h / 2,
        color = color
    }

    local bar2 = {
        x = x,
        y = y + h / 2,
        w = w,
        h = h / 2,
        color = Color(color.r - 64, color.g - 64, color.b - 64, color.a)
    }

    FCore.HUD.DrawBox(bar1.x, bar1.y, bar1.w, bar1.h, color, true, false, true, false)
    FCore.HUD.DrawBox(bar2.x, bar2.y, bar2.w, bar2.h, color, false, true, false, true)

    draw.DrawText(text, font, bar1.x - tw / 2, bar2.h / 2 - th, textColor or FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
end

function FCore.HUD.DrawIconBox(x, y, icon, size, bgColor, color, offsetX, offsetY, iconSize)
    if !FCore.HUD.Config.Icons[icon] then return end
    if !iconSize then iconSize = size end

    FCore.HUD.DrawBox(x, y, size + 8, size + 8, bgColor)
    draw.DrawText(FCore.HUD.Config.Icons[icon].text, string.format("FCore_FontAwesome_%s_300", iconSize), x + 4 + offsetX + FCore.HUD.Config.Icons[icon].margin.x, y + 4 + FCore.HUD.Config.Icons[icon].margin.y + offsetY, color or FCore.HUD.Config.Colors.text, align or TEXT_ALIGN_LEFT)
end

function FCore.HUD.DrawIcon(x, y, icon, size, color, align, iconSize)
    if !FCore.HUD.Config.Icons[icon] then return end
    if !iconSize then iconSize = size end

    draw.DrawText(FCore.HUD.Config.Icons[icon].text, string.format("FCore_FontAwesome_%s_300", iconSize), x + 4 + FCore.HUD.Config.Icons[icon].margin.x, y + 4 + FCore.HUD.Config.Icons[icon].margin.y, color or FCore.HUD.Config.Colors.text, align or TEXT_ALIGN_LEFT)
end

function FCore.HUD.DrawNotify(x, y, icon, iconSize, text, font, color, align)
    if !icon or !text then return end
    if !FCore.HUD.Config.Icons[icon] then return end

    if !font then font = "FCore_Open Sans_18_300" end

    surface.SetFont(font)
    local tw, th = surface.GetTextSize(text)

    local bw = tw + 32 + iconSize + 8
    local bh = th + 16

    FCore.HUD.DrawBox(x, y - bh, bw, bh)
    FCore.HUD.DrawIcon(x + 8, y + 8, icon, iconSize, bgColor)
    draw.DrawText(text, font, x + 48, y - bw + bh / 2 - th / 2, color or FCore.HUD.Config.Colors.text, align or TEXT_ALIGN_LEFT)
end

function FCore.HUD.DrawInfo(x, y, icon, w, h, bgColor, color, align)
    if !icon or !text then return end
    if !FCore.HUD.Config.Icons[icon] then return end

    if !font then font = "FCore_Open Sans_18_300" end

    surface.SetFont(font)
    local tw, th = surface.GetTextSize(text)

    FCore.HUD.DrawBox(x, y, w, h)
    FCore.HUD.DrawIcon(x + 8, y + 8, icon, iconSize, bgColor)
    draw.DrawText(text, font, x + 48, y + bh / 2 - th / 2, color or FCore.HUD.Config.Colors.text, align or TEXT_ALIGN_LEFT)
end