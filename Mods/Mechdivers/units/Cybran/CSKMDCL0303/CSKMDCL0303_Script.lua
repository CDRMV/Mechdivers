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
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CDFFusionMortarWeapon = ModWeaponsFile.CDFFusionMortarWeapon

CSKMDCL0303 = Class(CLandUnit) {
    Weapons = {
	  MainGun = Class(CDFFusionMortarWeapon) {},
      SecGun = Class(CDFLaserFusionWeapon) {},
	},
	  
	
}

TypeClass = CSKMDCL0303