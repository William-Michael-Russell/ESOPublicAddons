local portalPlayers = {}

local function removeDuplicates(tbl)
    local playername = {}
    local newTable = {}
    for index, record in ipairs(tbl) do
        if playername[record.GuildMember] == nil then
            playername[record.GuildMember] = 1
            table.insert(newTable, record)
        end
    end
    return newTable
end

function Teleporter.CheckGuildMemeberStatus(index, stringz, type)

    local TeleTotalGuilds = GetNumGuilds()
    local TeleportAllPlayersTable = {}

    for i = 0, TeleTotalGuilds do
        local totalGuildMembers = GetNumGuildMembers(GetGuildId(i))

        for j = 0, totalGuildMembers do
            local e = {}
            e.GuildName = GetGuildName(GetGuildId(i))
            e.GuildMember, e.GuildMemberNote, e.GuildMemberRankIndex, e.GuildMemberStatus, e.GuildMemberSecSince = GetGuildMemberInfo(GetGuildId(i), j)
            e.hasCharacter, e.characterName, e.zoneName, e.classType, e.alliance, e.level, e.veteranRank = GetGuildMemberCharacterInfo(GetGuildId(i), j)
            e.GuildIndex = i

            e.characterName = e.characterName:gsub("%^.*x$", "")
            local toonsLevel = GetUnitLevel("player") --- only going to add levels below 45.. too many issues portaling to vet areas.
            if mTeleSavedVars.FilterCloserToLevel then
                if toonsLevel < 50 then
                    local pName = e.characterName:gsub("%^.*x$", "")
                    if e.veteranRank == 0 then
                        if pName ~= GetUnitName("player") then
                            if e.alliance == GetUnitAlliance("player") then
                                if e.GuildMemberSecSince <= 3 then

                                    if index == 1 then -- by current zone
                                        if e.zoneName == GetUnitZone("player") then
                                            table.insert(TeleportAllPlayersTable, e)
                                        end
                                    elseif index == 2 then
                                        if e.zoneName ~= "Cyrodiil" then -- don't add Cyrodiil
                                            table.insert(TeleportAllPlayersTable, e)
                                        end
                                    elseif index == 3 then
                                        if not type then
                                            if string.lower(e.zoneName):find(string.lower(stringz)) then
                                                table.insert(TeleportAllPlayersTable, e)
                                            end
                                        else
                                            if string.lower(e.GuildMember):find(string.lower(stringz)) then
                                                table.insert(TeleportAllPlayersTable, e)
                                            end
                                        end
                                    else
                                        table.insert(TeleportAllPlayersTable, e) -- everything
                                    end
                                end
                            end
                        end
                    end
                end
            else --- else we'll add everyone
                local pName = e.characterName:gsub("%^.*x$", "")

                if pName ~= GetUnitName("player") then
                    if e.alliance == GetUnitAlliance("player") then
                        if e.GuildMemberSecSince == 0 then
                            if index == 1 then -- by current zone
                                if e.zoneName == GetUnitZone("player") then
                                    table.insert(TeleportAllPlayersTable, e)
                                end
                            elseif index == 2 then
                                if e.zoneName ~= "Cyrodiil" then -- don't add Cyrodiil
                                    table.insert(TeleportAllPlayersTable, e)
                                end
                            elseif index == 3 then
                                if not type then
                                    if string.lower(e.zoneName):find(string.lower(stringz)) then
                                        table.insert(TeleportAllPlayersTable, e)
                                    end
                                else
                                    if string.lower(e.GuildMember):find(string.lower(stringz)) then
                                        table.insert(TeleportAllPlayersTable, e)
                                    end
                                end
                            else
                                table.insert(TeleportAllPlayersTable, e) -- everything
                            end
                        end
                    end
                end
            end
        end
    end
    portalPlayers = removeDuplicates(TeleportAllPlayersTable)
    table.sort(portalPlayers, function(a, b) return a.zoneName < b.zoneName end)
    TeleporterList:add_messages(portalPlayers) -- this adds a message inside List.lua

end
