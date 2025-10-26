local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function



LOG('Mechdivers: [uiutil.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UIFile" to add our own unit icons')

local MyUnitIdTable = {
   
 -- New Units
 
 -- Aeon
 
 -- Air
 
 	  cskmdaa0303=true, 	
	  cskmdaa0306=true, 	 
 
 -- Land
  	  cskmdal0200=true,
 	  cskmdal0306=true,
  
 
 -- UEF
   
 -- Air  	
   
      cskmdta0300=true,  
      cskmdta0301=true, 
	  
 -- Land 
 
 	  cskmdtl0205=true, 
	  cskmdtl0300=true, 
	  cskmdtl0303=true, 
	  cskmdtl0304=true, 
	  cskmdtl0305=true, 
		  
-- Structures

      -- Mines --
	  uebmd001=true,
	  
	  -----------

	  uebmd0100=true,
	  uebmd0101=true,						
	  uebmd0102=true,
	  uebmd0103=true,
	  uebmd0104=true,						
	  uebmd0105=true,	
	  uebmd0106=true,	  
	  uebmd0108=true,
	  uebmd0109=true,
	  uebmd0110=true,
	  uebmd0111=true,
	  
-- Cybran

 -- Air
 	  cskmdca0300=true, 
	  cskmdca0301=true, 
	  ura0104c=true, 
	  ura0107c=true,  
	  
 -- Land	
	  cskmdcl0100=true, 
	  cskmdcl0101=true, 
	  cskmdcl0102=true,
	  cskmdcl0103=true, 
	  cskmdcl0104=true, 
	  cskmdcl0105=true, 
	  cskmdcl0106=true, 
	  cskmdcl0107=true, 
	  cskmdcl0200=true,
	  cskmdcl0201=true, 
	  cskmdcl0202=true, 
	  cskmdcl0203=true, 	  
	  cskmdcl0300=true, 
	  cskmdcl0301=true, 
	  cskmdcl0302=true, 
	  cskmdcl0303=true, 
	  cskmdcl0304=true, 		  
	  cskmdcl0305=true, 
	  cskmdcl0306=true, 
	  cskmdcl0307=true, 		  
	  cskmdcl0308=true, 
	  
-- Structures 
      -- Mines --
	  urbmd001=true,
	  
	  ----------- 
	  
	  urbmd0100=true,
	  urbmd0101=true,
	  urbmd0102=true,
	  urbmd0103=true,
	  urbmd0201=true,
	  urbmd0202=true,
	  urbmd0300=true,
	  urbmd0301=true,
	  urbmd0302=true,
	  urbmd0303=true,

 -- Seraphim
 
 -- Land
 
 -- Air	
 
 -- Structures  

}
local IconPath = "/Mods/Mechdivers"
	-- Adds icons to the engeneer/factory buildmenu
	local oldUIFile = UIFile
	function UIFile(filespec)
		local skins = import('/lua/skins/skins.lua').skins
		local visitingSkin = currentSkin()
		local IconName = string.gsub(filespec,'_icon.dds','')
		IconName = string.gsub(IconName,'/icons/units/','')
		if MyUnitIdTable[IconName] then
			local curfile =  IconPath .. filespec
			return curfile
		end
		return oldUIFile(filespec)
	end
	
else 	
function UIFile(filespec, checkMods)
    if UIFileBlacklist[filespec] then return filespec end
    local skins = import('/lua/skins/skins.lua').skins
    local useSkin = currentSkin()
    local currentPath = skins[useSkin].texturesPath
    local origPath = currentPath
	
    if useSkin == nil or currentPath == nil then
        return nil
    end

    if not UIFileCache[currentPath .. filespec] then
        local found = false

        if useSkin == 'default' then
            found = currentPath .. filespec
        else
            while not found and useSkin do
                found = currentPath .. filespec
                if not DiskGetFileInfo(found) then
                    -- Check mods
                    local inmod = false
                    if checkMods then
                        if __active_mods then
                            for id, mod in __active_mods do
                                -- Unit Icons
                                if DiskGetFileInfo(mod.location .. filespec) then
                                    found = mod.location .. filespec
                                    inmod = true
                                    break
                                -- ACU Enhancements
                                elseif DiskGetFileInfo(mod.location .. currentPath .. filespec) then
                                    found = mod.location .. currentPath .. filespec
                                    inmod = true
                                    break
                                end
                            end
                        end
                    end

                    if not inmod then
                        found = false
                        useSkin = skins[useSkin].default
                        if useSkin then
                            currentPath = skins[useSkin].texturesPath
                        end
                    end
                end
            end
        end

        if not found then
            -- don't print error message if "filespec" is a valid path
            if not DiskGetFileInfo(filespec) then
                SPEW('[uiutil.lua, function UIFile()] - Unable to find file:'.. origPath .. filespec)
            end
            found = filespec
        end

        UIFileCache[origPath .. filespec] = found
    end
    return UIFileCache[origPath .. filespec]
end
	LOG('Mechdivers: [uiutil.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function