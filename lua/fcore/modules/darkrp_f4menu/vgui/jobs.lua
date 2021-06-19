/*
    Job Modal
*/

local PANEL = {}

local function textwrap(txt, font, width)
    surface.SetFont(font)
    txt = DarkRP.textWrap(txt, font, width)

    local _, txtheight = surface.GetTextSize(txt)
    
    return txt, width, txtheight
end

function PANEL:Init()
    self.data = {}

    self:SetSize(ScrW(), ScrH())
    self:DockPadding(0,0,0,0)
    self:DockMargin(0,0,0,0)
    self:ShowCloseButton(false)
    self:SetTitle(" ")
    self:MakePopup()

    self.container = vgui.Create("FCore.Panel", self)
    self.container:SetSize(500, 400)
    self.container:Center()
    self.container:DockPadding(8,8,8,8)

    self.jobName = vgui.Create("FCore.Panel", self.container)
    self.jobName:SetTall(40)
    self.jobName:Dock(TOP)
    self.jobName:DockMargin(0, 0, 0, 8)
    self.jobName.Paint = function(_, w, h)
        if self.data.name then
            draw.RoundedBox(4, (w - w / 2) / 2, 0, w / 2, h, FCore.Colors.secondary)
            draw.DrawText(self.data.name, "FCore_Open Sans_24_700", w - w / 2, 8, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self.jobHeader = vgui.Create("FCore.Panel", self.container)
    self.jobHeader:SetTall(24)
    self.jobHeader:Dock(TOP)
    self.jobHeader.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, 0, 66, 32, FCore.Colors.secondary)
        draw.DrawText(utf8.char(0xf007), "FCore_FontAwesome_18_500", 8, 3, FCore.Colors.text)
        draw.DrawText("Opis", "FCore_Open Sans_18_700", 26, 3, FCore.Colors.text)
    end

    self.jobDescription = vgui.Create("DLabel", self.container)
    self.jobDescription:Dock(TOP)
    self.jobDescription:SetFont("FCore_Open Sans_18_500")

    self.weaponsHeader = vgui.Create("FCore.Panel", self.container)
    self.weaponsHeader:SetTall(24)
    self.weaponsHeader:Dock(TOP)
    self.weaponsHeader:DockMargin(0, 0, 0, 4)
    self.weaponsHeader.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, 0, 112, 32, FCore.Colors.secondary)
        draw.DrawText(utf8.char(0xf0b1), "FCore_FontAwesome_18_500", 8, 4, FCore.Colors.text)
        draw.DrawText("Przedmioty", "FCore_Open Sans_18_700", 30, 3, FCore.Colors.text)
    end

    self.jobWeapons = vgui.Create("DLabel", self.container)
    self.jobWeapons:Dock(TOP)
    self.jobWeapons:SetFont("FCore_Open Sans_18_500")
    self.jobWeapons:SetText(" ")

    self.becomeBtn = vgui.Create("FCore.Button", self.container)
    self.becomeBtn:Dock(BOTTOM)
    self.becomeBtn:SetText(" ")
    self.becomeBtn:SetTall(40)
    self.becomeBtn.Paint = function(_, w, h)
        if _:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(FCore.Colors.secondary.r + 8, FCore.Colors.secondary.g + 8, FCore.Colors.secondary.b + 8))
        else
            draw.RoundedBox(0, 0, 0, w, h, FCore.Colors.secondary)
        end

        draw.DrawText("Zmień Pracę", "FCore_Open Sans_18_700", w - w / 2, 10, FCore.Colors.text, TEXT_ALIGN_CENTER)
    end
    
    function self.container:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, FCore.Colors.main)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
end

function PANEL:SetInfo(tbl)
    self.data = tbl

    local desc, jw, jh = textwrap(self.data.description, "FCore_Open Sans_18_500", 484)
    self.jobDescription:SetText(desc)
    self.jobDescription:SetTall(jh + 16)

    if #self.data.weapons > 0 then
        local wpns = ""
        for _,v in ipairs(self.data.weapons) do
            local weaponInfo = weapons.Get(v)
            if weaponInfo and weaponInfo.PrintName then
                wpns = wpns .. weaponInfo.PrintName .. "\n"
            else
                wpns = wpns .. v .. "\n"
            end
        end

        local wpns, ww, wh = textwrap(wpns, "FCore_Open Sans_18_500", 484)
        self.jobWeapons:SetText(wpns)
        self.jobWeapons:SetTall(wh)
    else
        self.weaponsHeader:Remove()
    end

    self.becomeBtn.DoClick = function(_)
        if self.data.vote or self.data.RequiresVote and self.data.RequiresVote(LocalPlayer(), job.team) then
            RunConsoleCommand("darkrp", "vote" .. self.data.command)
        else
            RunConsoleCommand("darkrp", self.data.command)
        end

        self:Remove()
        FCore.F4Menu:Remove()
    end
end

vgui.Register("fcore::f4::jobs::modal", PANEL, "DFrame")

/*
    Job Panel
*/

PANEL = {}

function PANEL:SetInfo(tbl)
    self.data = tbl
    self.data.players = 0

    for _,ply in ipairs(player.GetAll()) do
        if self.data.jobId == LocalPlayer():Team() then
            self.data.players = self.data.players + 1
        end
    end

    if istable(tbl.model) then
        self.modelImage:SetModel(tbl.model[1])
    else
        self.modelImage:SetModel(tbl.model)
    end
end

function PANEL:Init()
    self.data = {}

    self.modelImage = vgui.Create("ModelImage", self)
    self.jobName = vgui.Create("DLabel", self)
    self.salary = vgui.Create("DLabel", self)
    self.slots = vgui.Create("DLabel", self)

    self.modelImage:Dock(LEFT)

    self.salary:Dock(RIGHT)
    self.slots:Dock(RIGHT)
    
    self.salary:DockMargin(8,0,8,0)

    self.jobName:Dock(FILL)

    self.salary:SetText("")
    self.slots:SetText("")
    self.jobName:SetText("")

    self.jobName.Paint = function(_, w, h)
        if self.data.name then
            draw.DrawText(self.data.name, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self.salary.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, (h / 1.5) / 4, w, h / 1.5, Color(0,0,0,50))

        if self.data.salary then
            draw.DrawText("$" .. self.data.salary, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self.slots.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, (h / 1.5) / 4, w, h / 1.5, Color(0,0,0,50))

        if self.data.max > 0 then
            draw.DrawText(self.data.players .. "/" .. self.data.max, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        else
            draw.DrawText("∞", "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self:SetTall(64)
end

function PANEL:DoClick()
    local modal = vgui.Create("fcore::f4::jobs::modal")
    modal:SetInfo(self.data)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 35))
end

vgui.Register("fcore::f4::jobs::panel", PANEL, "FCore.Button")

/*
    Menu Panel
*/

PANEL = {}

function PANEL:GetJobs()
    local categories = DarkRP.getCategories().jobs

    for _,category in ipairs(categories) do
        if #category.members > 0 then
            local c = self.container:Add("FCore.Category")
            c:DockMargin(0,0,0,8)

            c.Header:SetText(category.name)
            c:Dock(TOP)

            for _,job in ipairs(category.members) do
                for jobId, jobData in ipairs(RPExtraTeams) do
                    if job == jobData then
                        job.id = jobId
                    end
                end

                if job.id == LocalPlayer():Team() then continue end

                local j = vgui.Create("fcore::f4::jobs::panel")

                j:SetInfo(job)
                c:AddItem(j)
            end
        end
    end
end

function PANEL:Init()
    self.container = vgui.Create("DScrollPanel", self)
    self.container:Dock(FILL)

    local s = self.container:GetVBar()
    s:SetWide(0)

    function self.container:Paint()

    end

    self:GetJobs()
end

function PANEL:Paint()

end

FCore.F4Menu:AddPanel("Prace", "fcore::f4::jobs", PANEL, "DPanel", 1, 0xf0f2)