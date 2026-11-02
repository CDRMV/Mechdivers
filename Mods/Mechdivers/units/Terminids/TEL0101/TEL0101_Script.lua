#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TerminideWalkingLandUnit = import('/lua/defaultunits.lua').TerminideWalkingLandUnit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon
local EffectTemplate = import("/lua/effecttemplates.lua")

TEL0101 = Class(TerminideWalkingLandUnit) {
    Weapons = {
        MainGun = Class(AcidWeapon) {
        },
    },	
}
TypeClass = TEL0101

