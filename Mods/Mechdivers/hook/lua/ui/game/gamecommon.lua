local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
	LOG('Mechdivers: [gamecommon.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "GetUnitIconFileNames" to add our own unit icons')

local MyUnitIdTable = {

   
 -- New Units
 
 -- Aeon
 
 -- Air
 
 	  cskmdaa0303=true, 	
	  cskmdaa0306=true, 	 
 
 -- Land
 
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

 -- Land		 
	  cskmdcl0300=true, 
	  cskmdcl0301=true, 
	  cskmdcl0302=true, 
	  
-- Structures 

 -- Seraphim
 
 -- Land
 
 -- Air	
 
 -- Structures	 	  
   
}

	local IconPath = "/Mods/Mechdivers"
	-- Adds icons to the unitselectionwindow
	local oldGetUnitIconFileNames = GetUnitIconFileNames
	function GetUnitIconFileNames(blueprint)
		if MyUnitIdTable[blueprint.Display.IconName] then
			local iconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local upIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local downIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			local overIconName = IconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
			return iconName, upIconName, downIconName, overIconName
		else
			return oldGetUnitIconFileNames(blueprint)
		end
	end

else
	LOG('Mechdivers: [gamecommon.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function