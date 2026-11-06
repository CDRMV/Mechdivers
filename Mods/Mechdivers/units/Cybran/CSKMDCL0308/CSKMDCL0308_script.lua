#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon

CSKMDCL0308 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
		MissileRack = Class(CIFGrenadeWeapon) {},
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self:HideBone('B01', true)
    end,
}

TypeClass = CSKMDCL0308