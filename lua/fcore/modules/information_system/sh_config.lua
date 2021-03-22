FCore.InformationSystem = FCore.InformationSystem or {}
FCore.InformationSystem.Config = {
    {
        title = "Players",
        desc = "All Players",
        color = Color(255,255,255)
    },
    {
        title = "Police",
        desc = "Only Police",
        color = Color(0,0,255),
        allowed = function()
            local teams = {}

            for _,v in ipairs(RPExtraTeams) do
                if v.category == "Civil Protection" then
                    table.insert(teams, _)
                end
            end

            return teams
        end
    }
}