local PANEL = {}

function PANEL:Init()
    self.bgColor = Color(0,0,0)

    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(0, 0, 0, 0)
    self:SetTextColor(Color(0,0,0,0))

    function self:Paint(w, h)
        local bgColor = self.bgColor;

        if self:IsHovered() then
            draw.RoundedBoxEx(0, 0, 0, w, h, Color(255, 255, 255, 15))
        end

        if self.icon then
            draw.DrawText(utf8.char(self.icon), "FCore_FontAwesome_14_300", 8, h / 2 - 6, Color( 255, 255, 255, 255), TEXT_ALIGN_LEFT)
        end

        draw.DrawText(self:GetText(), "FCore_Roboto_14_300", w - 8, h / 2 - 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT)
    end
end

function PANEL:SetIcon(unicode)
    if unicode then
        self.icon = unicode
    end
end

function PANEL:SetColor(color)
    self.bgColor = color;
end

vgui.Register( "FCore.Button", PANEL, "DButton" )

concommand.Add("test_fbutton", function()
    local panel = vgui.Create("FCore.Frame")
    panel:SetSize(ScrW() / 2, ScrH() / 2)
    panel:Center()
    panel:SetTitle("stachu")
    panel:ShowCloseButton(true)
    panel:MakePopup()

    local dbutton = vgui.Create("FCore.Button", panel)
    dbutton:SetColor(Color(64,64,64))
    dbutton:SetSize(48,48)
    dbutton:Dock(TOP)
end)