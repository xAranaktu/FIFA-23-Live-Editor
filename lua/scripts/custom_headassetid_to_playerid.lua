--- This script can add/update headmodels from your frostymod
--- You need to edit "headmodels_map" by yourself, pattern is simple:
--- [playerid] = headassetid,
--- by default it updates these faces:
--- paqueta 205361
--- semedo 215556
--- de jong 235526
--- arthur 122574
--- ansu 230899
--- b fernandes 192565
--- tonali 202223
--- haaland 192641
--- neres 231436
--- odegaard 241651
--- Nicolas Pepe 226110
--- Sensi 183795
--- Kubo 232730
--- Carles Perez 230065
--- Yari Verscharen 208549
--- Which are part of Master Patch Revolution 1.0 by (MPR united modders).

local headmodels_map = {
    [233927] = 205361,
    [227928] = 215556,
    [228702] = 235526,
    [230658] = 122574,
    [253004] = 230899,
    [212198] = 192565,
    [241096] = 202223,
    [239085] = 192641,
    [236632] = 231436,
    [222665] = 241651,
    [226110] = 226110,
    [229857] = 183795,
    [237681] = 232730,
    [240654] = 230065,
    [246419] = 208549
}
-- Get all rows for players table
local rows = GetDBTableRows("players")

local counter = 0;
for i=1, #rows do
    local player = rows[i]

    local iplayerid = math.floor(player.playerid.value)
    local headassetid = headmodels_map[iplayerid]

    if (headassetid) then
        player.hashighqualityhead.value = "1"
        EditDBTableField(player.hashighqualityhead)

        player.headclasscode.value = "0"
        EditDBTableField(player.headclasscode)

        player.headassetid.value = tostring(headassetid)
        EditDBTableField(player.headassetid)
        counter = counter + 1
    end

end

MessageBox("Done", string.format("Edited %d players\n", counter))
