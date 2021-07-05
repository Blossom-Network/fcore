
local PANEL = {}

function PANEL:SetInfo(tbl)
    self.data = tbl

    surface.SetFont("FCore_Open Sans_18_500")
    local tw, _ = surface.GetTextSize("$" .. self.data.price)
    if tw > 56 then
        self.cash:SetWide(tw + 8)
    else
        self.cash:SetWide(64)
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
    self.entName = vgui.Create("DLabel", self)
    self.cash = vgui.Create("DLabel", self)
    self.limit = vgui.Create("DLabel", self)

    self.modelImage:Dock(LEFT)

    self.cash:Dock(RIGHT)
    self.limit:Dock(RIGHT)
    self.limit:SetWide(64)
    
    self.cash:DockMargin(8,0,8,0)

    self.entName:Dock(FILL)

    self.cash:SetText("")
    self.limit:SetText("")
    self.entName:SetText("")

    self.entName.Paint = function(_, w, h)
        if self.data.name then
            draw.DrawText(self.data.name, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self.cash.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, (h / 1.5) / 4, w, h / 1.5, Color(0,0,0,50))

        if self.data.price then
            draw.DrawText("$" .. self.data.price, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self.limit.Paint = function(_, w, h)
        draw.RoundedBox(4, 0, (h / 1.5) / 4, w, h / 1.5, Color(0,0,0,50))

        if self.data.max > 0 then
            draw.DrawText("MAX " .. self.data.max, "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        else
            draw.DrawText("∞", "FCore_Open Sans_18_500", w - w / 2, 22, FCore.Colors.text, TEXT_ALIGN_CENTER)
        end
    end

    self:SetTall(64)
end

function PANEL:DoClick()
    RunConsoleCommand("DarkRP", self.data.cmd)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 35))
end

vgui.Register("fcore::f4::entity::panel", PANEL, "FCore.Button")

/*
    Menu Panel
*/

PANEL = {}

function PANEL:GetEntities()
    local categories = DarkRP.getCategories().entities

    for _,category in ipairs(categories) do
        if #category.members > 0 then
            local c = self.container:Add("FCore.Category")
            c:DockMargin(0,0,0,8)

            c.Header:SetText(category.name)
            c:Dock(TOP)
            c:SetVisible(false)

            local categoryCount = 0

            for _,ent in ipairs(category.members) do
                if ent.allowed and not table.HasValue(ent.allowed, LocalPlayer():Team()) then continue end
                if ent.customCheck and not ent.customCheck(LocalPlayer()) then continue end

                local e = vgui.Create("fcore::f4::entity::panel")

                e:SetInfo(ent)
                c:AddItem(e)

                categoryCount = categoryCount + 1
            end

            if categoryCount > 0 then
                c:SetVisible(true)
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

    self:GetEntities()
end

function PANEL:Paint()

end

FCore.F4Menu:AddPanel("Przedmioty", "fcore::f4::entities", PANEL, "DPanel", 3, 0xf07a)