FCore.Gangs = FCore.Gangs or {}
FCore.Gangs.Instances = FCore.Gangs.Instances or {}

function FCore.Gangs.LoadGangs()
    FCore.Gangs.Instances = net.ReadTable()
end

function FCore.Gangs.Update()
    net.Start("fcore_getgangs")
    net.SendToServer()
end
net.Receive("fcore_getgangs", FCore.Gangs.LoadGangs)