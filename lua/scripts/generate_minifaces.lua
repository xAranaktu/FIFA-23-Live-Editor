-- Generate miniface for everyplayer in playable league.
-- THIS WILL TAKE A WHILE TO COMPLETE, like around 10h...
-- and... if the game will crash (which is very possible) you will have to start from beginning...

-- Execute only if we are in career mode
if not IsInCM() then return end

-- List of teams that cause game crashes or other problems
local BLACKLISTED_TEAMS = {
    [112264] = true         -- YOUTH ACADEMY
}

-- List of leagues that we want to skip
local BLACKLISTED_LEAGUES = {
    [78] = true,            -- International
    [2136] = true,          -- International Women
    [76] = true,            -- Rest of World
    [383] = true,           -- Create Player League
    [2028] = true           -- Youth Squad League
}

-- Path is relative to the game installation directory
PlayerCaptureSetOutputDirectory("LiveEditorMods\\root\\Legacy\\data\\ui\\imgAssets\\heads")

-- 0 - Head and shoulders
-- 1 - Head
-- 2 - Body
PlayerCaptureSetCamera(1)

-- 256x256
PlayerCaptureSetSize(256, 256)

-- Image Type
-- 0 - PNG
-- 1 - DDS
PlayerCaptureSetType(1)

-- Get all rows for leagueteamlinks table
local rows = GetDBTableRows("leagueteamlinks")
for i=1, #rows do
    local ltlink = rows[i]

    local ileagueid = math.floor(ltlink.leagueid.value)

    if BLACKLISTED_LEAGUES[ileagueid] then
        local iteamid = math.floor(ltlink.teamid.value)
        BLACKLISTED_TEAMS[iteamid] = true
    end
end

-- Get all rows for teamplayerlinks table
rows = GetDBTableRows("teamplayerlinks")

for i=1, #rows do
    local tplink = rows[i]

    local iteamid = math.floor(tplink.teamid.value)
    if not BLACKLISTED_TEAMS[iteamid] then
        local iplayerid = math.floor(tplink.playerid.value)
        PlayerCaptureAddPlayer(iplayerid, iteamid)
    end
end

-- Start Capturing
PlayerCaptureStart()
