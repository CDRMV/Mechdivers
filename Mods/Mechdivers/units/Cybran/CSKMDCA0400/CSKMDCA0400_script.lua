#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local CDFHLaserFusionWeapon2 = ModWeaponsFile.CDFHLaserFusionWeapon2
local ModEffects = '/mods/Mechdivers/effects/emitters/'

CSKMDCA0400 = Class(CAirUnit) {
	ChargeEffects = {
		ModEffects .. 'fusion_electricity_01_emit.bp',
		ModEffects .. 'heavyfusion_flash_01_emit.bp',
        ModEffects .. 'heavyfusion_flash_02_emit.bp',
        ModEffects .. 'heavyfusion_flash_03_emit.bp',
    },
	
	Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
		RailGun = Class(CDFHLaserFusionWeapon2) {
		PlayFxRackSalvoChargeSequence = function(self)
		ForkThread( function()
        local bp = self.Blueprint
        local muzzleBones = {
			'MainGun_Muzzle',
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
		MainGun = Class(CDFLaserFusionWeapon) {},
		MissileRack = Class(CIFGrenadeWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCA0400/CSKMDCA0400_AOpen.sca', false):SetRate(0)
    end,
	
	OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(-1)
        end
    end,

}

TypeClass = CSKMDCA0400