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
		ModEffects .. 'fusion_electricity_01_emit.bp',
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
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		ForkThread( function()
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0313/CSKMDCL0313_Afold01.sca', false):SetRate(1)
		end)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()
		self.AnimationManipulator:SetRate(-1)
		WaitFor(self.AnimationManipulator)
		self.AnimationManipulator:Destroy()
		while not self.Dead do
		self:SetWeaponEnabledByLabel('MissileRack', false)
		WaitSeconds(15)
		self:SetWeaponEnabledByLabel('MissileRack', true)
		WaitSeconds(15)
		end
		end)
    end,
	
}

TypeClass = CSKMDCL0313