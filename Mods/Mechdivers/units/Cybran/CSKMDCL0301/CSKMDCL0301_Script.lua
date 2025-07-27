#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0202/URL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon

CSKMDCL0301 = Class(CLandUnit) {
    Weapons = {
		MissileRack = Class(CIFGrenadeWeapon) {},
      SecGun = Class(CDFLaserFusionWeapon) {},
	},
	  
	
}

TypeClass = CSKMDCL0301