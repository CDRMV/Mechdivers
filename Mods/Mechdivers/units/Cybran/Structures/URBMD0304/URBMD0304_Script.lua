#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2302/URB2302_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Long Range Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local CIFArtilleryWeapon = import('/lua/cybranweapons.lua').CIFArtilleryWeapon
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

URBMD0304 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(CIFArtilleryWeapon) {
            FxMuzzleFlashScale = 0.6,
            FxGroundEffect = EffectTemplate.CDisruptorGroundEffect,
	        FxVentEffect = EffectTemplate.CDisruptorVentEffect,
	        FxMuzzleEffect = EffectTemplate.CElectronBolterMuzzleFlash01,
	        FxCoolDownEffect = EffectTemplate.CDisruptorCoolDownEffect,
    
		PlayFxRackSalvoReloadSequence = function(self)
		ForkThread( function()
		local OldFireState = self.unit:GetFireState()
		self.unit:SetFireState('HoldFire')
		local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
		self:SetTurretPitch(0,0)
		WaitSeconds(1)
        local bp = self.Blueprint
            self.unit.Animator:PlayAnim('/Mods/Mechdivers/units/Cybran/Structures/URBMD0304/URBMD0304_Reload.sca', false):SetRate(0.2)
			if self.unit.Animator == nil then

			else
			WaitFor(self.unit.Animator)
			self.unit:HideBone('Fusion_Capsule', true)
			self.unit.Animator:SetRate(-0.2)
			WaitFor(self.unit.Animator)
			self.unit:ShowBone('Fusion_Capsule', true)
			end
			self:SetTurretPitch(turretpitchmin, turretpitchmax)
			self.unit:SetFireState(OldFireState)
			end)
		end,

	        PlayFxMuzzleSequence = function(self, muzzle)
		        local army = self.unit:GetArmy()
		        DefaultProjectileWeapon.PlayFxMuzzleSequence(self, muzzle)
	            for k, v in self.FxGroundEffect do
                    CreateAttachedEmitter(self.unit, 'URBMD0304', army, v)
                end
  	            for k, v in self.FxMuzzleEffect do
                    CreateAttachedEmitter(self.unit, 'Muzzle', army, v)
                end
  	            for k, v in self.FxCoolDownEffect do
                    CreateAttachedEmitter(self.unit, 'Barrel_Recoil', army, v)
                end
            end,
        }
    },
	
	OnCreate = function(self)
		local animator = CreateAnimator(self)
        self.Animator = animator
        CStructureUnit.OnCreate(self)
    end,
}

TypeClass = URBMD0304