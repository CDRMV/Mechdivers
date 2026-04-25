#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

L_Autocannon = Class(DummyUnit) {

    Weapons = {
		Cannon = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'Cannon_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'Cannon_Shell01', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'Cannon_Shell02', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },  
	  
}
TypeClass = L_Autocannon