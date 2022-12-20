-- Check if we are in Career Mode
local bIsInCM = IsInCM();

-- Get all rows for players table
local rows = GetDBTableRows("players")

for i=1, #rows do
    local player = rows[i]
    local iplayerid = math.floor(player.playerid.value)

    if (iplayerid > 0 and iplayerid < 280000) then
        local teamid = GetTeamIdFromPlayerId(iplayerid)
        local teamname = GetTeamName(teamid)
        Log(string.format("%d;%d;%s", iplayerid, teamid, teamname))
    end
end
