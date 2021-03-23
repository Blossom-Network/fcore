FCore = {}
FCore.Colors = {
    success = Color(0,255,0),
    error = Color(255,0,0),
    red = Color(255,64,64),
    main = Color(64,64,64,255),
    secondary = Color(48,48,48,255),
    text = Color(192,192,192,255),
    health = Color(255,64,64,255),
    armor = Color(84,84,84,255),
    white = Color(255,255,255,255),
    transparent = Color(255,255,255,0)
}

function FCore.Print(txt, color)
    MsgC(Color(255,255,255), "[FCore] ", color, txt, "\n")
end

function FCore.searchFiles(dir)
    local files, directories = file.Find(dir .. "/*", "LUA")

    for k,v in ipairs(files) do
        if string.match(v, ".lua") then
            FCore.Print("Including " .. dir .. "/" .. v .. " (" .. CurTime() - FCore.Started .. "s)", FCore.Colors.success)
            FCore.includeFile(dir .. "/" .. v, string.Left(v, 2))
        end
    end

    for k,v in ipairs(directories) do
        FCore.Print("Searching " .. dir .. "/" .. v .. " (" .. CurTime() - FCore.Started .. "s)", FCore.Colors.success)
        FCore.searchFiles(dir .. "/" .. v)
    end
end

function FCore.includeFile(fileLoc, fileType)
    if (fileType == "cl" or string.match(fileLoc, "vgui")) then
        if SERVER then
            AddCSLuaFile(fileLoc)
        else
            include(fileLoc)
        end
    elseif (fileType == "sv") then
        if SERVER then
            include(fileLoc)
        end
    elseif (fileType == "sh") then
        if SERVER then
            include(fileLoc)
            AddCSLuaFile(fileLoc)
        else
            include(fileLoc)
        end
    end
end

function FCore.Run()
    FCore.Started = CurTime()

    FCore.Print("Initializing FCore...\n", FCore.Colors.success)
    FCore.searchFiles("fcore")
end

hook.Add("PostGamemodeLoaded", "FCore::Initialize", FCore.Run)