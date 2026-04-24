#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').StructureUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon


Autocannon = Class(DummyUnit) {

    Weapons = {
		Cannon = Class(TDFGaussCannonWeapon){
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'Autocannon_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'Autocannon_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },  
	  
}
TypeClass = Autocannon