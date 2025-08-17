local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
	LOG('Mechdivers: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UpdateWindow" to add our own unit icons')

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
	  
-- Structures
      -- Mines --
	  uebmd001=true,
	  
	  -----------

	  uebmd0100=true,
	  uebmd0101=true,						
	  uebmd0102=true,						
	  
-- Cybran

 -- Air
 	  cskmdca0300=true, 
	  cskmdca0301=true, 
	  ura0104c=true, 
	  ura0107c=true,  

 -- Land	
	  cskmdcl0300=true, 
	  cskmdcl0301=true, 
	  cskmdcl0302=true, 
	  cskmdcl0303=true, 
	  cskmdcl0304=true, 

-- Structures 
      -- Mines --
	  urbmd001=true,
	  
	  ----------- 
	  
	  urbmd0100=true,
	  urbmd0101=true,
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
	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		if MyUnitIdTable[info.blueprintId] then
			controls.icon:SetTexture(IconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
		end
		
		local techLevel = false
        local levels = {TECH1 = 1,TECH2 = 2,TECH3 = 3, ELITE = 35, TITAN = 5, HERO = 6}
		local bp = __blueprints[info.blueprintId]
		local description = LOC(bp.Description)
        for i, v in bp.Categories do
            if levels[v] then
                techLevel = levels[v]
                break
            end
		end	
	
	
		if techLevel == false then
		description = LOCF("%s", bp.Description)
		else
	
	    if techLevel == 35 then
            description = LOCF("Elite %s", bp.Description)
		elseif techLevel == 5 then
			description = LOCF("Titan %s", bp.Description)
		elseif techLevel == 6 then
			description = LOCF("Hero %s", bp.Description)
		else
		description = LOCF("Tech %d %s", techLevel, bp.Description)
        end
		end
		
		if info.customName then
            controls.name:SetText(LOCF('%s: %s', info.customName, description))
        elseif bp.General.UnitName then
            controls.name:SetText(LOCF('%s: %s', bp.General.UnitName, description))
        else
            controls.name:SetText(LOCF('%s', description))
        end
	end

else

	local oldUpdateWindow = UpdateWindow
	function UpdateWindow(info)
		oldUpdateWindow(info)
		
		local techLevel = false
        local levels = {TECH1 = 1,TECH2 = 2,TECH3 = 3, ELITE = 35, TITAN = 5, HERO = 6}
		local bp = __blueprints[info.blueprintId]
		local description = LOC(bp.Description)
        for i, v in bp.Categories do
            if levels[v] then
                techLevel = levels[v]
                break
            end
		end	
	
	
		if techLevel == false then
		description = LOCF("%s", bp.Description)
		else
	
	    if techLevel == 35 then
            description = LOCF("Elite %s", bp.Description)
		elseif techLevel == 5 then
			description = LOCF("Titan %s", bp.Description)
		elseif techLevel == 6 then
			description = LOCF("Hero %s", bp.Description)
		else
		description = LOCF("Tech %d %s", techLevel, bp.Description)
        end
		end
		
		if info.customName then
            controls.name:SetText(LOCF('%s: %s', info.customName, description))
        elseif bp.General.UnitName then
            controls.name:SetText(LOCF('%s: %s', bp.General.UnitName, description))
        else
            controls.name:SetText(LOCF('%s', description))
        end
	end
	LOG('Mechdivers: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function