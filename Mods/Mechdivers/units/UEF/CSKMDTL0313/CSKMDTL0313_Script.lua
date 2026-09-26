#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0201/UEL0201_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Medium Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

CSKMDTL0308 = Class(TLandUnit) {
    Weapons = {
        MainGun = Class(TDFMachineGunWeapon) {
		    PlayFxWeaponPackSequence = function(self)
                if self.SpinManip and self.SpinManip2 then
                    self.SpinManip:SetTargetSpeed(0)
					self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip and not self.SpinManip2 then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
					self.SpinManip2 = CreateRotator(self.unit, 'R_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                
                if self.SpinManip and self.SpinManip2 then
                    self.SpinManip:SetTargetSpeed(500)
					self.SpinManip2:SetTargetSpeed(-500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip and self.SpinManip2 then
                    self.SpinManip:SetTargetSpeed(200)
					self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
				self.ExhaustEffects2 = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
		
		},
		MissileWeapon = Class(TIFCruiseMissileLauncher) 
        {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
			
        },
    },
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		local location = self:GetPosition()
			local SmokeUnit = CreateUnitHPR('UEFSSP0100b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 

        end
    end,
}

TypeClass = CSKMDTL0308