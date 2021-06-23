FCore.DataFolders = {
    {
        name = "join_leave"
    },
    {
        name = "introduction"
    },
    {
        name = "gangs"
    }
}

if !file.Exists("fcore/", "DATA") then
    file.CreateDir("fcore/")
end

for k,v in ipairs(FCore.DataFolders) do
    if !file.Exists("fcore/" .. v.name .. "/", "DATA") then
        file.CreateDir("fcore/" .. v.name .. "/")
    end
end