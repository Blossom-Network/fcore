FCore.Introduction = {}
FCore.Introduction.Points = {}

FCore.Introduction.CurrentPoint = 1
FCore.Introduction.CameraPos = {}

FCore.Introduction.Debug = CreateClientConVar("fcore_intro_debug", "0", true)

local motd = [[Witaj na naszym serwerze!

Życzymy tobie miłej gry!
Dołącz na nasz serwer Discord!]]

local function textWrap(txt, font, width)
    txt = DarkRP.textWrap(txt, font, width)

    surface.SetFont(font)
    local nwidth, height = surface.GetTextSize(txt)

    return txt, nwidth, height
end

function FCore.Introduction.CyclePoints()
    local id = FCore.Introduction.CurrentPoint
    local nextid = 0

    if !FCore.Introduction.Points[id + 1] then
        nextid = 1
    else
        nextid = id + 1
    end

    FCore.Introduction.CurrentPoint = nextid
end

function FCore.Introduction.GetCameraPoint()
    local id = FCore.Introduction.CurrentPoint
    local nextid = 0

    if !FCore.Introduction.Points[FCore.Introduction.CurrentPoint + 1] then
        nextid = 1
    else
        nextid = FCore.Introduction.CurrentPoint + 1
    end

    return id, nextid
end

function FCore.Introduction.Move()
    local id, nextid = FCore.Introduction.GetCameraPoint()

    local animationDuration = FCore.Introduction.Points[id].pos:Distance(FCore.Introduction.Points[nextid].pos) / 500

    if !FCore.Introduction.CameraPos.pos or !FCore.Introduction.CameraPos.ang then
        FCore.Introduction.CameraPos = {
            pos = FCore.Introduction.Points[id].pos,
            ang = FCore.Introduction.Points[id].ang,
            start = SysTime()
        }
    end

    if (SysTime() - FCore.Introduction.CameraPos.start) / animationDuration >= 1 and (SysTime() - FCore.Introduction.CameraPos.start) / animationDuration >= 1 then
        FCore.Introduction.CyclePoints()

        FCore.Introduction.CameraPos = {
            pos = FCore.Introduction.Points[id].pos,
            ang = FCore.Introduction.Points[id].ang,
            start = SysTime()
        }
    end

    local lp = (SysTime() - FCore.Introduction.CameraPos.start) / animationDuration
    local la = (SysTime() - FCore.Introduction.CameraPos.start) / animationDuration

    if lp >= 1 then lp = 1 end
    if la >= 1 then la = 1 end

    FCore.Introduction.CameraPos = {
        pos = LerpVector(lp, FCore.Introduction.Points[id].pos, FCore.Introduction.Points[nextid].pos),
        ang = LerpAngle(la, FCore.Introduction.Points[id].ang, FCore.Introduction.Points[nextid].ang),
        start = FCore.Introduction.CameraPos.start
    }

    return FCore.Introduction.CameraPos.pos, FCore.Introduction.CameraPos.ang
end

function FCore.Introduction.AddPoint()
    if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
        table.insert(FCore.Introduction.Points, {
            pos = LocalPlayer():EyePos(),
            ang = LocalPlayer():EyeAngles()
        })
    end
end

function FCore.Introduction.GetPoints()
    for k,v in ipairs(FCore.Introduction.Points) do
        local x = v.pos.x
        local y = v.pos.y
        local z = v.pos.z

        local yaw = v.ang.yaw
        local pitch = v.ang.pitch
        local roll = v.ang.roll

        MsgC(Color(255,255,255), string.format("[ID: %d] | Vector(%d, %d, %d) | Angle(%d, %d, %d)\n", k, x, y, z, yaw, pitch, roll))
    end
end

function FCore.Introduction.ClearPoints()
    FCore.Introduction.Points = {}
end

function FCore.Introduction.LoadPoints()
    print("sent")
    net.Start("fcore_loadpoints")
    net.SendToServer()
end

net.Receive("fcore_loadpoints", function(len)
    FCore.Introduction.Points = net.ReadTable() or {}
    FCore.Introduction.Run()
end)

net.Receive("fcore_savepoints", function(len)
    notification.AddLegacy(net.ReadString(), 0, 10)
end)

function FCore.Introduction.SavePoints()
    net.Start("fcore_savepoints")
    net.WriteTable(FCore.Introduction.Points)
    net.SendToServer()
end

function FCore.Introduction.CreateVGUI()
    sound.PlayURL("https://fizi.pw/opiumrp/assets/audio/Lost%20Sky%20-%20Fearless.ogg", "noplay noblock", function(snd)
        if snd and IsValid(snd) then
            FCore.Introduction.AudioInstance = snd

            FCore.Introduction.AudioInstance:SetVolume(0.25)
            FCore.Introduction.AudioInstance:Play()
        end
    end)

    if !FCore.Introduction.Instance or !IsValid(FCore.Introduction.Instance) then
        FCore.Introduction.Instance = vgui.Create("DFrame")
    end

    FCore.Introduction.Instance:SetPos(0, 0)
    FCore.Introduction.Instance:SetSize(ScrW(), ScrH())
    FCore.Introduction.Instance:DockMargin(0, 0, 0, 0)
    FCore.Introduction.Instance:DockPadding(0, 0, 0, 0)
    FCore.Introduction.Instance:SetTitle(" ")
    FCore.Introduction.Instance:ShowCloseButton(false)
    FCore.Introduction.Instance:MakePopup()

    function FCore.Introduction.Instance:Paint(w, h)
        local pos, ang = FCore.Introduction.Move()

        local old = DisableClipping( true )

        render.RenderView( {
            origin = pos,
            angles = ang,
            x = 0, y = 0,
            w = w, h = h,
            drawhud = false,
            drawviewmodel = false,
            dopostprocess = false
        } )

        DisableClipping( old )
    end

    FCore.Introduction.Instance.Interface = TDLib("DPanel", FCore.Introduction.Instance)
    FCore.Introduction.Instance.Interface:Dock(FILL)
    FCore.Introduction.Instance.Interface:ClearPaint():Background(Color(0,0,0,100)):Blur()

    FCore.Introduction.Instance.Interface.ServerName = TDLib("DPanel", FCore.Introduction.Instance.Interface)
    FCore.Introduction.Instance.Interface.ServerName:Dock(TOP)
    FCore.Introduction.Instance.Interface.ServerName:SetTall(64)
    FCore.Introduction.Instance.Interface.ServerName:ClearPaint():Background(Color(0,0,0,100)):Text("ChillRP", "FCore_Roboto_36_700")

    local motdText, mw, mh = textWrap(motd, "FCore_Roboto_18_500", 268)

    FCore.Introduction.Instance.Interface.MOTD = TDLib("DPanel", FCore.Introduction.Instance.Interface)
    FCore.Introduction.Instance.Interface.MOTD:Dock(LEFT)
    FCore.Introduction.Instance.Interface.MOTD:SetSize(mw + 16, mh + 16)
    FCore.Introduction.Instance.Interface.MOTD:DockMargin(8, 8, 8, 8)
    function FCore.Introduction.Instance.Interface.MOTD:Paint(w, h)

        draw.RoundedBox(0, 0, 0, mw + 16, mh + 16, Color(0,0,0,100))
        draw.DrawText(motdText, "FCore_Roboto_18_500", 8, 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
    end

    FCore.Introduction.Instance.Interface.Buttons = TDLib("DPanel", FCore.Introduction.Instance.Interface)
    FCore.Introduction.Instance.Interface.Buttons:Dock(BOTTOM)
    FCore.Introduction.Instance.Interface.Buttons:SetTall(32)
    FCore.Introduction.Instance.Interface.Buttons:DockMargin(8, 8, 8, 8)
    FCore.Introduction.Instance.Interface.Buttons:ClearPaint()

    FCore.Introduction.Instance.Interface.Buttons.Close = TDLib("DButton", FCore.Introduction.Instance.Interface.Buttons)
    FCore.Introduction.Instance.Interface.Buttons.Close:SetSize(200, 32)
    FCore.Introduction.Instance.Interface.Buttons.Close:ClearPaint():Background(Color(0, 0, 0, 100)):FadeHover(Color(0, 0, 0, 200)):Text("Dołącz do gry!", "FCore_Roboto_18_500"):Dock(RIGHT)
    function FCore.Introduction.Instance.Interface.Buttons.Close:DoClick()
        FCore.Introduction.Stop()
    end
end

--[[
function FCore.Introduction.DebugPoints()
    if FCore.Introduction.Debug:GetInt() == 1 and istable(FCore.Introduction.Points) then
        for k,v in ipairs(FCore.Introduction.Points) do   
            cam.Start3D2D(v.pos, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 1)
                cam.IgnoreZ(false)
                
                draw.RoundedBox(4, 0, 0, 32, 32, Color(255,0,0))
                draw.DrawText(k, "FCore_Roboto_18_700", 16, 8, Color(255,255,255), TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end
hook.Add("PostDrawOpaqueRenderables", "FCore::Introduction::Debug", FCore.Introduction.DebugPoints)
]]

function FCore.Introduction.Stop()
    FCore.Introduction.AudioInstance:Stop()
    FCore.Introduction.Instance:Remove()
end

function FCore.Introduction.Run()
    if istable(FCore.Introduction.Points) and #FCore.Introduction.Points > 0 then
        FCore.Introduction.CreateVGUI()
    end
end

concommand.Add("fcore_addpoint", FCore.Introduction.AddPoint)
concommand.Add("fcore_getpoints", FCore.Introduction.GetPoints)
concommand.Add("fcore_clearpoints", FCore.Introduction.ClearPoints)
concommand.Add("fcore_savepoints", FCore.Introduction.SavePoints)
concommand.Add("fcore_loadpoints", FCore.Introduction.LoadPoints)
concommand.Add("fcore_runintro", FCore.Introduction.Run)

hook.Add("InitPostEntity", "FCore::Introduction::Init", function()
    FCore.Introduction.LoadPoints()
end)
