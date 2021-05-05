local PANEL = {}

function PANEL:Init()
    self.bgColor = Color(0,0,0)

    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(0, 0, 0, 0)
    self:SetTextColor(Color(0,0,0,0))

    function self:Paint(w, h)
        local bgColor = self.bgColor;

        if self:IsHovered() then
            bgColor = Color(bgColor.r + 32, bgColor.g + 32, bgColor.b + 32)
        end

        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        draw.DrawText(self:GetText(), "FCore_Open Sans_14_300", w - w / 2, h / 2 - 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    end
end


function PANEL:SetColor(color)
    self.bgColor = color;
end

function PANEL:Paint(w, h)
    draw.RoundedBox( 4, 0, 0, w, h, FCore.Colors.main )
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