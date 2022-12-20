-- This script will export current season stats (goals scored, assists etc.) to CSV.
-- The SEASON_STATS.csv file will be created on Desktop.
-- The game resets stats at the beginning of every season, so you need to run the script at the end of every season.

local desktop_path = string.format("%s\\Desktop", os.getenv('USERPROFILE'))
local current_date = GetCurrentDate()
local file_path = string.format("%s\\SEASON_STATS_%d_%d_%d.csv", desktop_path, current_date.day, current_date.month, current_date.year)

-- Don't Touch
local columns = {
    "position",
    "playerid",
    "playername",
    --"team",
    "competition",
    "appearances",
    "AVG",
    "MOTMs",
    "goals",
    "assists",
    "yellow_cards",
    "two_yellow",
    "red_cards",
    "saves",
    "goals_conceded",
    "cleansheets",
}

local col_to_key = {
    position = "position",
    playerid = "playerid",
    playername = "playername",
    --team = "teamname",
    competition = "compname",
    appearances = "app",
    AVG = "avg",
    MOTMs = "motm",
    goals = "goals",
    assists = "assists",
    yellow_cards = "yellow",
    two_yellow = "two_yellow",
    red_cards = "red",
    saves = "saves",
    goals_conceded = "goals_conceded",
    cleansheets = "clean_sheets",
}

function get_pos_name(pos_id)
    POS_TO_NAME = {
        [0] = "GK",
        [1] = "SW",
        [2] = "RWB",
        [3] = "RB",
        [4] = "RCB",
        [5] = "CB",
        [6] = "LCB",
        [7] = "LB",
        [8] = "LWB",
        [9] = "RDM",
        [10] = "CDM",
        [11] = "LDM",
        [12] = "RM",
        [13] = "RCM",
        [14] = "CM",
        [15] = "LCM",
        [16] = "LM",
        [17] = "RAM",
        [18] = "CAM",
        [19] = "LAM",
        [20] = "RF",
        [21] = "CF",
        [22] = "LF",
        [23] = "RW",
        [24] = "RS",
        [25] = "ST",
        [26] = "LS",
        [27] = "LW"
    }
    return POS_TO_NAME[pos_id] or "INVALID"
end

function get_players()
    local result = {}
    
    local rows = GetDBTableRows("players")
    for i=1, #rows do
        local row = rows[i]
        local playerid = math.floor(row.playerid.value)
        
        local player = {}
        
        player.position = get_pos_name(math.floor(row.preferredposition1.value))
        
        -- Get the names later, only if needed as it's very slow
        player.name = ""
        --player.teamname = ""

        result[playerid] = player
    end
    
    return result
end

function get_stats(players)
    local result = {}
   
    local all_stats = GetPlayersStats()

    for i=1, #all_stats do
        local stat = all_stats[i]
        local playerid = stat.playerid
        local app = stat.app

        if playerid > 0 and playerid < 4294967295 and app > 0 then
            local player = players[playerid]
            if player ~= nil then
                if player.name == "" then
                    player.name = GetPlayerName(playerid)
                end
                
                local stats = player.stats or {}
                local compobjid = stat.compobjid
                stats[compobjid] = {}
                
                stats[compobjid]["playerid"] = playerid
                stats[compobjid]["playername"] = player.name
                stats[compobjid]["position"] = player.position
                
                stats[compobjid]["goals"] = stat.goals
                stats[compobjid]["yellow"] = stat.yellow
                stats[compobjid]["red"] = stat.red
                stats[compobjid]["assists"] = stat.assists
                stats[compobjid]["clean_sheets"] = stat.clean_sheets
                stats[compobjid]["compobjid"] = compobjid
                stats[compobjid]["compname"] = GetCompetitionNameByObjID(compobjid)
                
                -- Not sure
                stats[compobjid]["motm"] = stat.motm
                stats[compobjid]["saves"] = stat.saves
                stats[compobjid]["goals_conceded"] = stat.goals_conceded
                stats[compobjid]["two_yellow"] = stat.two_yellow
                
                local avg = stat.avg
                if app > 1 then 
                    avg = (avg / app) / 10 
                elseif app == 1 then
                    avg = avg / 10
                end
                
                stats[compobjid]["app"] = app
                stats[compobjid]["avg"] = string.format("%0.2f", avg)

                player.stats = stats
                result[playerid] = player

            end
        end
    end

    return result
end

assert(IsInCM(), "Script must be executed in career mode")

local file = io.open(file_path, "w+")
io.output(file)

io.write(table.concat(columns, ","))
io.write("\n")
local players_stats = get_stats(get_players())
for playerid, data in pairs(players_stats) do
    for compobjid, stat in pairs(data.stats) do
        local row = {}
        for i=1, #columns do
            local colname = columns[i]
            local _key = col_to_key[colname]
            table.insert(row, stat[_key])
        end
        io.write(table.concat(row, ","))
        io.write("\n")
    end

end

io.close(file)
Log("Done")
