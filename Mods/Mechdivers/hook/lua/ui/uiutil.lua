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
	  
	  
	  cskmdta0301a=true,
	  cskmdta0301b=true, 
	  cskmdta0301c=true,
	  cskmdta0301d=true, 
	  cskmdta0301e=true,
	  
	  cskmdta0302=true, 
	  cskmdta0302b=true, 
	  cskmdta0302c=true,
	  cskmdta0302d=true, 
	  cskmdta0302e=true,
	  cskmdta0302f=true, 
	  cskmdta0302g=true, 
	  cskmdta0302h=true, 
	  
 -- Land 
	  cskmdtl0200=true, 
	  cskmdtl0201=true, 
	  cskmdtl0202=true, 
	  cskmdtl0203=true, 
 	  cskmdtl0205=true, 
	  cskmdtl0300=true, 
	  cskmdtl0303=true, 
	  cskmdtl0304=true, 
	  cskmdtl0303b=true, 
	  cskmdtl0304b=true, 
	  cskmdtl0305=true, 
	  cskmdtl0306=true, 
	  cskmdtl0307=true, 
		  
-- Structures

      -- Mines --
	  uebmd001=true,
	  uebmd002=true,
	  uebmd003=true,
	  uebmd004=true,
	  -----------
	  uebmd00100=true,
	  uebmd00300=true,
	  uebmd00301=true,
	  uebmd00302=true,
	  uebmd00300b=true,
	  
	  uebmd0100=true,
	  uebmd0101=true,						
	  uebmd0102=true,
	  uebmd0102b=true,
	  uebmd0102c=true,
	  uebmd0102d=true,
	  uebmd0103=true,
	  uebmd0104=true,						
	  uebmd0105=true,	
	  uebmd0106=true,	  
	  uebmd0108=true,
	  uebmd0109=true,
	  uebmd0110=true,
	  uebmd0111=true,
	  uebmd0112=true,
	  uebmd0113=true,
	  
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
	  cskmdcl0204=true, 
	  cskmdcl0205=true, 
	  cskmdcl0206=true,	  
	  cskmdcl0300=true, 
	  cskmdcl0301=true, 
	  cskmdcl0302=true, 
	  cskmdcl0303=true, 
	  cskmdcl0304=true, 		  
	  cskmdcl0305=true, 
	  cskmdcl0306=true, 
	  cskmdcl0307=true, 		  
	  cskmdcl0308=true, 
	  cskmdcl0309=true, 
	  cskmdcl0310=true, 		  
	  cskmdcl0311=true,
	  cskmdcl0312=true,
	  cskmdcl0313=true, 
	  cskmdcl0314=true,
	  cskmdcl0315=true, 
	  cskmdcl0316=true,
	  cskmdcl0317=true, 	
	  cskmdcl0318=true, 	  
	  
-- Structures 
      -- Mines --
	  urbmd001=true,
	  
	  ----------- 
	  urbmd00100=true,
	  
	  urbmd0100=true,
	  urbmd0101=true,
	  urbmd0102=true,
	  urbmd0103=true,
	  urbmd0104=true,
	  urbmd0105=true,
	  urbmd0106=true,
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


-- Table for new Ability Icons

local MyOrderIdTable = {

	example_btn_over=true,
	example_btn_up=true,
	example_btn_over_sel=true,
	example_btn_up_sel=true,
	example_btn_dis=true,
	example_btn_dis_sel=true,
	example_btn_down=true,
	
}


local IconPath = "/Mods/Mechdivers"
	-- Adds icons to the engeneer/factory buildmenu
	local oldUIFile = UIFile
	function UIFile(filespec)
		local skins = import('/lua/skins/skins.lua').skins
		local visitingSkin = currentSkin()
		local OrderIconName = string.gsub(filespec,'.dds','')
		OrderIconName = string.gsub(OrderIconName,'/game/orders/','')
		if MyOrderIdTable[OrderIconName] then
			local curfile =  IconPath .. filespec
			return curfile
		end
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