local TexPath = '/mods/Mechdivers/textures'
local ModUid = '5t3edt-btz6-9437-h6ui-967gt79facskmd100' -- must match mod_info.lua

FactionKey = 'terminids'
CommanderId = 'tel0001'

Skin = {
        default = "uef",
        texturesPath = "/textures/ui/seraphim",
        imagerMesh = "/mods/Mechdivers/meshes/game/map-border_squ_term_mesh",
        imagerMeshDetails = "",
        imagerMeshHorz = "",
        imagerMeshDetailsHorz = "",
        buttonFont = "Zeroes Three",
	    factionFont = "Zeroes Three",
        bodyFont = "Arial",
        fixedFont = "Arial",
        titleFont = "Zeroes Three",
        fontColor = "FFDB9257",
        bodyColor = "FFDB9257",
        factionFontOverColor = "FFDB9257",
        factionFontDownColor = "FF967A64",
	    dialogCaptionColor = "FFDB9257",
        dialogColumnColor = "FFDB9257",
        dialogButtonColor = "FFDB9257",
        dialogButtonFont = "Zeroes Three",
        highlightColor = "FFDB9257",
        disabledColor = "FF967A64",
        tooltipBorderColor = "FF98531B",
        tooltipTitleColor = "FF864A19",
        tooltipBackgroundColor = "#FF000000",
        menuFontSize = 18,
        layouts = {
            "bottom",
            "left",
            "right"
        },
}
	


local function MakeFactionEntry(uef)
    local entry = table.deepcopy(uef)            -- start from UEF: no missing fields
    entry.Key = 'terminids'                      -- internal name
    entry.Category = 'TERMINIDS'                 -- unit category for this faction
    entry.FactionInUnitBp = 'terminids'          -- must match General.FactionName in the unit .bp
    entry.IsCustomFaction = true
    entry.DisplayName = 'terminids'
    entry.InitialUnit = 'tel0001'                -- the ACU blueprint ID that spawns
    entry.CampaignFileDesignator = 'T'           -- any unused letter
    entry.Icon      = '/Mods/Mechdivers/textures/terminids_icon_24.dds'
    entry.SmallIcon = '/Mods/Mechdivers/textures/terminids_icon_18.dds'
    entry.LargeIcon = '/Mods/Mechdivers/textures/terminids_icon_60.dds'
    entry.TooltipID = 'lob_terminids'            -- tooltip key
    return entry
end

function AddFaction(factions, indexMap, desToKey, unitBpToKey)
    if indexMap['terminids'] then return end     -- don't twice
    local entry = MakeFactionEntry(factions[1])  -- factions[1] = UEF
    table.insert(factions, entry)                -- it becomes faction 5 (or 6 with Nomads)
    local index = table.getn(factions)
    -- factions.lua has three lookup tables. Fill in all of them:
    indexMap['terminids'] = index
    desToKey[entry.CampaignFileDesignator] = 'terminids'
    unitBpToKey[entry.FactionInUnitBp] = index
end

-- "random" was counted before our faction existed; new slots would default to us
local function KeepRandomAsDefault()
    local PlayerData = import('/lua/ui/lobby/data/playerdata.lua').PlayerData
    local oldInit = PlayerData.__init
    PlayerData.__init = function(self, initialMapping)
        if initialMapping and initialMapping.Faction == nil then
            initialMapping.Faction = table.getn(import('/lua/factions.lua').Factions) + 1
        end
        oldInit(self, initialMapping)
    end
end

-- lobby.lua's local FACTION_NAMES calls index 5 "random"; rebuild it via upvalue
local function SyncFactionNames(fn)
    local i = 1
    while true do
        local name, names = debug.getupvalue(fn, i)
        if not name then
            WARN('terminids: FACTION_NAMES not found in lobby.lua; the faction will show as random')
            return fn
        end
        if name == 'FACTION_NAMES' then
            local factions = import('/lua/factions.lua').Factions
            for index, faction in factions do
                names[index] = faction.Key
            end
            names[table.getn(factions) + 1] = 'random'
            return fn
        end
        i = i + 1
    end
end

-- faction button textures live in a game folder; point ours at the mod
local function RedirectFactionSelectorTextures()
    local UIUtil = import('/lua/ui/uiutil.lua')
    local createCheckbox = UIUtil.CreateCheckbox
    local lobbyPath = '/factionselector/' .. FactionKey .. '/'
    UIUtil.CreateCheckbox = function(parent, texturePath, label, labelRight, labelSize, clickCue, rollCue)
        if texturePath == lobbyPath then
            texturePath = TexPath .. '/factionselector/'
        end
        return createCheckbox(parent, texturePath, label, labelRight, labelSize, clickCue, rollCue)
    end
end

-- same for the lobby background
local function RedirectLobbyBackground()
    local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
    local setTexture = Bitmap.SetTexture
    local lobbyPath = '/textures/ui/common/BACKGROUND/faction/faction-background-paint_' .. FactionKey .. '_bmp.dds'
    Bitmap.SetTexture = function(self, texture, border)
        if texture == lobbyPath then
            texture = TexPath .. '/lobby_background.dds'
        end
        return setTexture(self, texture, border)
    end
end

-- faction picked but mod off = game hangs at start, so enable the mod at launch
local function EnableModWhenFactionPicked()
    local LobbyComm = import('/lua/ui/lobby/lobbycomm.lua').LobbyComm
    local launchGame = LobbyComm.LaunchGame
    LobbyComm.LaunchGame = function(self, info)
        local factionIndex = import('/lua/factions.lua').FactionIndexMap[FactionKey]
        local picked = false
        local players = info.PlayerOptions
        if players.pairs then
            -- host: WatchedValueArray, clients: plain table
            for _, player in players:pairs() do
                if player and player.Faction == factionIndex then picked = true end
            end
        else
            for _, player in players do
                if player and player.Faction == factionIndex then picked = true end
            end
        end

        if picked then
            local enabled = false
            for _, mod in info.GameMods do
                if mod.uid == ModUid then enabled = true end
            end
            if not enabled then
                local mod = import('/lua/mods.lua').AllMods()[ModUid]
                if mod then
                    table.insert(info.GameMods, mod)
                    LOG('Sentinels: a player picked the faction, so the mod was enabled for this game')
                end
            end
        end
        return launchGame(self, info)
    end
end

local function PatchLobby()
    local wrappers = {
        UpdateAvailableSlots = SyncFactionNames,
    }
    local lobby = __modules['/lua/ui/lobby/lobby.lua']
    if not lobby then
        WARN('Terminids: lobby module not found; the faction will show as random')
        return
    end

    for name, wrap in wrappers do
        local fn = rawget(lobby, name)
        if fn then
            rawset(lobby, name, wrap(fn))
            wrappers[name] = nil
        end
    end
    if table.empty(wrappers) then
        return
    end

    -- lobby.lua is still loading: catch the function when it gets defined
    local moduleMeta = getmetatable(lobby)
    local catcher = {}
    for k, v in moduleMeta do
        catcher[k] = v
    end
    catcher.__newindex = function(t, key, value)
        local wrap = wrappers[key]
        if wrap then
            value = wrap(value)
            wrappers[key] = nil
        end
        rawset(t, key, value)
        if table.empty(wrappers) then
            setmetatable(t, moduleMeta)
        end
    end
    setmetatable(lobby, catcher)
end   

function RegisterSkin(skins)
    local skin = table.copy(Skin)
    local default = skins[skin.default]
    while default do
        table.assimilate(skin, default)
        default = skins[default.default]
    end
    skins[FactionKey] = skin
end
 
function InstallInLobby()
    local FactionData = import('/lua/factions.lua')
    AddFaction(FactionData.Factions, FactionData.FactionIndexMap,
               FactionData.FactionDesToKey, FactionData.FactionInUnitBpToKey)

    -- tooltip shown when you hover over the faction button
    import('/lua/ui/help/tooltips.lua').Tooltips.lob_terminids = {
        title = 'Terminids',
        description = 'Alien Insects',
    }

    -- the lobby names AI players from a list per faction and ERRORS on a missing key
    local aiNames = import('/lua/ui/lobby/ainames.lua').ainames
    aiNames['terminids'] = aiNames['terminids'] or aiNames.uef

    RegisterSkin(import('/lua/skins/skins.lua').skins)  -- optional: a custom UI skin colour

    KeepRandomAsDefault()               -- 3a
    RedirectFactionSelectorTextures()   -- 3b
    RedirectLobbyBackground()           -- 3b
    EnableModWhenFactionPicked()        -- step 4
    PatchLobby()                        -- 3c
end

local LobbyComm = import('/lua/ui/lobby/lobbycomm.lua').LobbyComm
local launchGame = LobbyComm.LaunchGame
LobbyComm.LaunchGame = function(self, info)
    local factionIndex = import('/lua/factions.lua').FactionIndexMap['terminids']
	local UIUtil = import("/lua/ui/uiutil.lua")
	UIUtil.SetCurrentSkin('terminids')
	
    local picked = false
    for _, player in info.PlayerOptions do
        if player and player.Faction == factionIndex then picked = true end
    end
    if picked then
        -- add our mod to GameMods if it isn't there yet
        local enabled = false
        for _, mod in info.GameMods do
            if mod.uid == ModUid then enabled = true end   -- ModUid = the uid in mod_info.lua
        end
        if not enabled then
            table.insert(info.GameMods, import('/lua/mods.lua').AllMods()[ModUid])
        end
    end
    return launchGame(self, info)
end


   
   


