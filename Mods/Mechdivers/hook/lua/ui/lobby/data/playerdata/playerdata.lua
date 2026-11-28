
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

else

local PlayerData = import('/lua/ui/lobby/data/playerdata.lua').PlayerData
local oldInit = PlayerData.__init
PlayerData.__init = function(self, initialMapping)
    if initialMapping and initialMapping.Faction == nil then
        -- work out "random" again now that our faction is counted
        initialMapping.Faction = table.getn(import('/lua/factions.lua').Factions) + 1
    end
    oldInit(self, initialMapping)
end

end