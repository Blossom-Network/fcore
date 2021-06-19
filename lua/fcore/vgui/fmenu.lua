local PANEL = {}

function PANEL:Init()
    self.menus = {}
    self.currentview = nil;

    self:DockMargin(0, 0, 0, 0)
    self:DockPadding(0, 0, 0, 0)

    self.MenuBar = vgui.Create("DPanel", self)
    self.MenuBar:SetWide(144)
    self.MenuBar:Dock(LEFT)

    self.MenuPanel = vgui.Create("DPanel", self)
    self.MenuPanel:DockMargin(8,4,8,4)
    self.MenuPanel:Dock(FILL)

    self.MenuHold = vgui.Create("DPanel")
    self.MenuHold:SetSize(0,0)
    self.MenuHold:SetVisible(false)

    function self.MenuBar:Paint(w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(FCore.Colors.secondary.r - 16, FCore.Colors.secondary.g - 16, FCore.Colors.secondary.b - 16))
    end
    function self.MenuPanel:Paint(w, h) end
end

function PANEL:AddMenuOption(name, panel, icon)
    panel:SetParent(self.MenuHold)
    panel:SetSize(self.MenuPanel:GetWide(), self.MenuPanel:GetTall())
    panel:SetPos(0,0)

    self.menus[name] = panel;

    self.MenuPanel[name] = vgui.Create("FCore.Button", self.MenuBar)
    self.MenuPanel[name]:SetText(name)
    self.MenuPanel[name]:SetColor(Color(64, 64, 64))
    self.MenuPanel[name]:SetTall(36)

    if icon then
        self.MenuPanel[name]:SetIcon(icon)
    end

    self.MenuPanel[name]:Dock(TOP)

    self.MenuPanel[name].DoClick = function()
        self:ChangePanel(panel)
    end

    if self.currentview == nil then
        self:ChangePanel(panel);
    end
end

function PANEL:ChangePanel(panel)
    self.currentview = panel;

    for _,v in pairs(self.menus) do
        v:SetParent(self.MenuHold)
        v:SetVisible(false)
        v:Dock(FILL)
    end

    panel:SetParent(self.MenuPanel)
    panel:SetVisible(true)
    panel:Dock(FILL)
end

function PANEL:Paint(w, h)
    draw.RoundedBox( 4, 0, 0, w, h, FCore.Colors.main )
end

vgui.Register( "FCore.Menu", PANEL, "DPanel" )

concommand.Add("test_fmenu", function()
    local panel = vgui.Create("FCore.Frame")
    panel:SetSize(ScrW() / 1.5, ScrH() / 1.5)
    panel:Center()
    panel:SetTitle("stachu")
    panel:ShowCloseButton(true)
    panel:MakePopup()

    local btn = vgui.Create("FCore.Button")

    local menu = vgui.Create("FCore.Menu", panel)
    menu:Dock(FILL)
    menu:AddMenuOption("Home", btn, 0xf0c9)
end)