--- This script sets is_retiring on 0 for all players.

-- Get all rows for players table
local rows = GetDBTableRows("players")

local counter = 0;
for i=1, #rows do
    local player = rows[i]

    player.isretiring.value = "0"
    EditDBTableField(player.isretiring)
end

MessageBox("Done", string.format("Edited %d players\n", counter))
