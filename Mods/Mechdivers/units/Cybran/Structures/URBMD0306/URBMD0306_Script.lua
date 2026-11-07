#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2301/URB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFFusionMortarWeapon = ModWeaponsFile.CDFFusionMortarWeapon

URBMD0305 = Class(CStructureUnit) {
       Weapons = {
		MainGun = Class(CDFFusionMortarWeapon) {		
		},
	},
}

TypeClass = URBMD0305