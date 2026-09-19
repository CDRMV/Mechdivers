#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon

TEB2101 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(AcidWeapon) {}
    },
}

TypeClass = TEB2101