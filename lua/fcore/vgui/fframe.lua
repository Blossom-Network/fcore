local PANEL = {}

function PANEL:Init()
    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(0, 0, 0, 0)

    self.TopBar = vgui.Create("DPanel", self)
    self.TopBar:SetTall(24)
    self.TopBar:DockPadding(4,0,4,0)
    self.TopBar:Dock(TOP)

    self.TopBar.CloseButton = vgui.Create("DButton", self.TopBar)
    self.TopBar.CloseButton:SetSize(16, 16)
    self.TopBar.CloseButton:Dock(RIGHT)
    self.TopBar.CloseButton:SetText("")
    self.TopBar.CloseButton.DoClick = function()
        self:Close()
    end

    function self.TopBar.CloseButton:Paint()
        draw.RoundedBox(4, 0, 4, 16, 16, FCore.Colors.red)
    end

    function self.TopBar:Paint(w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, FCore.Colors.secondary, true, true, false, false)
        draw.DrawText(self:GetParent():GetTitle(), "FCore_Open Sans_14_300", 8, 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
    end
end

function PANEL:ShowCloseButton(bShow)
    self.TopBar.CloseButton:SetVisible(bShow)
end

function PANEL:Paint(w, h)
    draw.RoundedBox( 4, 0, 0, w, h, FCore.Colors.main )
end

vgui.Register( "FCore.Frame", PANEL, "DFrame" )

concommand.Add("test_fframe", function()
    local panel = vgui.Create("FCore.Frame")
    panel:SetSize(ScrW() / 2, ScrH() / 2)
    panel:Center()
    panel:SetTitle("stachu")
    panel:ShowCloseButton(true)
    panel:MakePopup()
end)