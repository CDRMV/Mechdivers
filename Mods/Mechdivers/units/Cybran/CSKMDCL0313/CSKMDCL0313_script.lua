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
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local CDFHLaserFusionWeapon2 = ModWeaponsFile.CDFHLaserFusionWeapon2
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local ModEffects = '/mods/Mechdivers/effects/emitters/'

CSKMDCL0313 = Class(CWalkingLandUnit) {
	ChargeEffects = {
		ModEffects .. 'heavyfusion_flash_01_emit.bp',
        ModEffects .. 'heavyfusion_flash_02_emit.bp',
        ModEffects .. 'heavyfusion_flash_03_emit.bp',
    },
    Weapons = {
        MainGun = Class(CDFHLaserFusionWeapon2) {
		PlayFxRackSalvoChargeSequence = function(self)
		ForkThread( function()
        local bp = self.Blueprint
        local muzzleBones = {
	'R_Muzzle',
	'L_Muzzle',
    }
        for _, effect in self.unit.ChargeEffects do
            for _, muzzle in muzzleBones do
                CreateAttachedEmitter(self.unit, muzzle, self.unit:GetArmy(), effect):ScaleEmitter(1)
				WaitSeconds(1)
            end
        end
        local chargeStart = bp.Audio.ChargeStart
        if chargeStart then
            self:PlaySound(chargeStart)
        end
		end)
		end,
		
		},
		MissileRack = Class(CIFGrenadeWeapon) {},
		Dummy = Class(DummyTurretWeapon) {},
    },
	
}

TypeClass = CSKMDCL0313