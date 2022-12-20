--- This script change socks length on medium

-- Get all rows for players table
local rows = GetDBTableRows("players")

local counter = 0;
for i=1, #rows do
    local player = rows[i]

    player.socklengthcode.value = "0"
    EditDBTableField(player.socklengthcode)
end

MessageBox("Done", string.format("Edited %d players\n", counter))
