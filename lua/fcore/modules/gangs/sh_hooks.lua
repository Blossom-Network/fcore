FCore.Gangs = FCore.Gangs or {}
FCore.Gangs.Instances = FCore.Gangs.Instances or {}

if SERVER then
    // Load Data
    hook.Add("DarkRPFinishedLoading", "FCore::Gangs::Load", FCore.Gangs.LoadGangs)

    // Gang Chat
else
    // Draw Holo on Gang Members
end