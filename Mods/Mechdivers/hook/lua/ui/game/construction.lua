
function GetBackgroundTextures(unitID)
    local bp = __blueprints[unitID]
    local validIcons = {land = true, air = true, sea = true, amph = true, orbit = true}
    local icon = "land"
	local Modpath = "/mods/Mechdivers"
    if unitID and unitID ~= 'default' then
        if not validIcons[bp.General.Icon] then
            if bp.General.Icon then WARN(debug.traceback(nil, "Invalid icon" .. bp.General.Icon .. " for unit " .. tostring(unitID))) end
            bp.General.Icon = "land"
		else
			icon = bp.General.Icon
		end
    end
	return UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_up.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_down.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_over.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_up.dds')
end

function GetEnhancementPrefix(unitID, iconID)
LOG('unitID: ', unitID)
    local factionPrefix = ''
    if string.sub(unitID, 6, 6) == 'a' or string.sub(unitID, 2, 2) == 'a' then
        factionPrefix = 'aeon-enhancements/' 
    elseif string.sub(unitID, 6, 6) == 't' or string.sub(unitID, 2, 2) == 'e' then
        factionPrefix = 'uef-enhancements/'
    elseif string.sub(unitID, 6, 6) == 'c' or string.sub(unitID, 2, 2) == 'r' then
        factionPrefix = 'cybran-enhancements/'
    elseif string.sub(unitID, 6, 6) == 's' or string.sub(unitID, 2, 2) == 's' then
        factionPrefix = 'seraphim-enhancements/'
    end
    local prefix = '/game/' .. factionPrefix .. iconID
	LOG('prefix: ', prefix)
    --# If it is a stock icon...
    if not DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        --# return a path to shared icons
        local altPathEX =  '/mods/Mechdivers/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
    end
    return prefix
end

function GetEnhancementTextures(unitID, iconID)
    local factionPrefix = ''
    if string.sub(unitID, 6, 6) == 'a' or string.sub(unitID, 2, 2) == 'a' then
        factionPrefix = 'aeon-enhancements/' 
    elseif string.sub(unitID, 6, 6) == 't' or string.sub(unitID, 2, 2) == 'e' then
        factionPrefix = 'uef-enhancements/'
    elseif string.sub(unitID, 6, 6) == 'c' or string.sub(unitID, 2, 2) == 'r' then
        factionPrefix = 'cybran-enhancements/'
    elseif string.sub(unitID, 6, 6) == 's' or string.sub(unitID, 2, 2) == 's' then
        factionPrefix = 'seraphim-enhancements/'
    end
    
    local prefix = '/game/' .. factionPrefix .. iconID
    --# If it is a stock icon...
    if DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        return UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_down.dds'),
            UIUtil.UIFile(prefix..'_btn_over.dds'),
            UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_sel.dds')
    else
        --# return a path to shared icons
        local altPathEX =  '/mods/Mechdivers/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
        --# Bypass UIFile as these icons 
        --# are not skinabble!
        return prefix..'_btn_up.dds',
            prefix..'_btn_down.dds',
            prefix..'_btn_over.dds',
            prefix..'_btn_up.dds',
            prefix..'_btn_sel.dds'
    end
end