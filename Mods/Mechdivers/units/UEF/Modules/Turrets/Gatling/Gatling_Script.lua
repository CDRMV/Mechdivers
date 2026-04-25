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
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

Gatling = Class(DummyUnit) {

    Weapons = {
		GatlingCannon = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Turret_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gatling_Turret_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gatling_Turret_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },  
	  
}
TypeClass = Gatling