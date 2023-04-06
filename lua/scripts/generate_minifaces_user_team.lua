-- Generate miniface for everyplayer in the user team
-- May take around 5 mins to complete, so be patient.

-- Execute only if we are in career mode
if not IsInCM() then return end

-- Path is relative to the game installation directory
PlayerCaptureSetOutputDirectory("<default>")

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

local user_teamid = GetUserTeamID()

-- Get all rows for teamplayerlinks table
rows = GetDBTableRows("teamplayerlinks")

for i=1, #rows do
    local tplink = rows[i]

    local iteamid = math.floor(tplink.teamid.value)
    if user_teamid == iteamid then
        local iplayerid = math.floor(tplink.playerid.value)
        PlayerCaptureAddPlayer(iplayerid, iteamid)
    end
end

-- Start Capturing
PlayerCaptureStart()
