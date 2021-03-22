FCore.InformationSystem = FCore.InformationSystem or {}
FCore.InformationSystem.Requests = {}

net.Receive("FCore::InformationSystem::Receive", function()
    local tbl = net.ReadTable()
    if !tbl then return end

    table.insert(FCore.InformationSystem.Requests, tbl)
end)

hook.Add("PostDrawOpaqueRenderables", "FCore::HUD::Entity", function()
    if !FCore.InformationSystem.Requests then FCore.InformationSystem.Requests = {} end
    
    for k,v in ipairs(FCore.InformationSystem.Requests) do
        if v.time + 300 < os.time() then table.remove(FCore.InformationSystem.Requests, k) continue end

        cam.Start3D2D(v.pos, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
            cam.IgnoreZ(true)
            
            draw.RoundedBox(0, 0, 0, 64, 64, Color(255,255,255))
        cam.End3D2D()
    end
end)