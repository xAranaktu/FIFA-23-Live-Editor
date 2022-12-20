-- This script will automatically extend the contracts of players in your team
-- 4 years by default
local new_contract_length = 12 * 4 -- 4 years

-- Don't Touch anything below
assert(IsInCM(), "Script must be executed in career mode")

function update_contractvaliduntil(contracts)
    local contracts_to_update = 0
    local updated_contracts = 0

    for playerid, contractvaliduntil in pairs(contracts) do
        contracts_to_update = contracts_to_update + 1
    end
    
    local rows = GetDBTableRows("players")
    for i=1, #rows do
        if updated_contracts >= contracts_to_update then
            break
        end
        local row = rows[i]
        local playerid = math.floor(row.playerid.value)
        if playerid > 0 then
            local contractvaliduntil = contracts[playerid]
            if contractvaliduntil ~= nil then
                row.contractvaliduntil.value = contractvaliduntil
                EditDBTableField(row.contractvaliduntil)
                updated_contracts = updated_contracts + 1
            end
        end
    end
    
    local failed_to_update = contracts_to_update - updated_contracts
    
    if failed_to_update > 0 then
        Log(string.format("Failed to update %d contracts", failed_to_update))
    end
    
    Log(string.format("Updated Contracts: %d", updated_contracts))
end

function update_contracts()
    local result = {}

    local currentdate = GetCurrentDate()
    local int_current_date = currentdate.year * 10000 + currentdate.month * 100 + currentdate.day
    
    local rows = GetDBTableRows("career_playercontract")
    
    for i=1, #rows do
        local row = rows[i]
        local contract_status = row.contract_status.value
        local is_loaned_in = contract_status == "1" or contract_status == "3" or contract_status == "5"
        
        -- Ignore players that are loaned in
        if not is_loaned_in then
            local playerid = math.floor(row.playerid.value)
            if playerid > 0 then
                local contract_date = math.floor(row.contract_date.value)
                local last_status_change_date = math.floor(row.last_status_change_date.value)
                
                -- Set contract date to current date
                if contract_date < int_current_date then
                    row.contract_date.value = string.format("%d", int_current_date)
                    EditDBTableField(row.contract_date)
                end
                
                -- last_status change date to current date
                if last_status_change_date < int_current_date then
                    row.last_status_change_date.value = string.format("%d", int_current_date)
                    EditDBTableField(row.last_status_change_date)
                end
                
                row.duration_months.value = string.format("%d", new_contract_length)
                EditDBTableField(row.duration_months)

                local contractvaliduntil = string.format("%d", currentdate.year + math.floor(new_contract_length / 12))
                
                result[playerid] = contractvaliduntil
            end
        end
    end
    
    return result
end

update_contractvaliduntil(update_contracts())
Log("Done")