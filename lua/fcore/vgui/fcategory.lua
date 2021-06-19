local PANEL = {}

function PANEL:Init()
    self.list = vgui.Create("DPanelList", self)

    self.list:Dock(FILL)
    self.list:SetSpacing(8)
    self.list:EnableHorizontal(false)
    self.list:EnableVerticalScrollbar(false)

    self.list:SetPadding(8)

    self:SetContents(self.list)

    function self:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(FCore.Colors.secondary.r - 16, FCore.Colors.secondary.g - 16, FCore.Colors.secondary.b - 16))
    end

    self.Header:Remove()

    self.Header = vgui.Create("FCore.Button", self)
    self.Header:Dock( TOP )
    self.Header:SetColor(FCore.Colors.secondary)
    self.Header:SetTall(32)

    function self.Header:DoClick()
        self:GetParent():Toggle()
    end

    function self.Header:Paint(w, h)
        local bgColor = FCore.Colors.secondary;
    
        if self:IsHovered() then
            bgColor = Color(bgColor.r + 32, bgColor.g + 32, bgColor.b + 32)
        end
    
        draw.RoundedBoxEx(4, 0, 0, w, h, bgColor, true, true, false, false)
        draw.DrawText(self:GetText(), "FCore_Roboto_18_500", 6, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
    end
end

function PANEL:AddItem(item)
    self.list:AddItem(item)
end

vgui.Register("FCore.Category", PANEL, "DCollapsibleCategory")