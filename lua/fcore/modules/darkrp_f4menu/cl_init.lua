FCore.F4Menu = {}

FCore.F4Menu.Panels = {}
FCore.F4Menu.Instances = {}

function FCore.F4Menu:Desc(txt, font, width)
    surface.SetFont(font)
    txt = DarkRP.textWrap(txt, font, width)

    local _, txtheight = surface.GetTextSize(txt)
    
    return txt, width, txtheight
end

function FCore.F4Menu:AddPanel(name, panelname, panel, derived, order, icon)
    PrintTable(FCore.F4Menu.Panels)
    print(name, panelname, panel, derived, order)
    if !name or !panelname or !panel or !derived or !order or !icon then return end

    vgui.Register( panelname, panel, derived )
    table.insert(FCore.F4Menu.Panels, {
        name = name,
        panel = panelname,
        sortOrder = order,
        icon = icon
    })

    table.sort(FCore.F4Menu.Panels, function(a,b)
        return a.sortOrder < b.sortOrder
    end)
end

function FCore.F4Menu:CreatePanels()
    for _,v in ipairs(FCore.F4Menu.Panels) do
        FCore.F4Menu.Instances[v.name] = vgui.Create(v.panel, FCore.F4Menu.Menu)
        FCore.F4Menu.Instances[v.name]:Dock(FILL)

        FCore.F4Menu.Menu:AddMenuOption(v.name, FCore.F4Menu.Instances[v.name], v.icon)
    end
end

function FCore.F4Menu:Create()
    FCore.F4Menu.Instance = vgui.Create("FCore.Frame")
    FCore.F4Menu.Instance:SetSize(ScrW() / 1.25, ScrH() / 1.25)
    FCore.F4Menu.Instance:Center()
    FCore.F4Menu.Instance:SetTitle("ChillRP | F4 Menu")
    FCore.F4Menu.Instance:SetVisible(true)
    FCore.F4Menu.Instance:ShowCloseButton(true)

    FCore.F4Menu.Menu = vgui.Create("FCore.Menu", FCore.F4Menu.Instance)

    FCore.F4Menu.Menu:Dock(FILL)

    FCore.F4Menu:CreatePanels()

    gui.EnableScreenClicker(true)
end

function FCore.F4Menu:Remove()
    FCore.F4Menu.Instance:Close()

    gui.EnableScreenClicker(false)
end

hook.Add("ShowSpare2", "FCore::Test", function()
    if !FCore.F4Menu.Instance or !IsValid(FCore.F4Menu.Instance) then
        FCore.F4Menu:Create()
    else
        FCore.F4Menu:Remove()
    end
end)

function GAMEMODE:ShowSpare2() end