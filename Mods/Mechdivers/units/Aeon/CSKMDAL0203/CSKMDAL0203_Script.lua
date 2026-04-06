#****************************************************************************
#**
#**  File     :  /data/units/XAL0203/XAL0203_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Assault Tank Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AHoverLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFQuantumAutogunWeapon = import('/lua/aeonweapons.lua').ADFQuantumAutogunWeapon
local ModTexPath = '/mods/Mechdivers/textures/particles/'

CSKMDAL0203 = Class(AHoverLandUnit) {
    Weapons = {
		LightningWeapon = Class(ADFQuantumAutogunWeapon) {
			PlayFxWeaponPackSequence = function(self)
			self.unit.OpenAnimManip:SetRate(-2)
                ADFQuantumAutogunWeapon.PlayFxWeaponPackSequence(self)
    end,
        
    PlayFxRackSalvoChargeSequence = function(self)
self.unit.OpenAnimManip:SetRate(2)
                ADFQuantumAutogunWeapon.PlayFxRackSalvoChargeSequence(self)
    end, 
		},
    },
	
	OnCreate = function(self)
        AHoverLandUnit.OnCreate(self)
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0203/CSKMDAL0203_Attack.sca', false):SetRate(0)
			self.OpenAnimManip2 = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip2)
			self.OpenAnimManip2:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0203/CSKMDAL0203_Fly.sca', true):SetRate(1)
			self.EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Effect1 = CreateAttachedBeam(self,self.EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedBeam(self,self.EffectBones[2],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect2)
    end,
	 
}
TypeClass = CSKMDAL0203