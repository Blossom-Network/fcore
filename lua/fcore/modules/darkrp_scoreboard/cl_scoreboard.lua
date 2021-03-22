FCore.Scoreboard = {}
FCore.Scoreboard.Commands = {
    {
        text = "Slay",
        func = function(self) 
            RunConsoleCommand("fadmin", "slay", self.ply:Name())
        end,
        check = function() return LocalPlayer():IsAdmin() end
    },
    {
        text = "Kick",
        func = function(self) 
            RunConsoleCommand("fadmin", "kick", self.ply:Name())
        end,
        check = function() return LocalPlayer():IsAdmin() end
    },
    {
        text = "Goto",
        func = function(self) 
            RunConsoleCommand("fadmin", "goto", self.ply:Name())
        end,
        check = function() return LocalPlayer():IsAdmin() end
    },
    {
        text = "Bring",
        func = function(self) 
            RunConsoleCommand("fadmin", "bring", self.ply:Name())
        end,
        check = function() return LocalPlayer():IsAdmin() end
    }
}

function FCore.Scoreboard.Create()
    FCore.Scoreboard.Instance = vgui.Create("DFrame")
    FCore.Scoreboard.Instance:SetSize(ScrW() / 2.25, ScrW() / 2.5)
    FCore.Scoreboard.Instance:Center()
    FCore.Scoreboard.Instance:DockMargin(0, 0, 0, 0)
    FCore.Scoreboard.Instance:DockPadding(4, 4, 4, 4)
    FCore.Scoreboard.Instance:ShowCloseButton(false)
    FCore.Scoreboard.Instance:SetTitle("")

    function FCore.Scoreboard.Instance:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, FCore.HUD.Config.Colors.secondary)
    end

    FCore.Scoreboard.Instance.Header = vgui.Create("DPanel", FCore.Scoreboard.Instance)
    FCore.Scoreboard.Instance.Header:SetSize(FCore.Scoreboard.Instance:GetWide(), 64)
    FCore.Scoreboard.Instance.Header:Dock(TOP)

    function FCore.Scoreboard.Instance.Header:Paint(w, h)
        draw.DrawText("Blossom Network", "FCore_Open Sans_24_700", w / 2, 18, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    FCore.Scoreboard.Instance.List = vgui.Create("DScrollPanel", FCore.Scoreboard.Instance)
    FCore.Scoreboard.Instance.List:Dock(FILL)

    local sbar = FCore.Scoreboard.Instance.List:GetVBar()
    sbar:SetWide(4)
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125))
    end

    FCore.Scoreboard.Populate()
end

function FCore.Scoreboard.Remove()
    FCore.Scoreboard.Instance:Remove()
    FCore.Scoreboard.Instance = nil
end

function FCore.Scoreboard.Populate()
    FCore.Scoreboard.Instance.List:GetCanvas():Clear()

    local header = FCore.Scoreboard.Instance.List:Add("DPanel")
    local hw = ScrW() / 2.25

    header:SetSize(hw, 24)
    header:Dock(TOP)
    function header:Paint(w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(255, 255, 255, 2.5), true, true, false, false)
    end

    header.Avatar = vgui.Create("DPanel", header)
    header.Avatar:SetSize(48, 24)
    header.Avatar:Dock(LEFT)

    function header.Avatar:Paint(w, h)
        draw.DrawText("Avatar", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    hw = hw - 48

    header.Name = vgui.Create("DPanel", header)
    header.Name:SetSize(hw / 3, 24)
    header.Name:Dock(LEFT)

    function header.Name:Paint(w, h)
        draw.DrawText("Nick", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Job = vgui.Create("DPanel", header)
    header.Job:SetSize(hw / 3, 24)
    header.Job:Dock(LEFT)

    function header.Job:Paint(w, h)
        draw.DrawText("Praca", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    hw = hw - ((hw / 3) * 2)

    header.Kills = vgui.Create("DPanel", header)
    header.Kills:SetSize(hw / 3, 24)
    header.Kills:Dock(LEFT)

    function header.Kills:Paint(w, h)
        draw.DrawText("Fragi", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Deaths = vgui.Create("DPanel", header)
    header.Deaths:SetSize(hw / 3, 24)
    header.Deaths:Dock(LEFT)
    
    function header.Deaths:Paint(w, h)
        draw.DrawText("Śmierci", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Ping = vgui.Create("DPanel", header)
    header.Ping:SetSize(hw / 3, 24)
    header.Ping:Dock(LEFT)
    
    function header.Ping:Paint(w, h)
        draw.DrawText("Ping", "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
    end

    for k,ply in ipairs(player.GetAll()) do
        local plyPanel = FCore.Scoreboard.Instance.List:Add("DPanel")
        local pw = ScrW() / 2.25

        plyPanel:SetSize(FCore.Scoreboard.Instance.List:GetWide() / 2, 48)
        plyPanel:Dock(TOP)

        function plyPanel:Paint(w, h)
            if !IsValid(ply) then self:Remove() end

            if k % 2 == 1 then
                surface.SetDrawColor(255, 255, 255, 5)
                surface.DrawRect(0, 0, w, h)
            end
        end

        plyPanel.Commands = vgui.Create("DPanel", plyPanel)
        plyPanel.Commands:SetSize(ScrW() / 2.25, 32)
        plyPanel.Commands:Dock(BOTTOM)
        plyPanel.Commands:SetVisible(false)
        plyPanel.Commands:DockPadding(4, 4, 4, 4)
        function plyPanel.Commands:Paint(w, h)
            surface.SetDrawColor(Color(42,42,42))

            surface.DrawRect(0, 0, w, h)
        end

        for _,v in ipairs(FCore.Scoreboard.Commands) do
            if v.check() then
                local command = vgui.Create("DButton", plyPanel.Commands)
                command.ply = ply
                command:SetText(v.text)
                command:SetTextColor(Color(255,255,255))
                command:Dock(LEFT)
                command.DoClick = v.func

                function command:Paint(w, h)
                    surface.SetDrawColor(Color(64,64,64))
        
                    surface.DrawRect(0, 0, w, h)
                end
            end
        end

        plyPanel.Avatar = vgui.Create("DPanel", plyPanel)
        plyPanel.Avatar:SetSize(48, 48)
        plyPanel.Avatar:DockPadding(4, 4, 4, 4)
        plyPanel.Avatar:Dock(LEFT)
        function plyPanel.Avatar:Paint() return end

        plyPanel.Avatar.Image = vgui.Create("AvatarImage", plyPanel.Avatar)
        plyPanel.Avatar.Image:Dock(FILL)
        plyPanel.Avatar.Image:SetPlayer(ply, 184)

        pw = pw - 48

        plyPanel.Name = vgui.Create("DPanel", plyPanel)
        plyPanel.Name:SetSize(pw / 3, 24)
        plyPanel.Name:Dock(LEFT)
    
        function plyPanel.Name:Paint(w, h)
            draw.DrawText(ply:Name(), "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        plyPanel.Job = vgui.Create("DPanel", plyPanel)
        plyPanel.Job:SetSize(pw / 3, 24)
        plyPanel.Job:Dock(LEFT)
    
        function plyPanel.Job:Paint(w, h)
            draw.DrawText(ply:getDarkRPVar("job"), "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        pw = pw - ((pw / 3) * 2)
    
        plyPanel.Kills = vgui.Create("DPanel", plyPanel)
        plyPanel.Kills:SetSize(pw / 3, 24)
        plyPanel.Kills:Dock(LEFT)
    
        function plyPanel.Kills:Paint(w, h)
            draw.DrawText(ply:Frags(), "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        plyPanel.Deaths = vgui.Create("DPanel", plyPanel)
        plyPanel.Deaths:SetSize(pw / 3, 24)
        plyPanel.Deaths:Dock(LEFT)
        
        function plyPanel.Deaths:Paint(w, h)
            draw.DrawText(ply:Deaths(), "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        plyPanel.Ping = vgui.Create("DPanel", plyPanel)
        plyPanel.Ping:SetSize(pw / 3, 24)
        plyPanel.Ping:Dock(LEFT)
        
        function plyPanel.Ping:Paint(w, h)
            draw.DrawText(ply:Ping(), "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.HUD.Config.Colors.text, TEXT_ALIGN_CENTER)
        end

        /*
            Yes, I'm retarded.
        */
        plyPanel.Click = vgui.Create("DButton", plyPanel)
        plyPanel.Click:SetPos(0,0)
        plyPanel.Click:SetSize(ScrW(), plyPanel:GetTall())
        plyPanel:SetText("")
        plyPanel.Click.Paint = function() end
        function plyPanel.Click.DoClick()
            if !plyPanel.Commands:IsVisible() then
                plyPanel:SetSize(plyPanel:GetWide(), plyPanel:GetTall() + 32)
                plyPanel.Commands:SetVisible(true)
            else
                plyPanel:SetSize(plyPanel:GetWide(), plyPanel:GetTall() - 32)
                plyPanel.Commands:SetVisible(false)
            end
        end
    end
end

function GAMEMODE.ScoreboardShow()
    FCore.Scoreboard.Create()

    gui.EnableScreenClicker(true)
end

function GAMEMODE.ScoreboardHide()
    FCore.Scoreboard.Remove()

    gui.EnableScreenClicker(false)
end

hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
hook.Remove("ScoreboardHide", "FAdmin_scoreboard")