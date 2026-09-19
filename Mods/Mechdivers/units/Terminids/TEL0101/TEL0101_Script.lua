#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local Unit = import('/lua/sim/Unit.lua').Unit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon


TEL0101 = Class(TWalkingLandUnit) {
    Weapons = {
        MainGun = Class(AcidWeapon) {
        },
    },
}
TypeClass = TEL0101

