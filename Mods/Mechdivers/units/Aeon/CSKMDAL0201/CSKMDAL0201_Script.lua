#****************************************************************************
#**
#**  File     :  /data/units/XAL0203/XAL0203_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Assault Tank Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AHoverLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFPlasmaWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFPlasmaWeapon

CSKMDAL0201 = Class(AHoverLandUnit) {
    Weapons = {
		LightningWeapon = Class(ADFPlasmaWeapon) {},
    },
}
TypeClass = CSKMDAL0201