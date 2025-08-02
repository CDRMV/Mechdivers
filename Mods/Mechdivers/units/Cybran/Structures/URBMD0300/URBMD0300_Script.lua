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
local CDFHLaserFusionWeapon = ModWeaponsFile.CDFHLaserFusionWeapon

URBMD0300 = Class(CStructureUnit) {
       Weapons = {
		MainGun = Class(CDFHLaserFusionWeapon) {
		
		IdleState = State (CDFHLaserFusionWeapon.IdleState) {
        Main = function(self)
                    CDFHLaserFusionWeapon.IdleState.Main(self)
                end,
                
        OnGotTarget = function(self)
				self.unit:ShowBone('Light', true)
               CDFHLaserFusionWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
			self.unit:ShowBone('Light', true)
               CDFHLaserFusionWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
			self.unit:HideBone('Light', true)
            CDFHLaserFusionWeapon.OnLostTarget(self)
        end,  	
		
		
		PlayFxMuzzleChargeSequence  = function(self)
		self.unit:ShowBone('Turret_Muzzle_Effect', true)
        local unit = self.unit
        local army = self.Army
        local scale = self.FxChargeMuzzleFlashScale
        for _, effect in self.FxChargeMuzzleFlash do
            CreateAttachedEmitter(unit, 'Turret_Muzzle', army, effect):ScaleEmitter(scale)
        end
        end, 

        PlayFxMuzzleSequence = function(self)
		self.unit:HideBone('Turret_Muzzle_Effect', true)
		local unit = self.unit
        local army = self.Army
        local scale = self.FxMuzzleFlashScale
        for _, effect in self.FxMuzzleFlash do
            CreateAttachedEmitter(unit, 'Turret_Muzzle', army, effect):ScaleEmitter(scale)
        end
        end,		
		},
	},
	
	OnCreate = function(self)
		self:HideBone('Turret_Muzzle_Effect', false)
		self:HideBone('Light', false)
		CStructureUnit.OnCreate(self)
    end,
}

TypeClass = URBMD0300