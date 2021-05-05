FCore.F4Menu = {}

function FCore.F4Menu:Create()
    FCore.F4Menu.Instance = vgui.Create("FCore.Frame")
    FCore.F4Menu.Instance:SetSize(ScrW() / 2, ScrH() / 2)
    FCore.F4Menu.Instance:Center()
    FCore.F4Menu.Instance:SetTitle("F4 Menu")
    FCore.F4Menu.Instance:SetVisible(false)
    FCore.F4Menu.Instance:ShowCloseButton(false)
end

hook.Add("ShowSpare2", "FCore::Test", function()
    if !FCore.F4Menu.Instance or !IsValid(FCore.F4Menu.Instance) then
        FCore.F4Menu:Create()
    end

    if FCore.F4Menu.Instance:IsVisible() then
        FCore.F4Menu.Instance:SetVisible(false)

        gui.EnableScreenClicker(false)
    else
        FCore.F4Menu.Instance:SetVisible(true)

        gui.EnableScreenClicker(true)
    end
end)

// hello, i'm stupid
function GAMEMODE:ShowSpare2() end