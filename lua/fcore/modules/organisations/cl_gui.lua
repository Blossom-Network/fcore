FCore.Organisations = FCore.Organisations or {}

function FCore.Organisations.CreateGUI()
    FCore.Organisations.GUI = vgui.Create("FCore.Frame")
    FCore.Organisations.GUI.Menu = vgui.Create("FCore.Menu", FCore.Organisations.GUI)

    FCore.Organisations.GUI.Main = vgui.Create("FCore.Panel", FCore.Menu)
    FCore.Organisations.GUI.Stats = vgui.Create("FCore.Panel", FCore.Menu)
    FCore.Organisations.GUI.Members = vgui.Create("FCore.Panel", FCore.Menu)
    FCore.Organisations.GUI.Upgrades = vgui.Create("FCore.Panel", FCore.Menu)
    FCore.Organisations.GUI.Settings = vgui.Create("FCore.Panel", FCore.Menu)

    FCore.Organisations.GUI:SetSize(ScrW() / 1.5, ScrH() / 1.5)
    FCore.Organisations.GUI:Center()
    FCore.Organisations.GUI:SetTitle("Organizacje")
    FCore.Organisations.GUI:ShowCloseButton(true)
    FCore.Organisations.GUI:MakePopup()

    FCore.Organisations.GUI.Menu:Dock(FILL)

    FCore.Organisations.GUI.Menu:AddMenuOption("Ogólne", FCore.Organisations.GUI.Main)
    FCore.Organisations.GUI.Menu:AddMenuOption("Statystyki", FCore.Organisations.GUI.Stats)
    FCore.Organisations.GUI.Menu:AddMenuOption("Członkowie", FCore.Organisations.GUI.Members)
    FCore.Organisations.GUI.Menu:AddMenuOption("Ulepszenia", FCore.Organisations.GUI.Upgrades)
    FCore.Organisations.GUI.Menu:AddMenuOption("Ustawienia", FCore.Organisations.GUI.Settings)
end

concommand.Add("test_gui", FCore.Organisations.CreateGUI)