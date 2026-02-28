#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon

CSKMDTA0303 = Class(TAirUnit) {
	Weapons = {
		Bomb = Class(TIFCarpetBombWeapon) {},
    },


}

TypeClass = CSKMDTA0303