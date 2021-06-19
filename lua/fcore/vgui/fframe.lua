local PANEL = {}

function PANEL:Init()
    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(0, 0, 0, 0)

    self.TopBar = vgui.Create("DPanel", self)
    self.TopBar:SetTall(32)
    self.TopBar:DockPadding(6,0,0,0)
    self.TopBar:Dock(TOP)

    self.TopBar.CloseButton = vgui.Create("DButton", self.TopBar)
    self.TopBar.CloseButton:SetSize(32, 32)
    self.TopBar.CloseButton:Dock(RIGHT)
    self.TopBar.CloseButton:SetText("")
    self.TopBar.CloseButton.DoClick = function()
        self:Close()
        gui.EnableScreenClicker(false)
    end

    function self.TopBar.CloseButton:Paint()
        local col = Color(255, 255, 255)

        if self:IsHovered() then
            col = Color(220, 220, 220)
        end
        draw.DrawText(utf8.char(0xf00d), "FCore_FontAwesome_18_300", 8, 6, col)
    end

    function self.TopBar:Paint(w, h)
        draw.RoundedBoxEx(0, 0, 0, w, h, FCore.Colors.secondary)
        draw.DrawText(self:GetParent():GetTitle(), "FCore_Roboto_18_300", 8, 7, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
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