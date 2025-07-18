#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0303/UAA0303_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Air Superiority Fighter Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon

CSKMDAA0303 = Class(AAirUnit) {
    Weapons = {
        AutoCannon1 = Class(ADFCannonQuantumWeapon) {},
    },
}

TypeClass = CSKMDAA0303