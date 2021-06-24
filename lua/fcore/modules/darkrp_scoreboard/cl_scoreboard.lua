FCore.Scoreboard = {}
FCore.Scoreboard.Players = {}

local function getKDA(ent)
    if ent:Deaths() <= 0 then return ent:Frags() else return ent:Frags() / ent:Deaths() end
end

function FCore.Scoreboard.Draw()
    FCore.Scoreboard.Instance = vgui.Create("DFrame")
    FCore.Scoreboard.Instance:SetSize(ScrW() / 2, ScrH() / 1.5)
    FCore.Scoreboard.Instance:Center()
    FCore.Scoreboard.Instance:SetTitle("")
    FCore.Scoreboard.Instance:ShowCloseButton()
    FCore.Scoreboard.Instance:DockMargin(0,0,0,0)
    FCore.Scoreboard.Instance:SetVisible(false)

    function FCore.Scoreboard.Instance:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, FCore.Colors.secondary)
        draw.RoundedBox(4, 8, 8, w - 16, h - 16, FCore.Colors.main)
    end

    FCore.Scoreboard.Instance.Header = vgui.Create("DPanel", FCore.Scoreboard.Instance)
    FCore.Scoreboard.Instance.Header:SetTall(64)
    FCore.Scoreboard.Instance.Header:Dock(TOP)
    function FCore.Scoreboard.Instance.Header:Paint(w, h)
        draw.RoundedBox(4, w / 2 - (w / 4) / 2, 8, w / 4, h - 16, FCore.Colors.secondary)
        draw.DrawText("ChillRP", "FCore_Open Sans_36_700", w - w / 2, 14, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    FCore.Scoreboard.Instance:DockPadding(8,0,8,8)

    local header = vgui.Create("DPanel", FCore.Scoreboard.Instance)
    local hw = ScrW() / 2

    header:SetSize(hw, 48)
    header:Dock(TOP)
    function header:Paint(w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(0, 0, 0, 50), true, true, false, false)
    end

    header.Name = vgui.Create("DPanel", header)
    header.Name:SetSize(hw / 5, 48)
    header.Name:Dock(LEFT)

    function header.Name:Paint(w, h)
        draw.DrawText("Nick", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Job = vgui.Create("DPanel", header)
    header.Job:SetSize(hw / 6, 48)
    header.Job:Dock(LEFT)

    function header.Job:Paint(w, h)
        draw.DrawText("Praca", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Rank = vgui.Create("DPanel", header)
    header.Rank:SetSize(hw / 6, 48)
    header.Rank:Dock(LEFT)

    function header.Rank:Paint(w, h)
        draw.DrawText("Ranga", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    hw = hw - ((hw / 6) * 2)

    header.Ping = vgui.Create("DPanel", header)
    header.Ping:SetSize(hw / 6, 48)
    header.Ping:Dock(RIGHT)
    
    function header.Ping:Paint(w, h)
        draw.DrawText("Ping", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.KDA = vgui.Create("DPanel", header)
    header.KDA:SetSize(hw / 6, 48)
    header.KDA:Dock(RIGHT)
    
    function header.KDA:Paint(w, h)
        draw.DrawText("KDR", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Deaths = vgui.Create("DPanel", header)
    header.Deaths:SetSize(hw / 6, 48)
    header.Deaths:Dock(RIGHT)
    
    function header.Deaths:Paint(w, h)
        draw.DrawText("Śmierci", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end

    header.Kills = vgui.Create("DPanel", header)
    header.Kills:SetSize(hw / 6, 48)
    header.Kills:Dock(RIGHT)

    function header.Kills:Paint(w, h)
        draw.DrawText("Fragi", "FCore_Open Sans_18_700", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
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
end

function FCore.Scoreboard.GetPlayers()
    for _,v in ipairs(player.GetAll()) do
        table.insert(FCore.Scoreboard.Players, {
            name = v:Name(),
            job = v:getDarkRPVar("job"),
            kills = v:Frags(),
            deaths = v:Deaths(),
            kda = math.Round(getKDA(v), 2),
            ping = v:Ping(),
            usergroup = v:GetUserGroup(),
            instance = v
        })
    end

    FCore.Scoreboard.Instance.List:GetCanvas():Clear()

    local hw = ScrW() / 2

    for k,ply in ipairs(FCore.Scoreboard.Players) do
        local plyPanel = FCore.Scoreboard.Instance.List:Add("DPanel")

        plyPanel:SetSize(FCore.Scoreboard.Instance.List:GetWide() / 2, 48)
        plyPanel:Dock(TOP)

        hw = ScrW() / 2

        function plyPanel:Paint(w, h)
            if k % 2 == 0 then
                surface.SetDrawColor(0, 0, 0, 50)
                surface.DrawRect(0, 0, w, h)
            else
                surface.SetDrawColor(0, 0, 0, 25)
                surface.DrawRect(0, 0, w, h)
            end
        end

        plyPanel.Name = vgui.Create("DPanel", plyPanel)
        plyPanel.Name:SetSize(hw / 5, 48)
        plyPanel.Name:Dock(LEFT)
    
        function plyPanel.Name:Paint(w, h)
            draw.DrawText(ply.name, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        plyPanel.Job = vgui.Create("DPanel", plyPanel)
        plyPanel.Job:SetSize(hw / 6, 48)
        plyPanel.Job:Dock(LEFT)
    
        function plyPanel.Job:Paint(w, h)
            draw.DrawText(ply.job, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end

        plyPanel.Rank = vgui.Create("DPanel", plyPanel)
        plyPanel.Rank:SetSize(hw / 6, 48)
        plyPanel.Rank:Dock(LEFT)
    
        function plyPanel.Rank:Paint(w, h)
            draw.DrawText(ply.usergroup, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    
        hw = hw - ((hw / 6) * 2)
    
        plyPanel.Ping = vgui.Create("DPanel", plyPanel)
        plyPanel.Ping:SetSize(hw / 6, 48)
        plyPanel.Ping:Dock(RIGHT)
        
        function plyPanel.Ping:Paint(w, h)
            draw.DrawText(ply.ping, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end

        plyPanel.kda = vgui.Create("DPanel", plyPanel)
        plyPanel.kda:SetSize(hw / 6, 48)
        plyPanel.kda:Dock(RIGHT)
        
        function plyPanel.kda:Paint(w, h)
            draw.DrawText(ply.kda, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end

        plyPanel.Deaths = vgui.Create("DPanel", plyPanel)
        plyPanel.Deaths:SetSize(hw / 6, 48)
        plyPanel.Deaths:Dock(RIGHT)
        
        function plyPanel.Deaths:Paint(w, h)
            draw.DrawText(ply.deaths, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end

        plyPanel.Kills = vgui.Create("DPanel", plyPanel)
        plyPanel.Kills:SetSize(hw / 6, 48)
        plyPanel.Kills:Dock(RIGHT)
    
        function plyPanel.Kills:Paint(w, h)
            draw.DrawText(ply.kills, "FCore_Open Sans_18_300", w - w / 2, h - h / 2 - 9, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end
end

function FCore.Scoreboard.ClearPlayers()
    FCore.Scoreboard.Players = {}
end

function FCore.Scoreboard.Refresh()
    timer.Simple(0.1, function()
        FCore.Scoreboard.Players = {}

        FCore.Scoreboard.GetPlayers()
    end)
end

function GAMEMODE.ScoreboardShow()
    FCore.Scoreboard.GetPlayers()

    FCore.Scoreboard.Instance:SetVisible(true)
    gui.EnableScreenClicker(true)
end

function GAMEMODE.ScoreboardHide()
    FCore.Scoreboard.Instance:SetVisible(false)
    gui.EnableScreenClicker(false)

    FCore.Scoreboard.ClearPlayers()
end

hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
hook.Remove("ScoreboardHide", "FAdmin_scoreboard")

FCore.Scoreboard.Draw()