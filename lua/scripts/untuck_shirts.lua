--- This script untuck shirts

-- Get all rows for players table
local rows = GetDBTableRows("players")

for i=1, #rows do
    local player = rows[i]

    player.jerseystylecode.value = "1"
    EditDBTableField(player.jerseystylecode)
end

MessageBox("Done",  "Done")
