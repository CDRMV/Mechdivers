#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local Effects = import('/lua/effecttemplates.lua')

CSKMDAL0300 = Class(AWalkingLandUnit) {    
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
		LGun = Class(ADFCannonQuantumWeapon) {
		OnWeaponFired = function(self)
		ForkThread(function()
        ADFCannonQuantumWeapon.OnLostTarget(self)
		ChangeState(self, self.RackSalvoReloadState)
		WaitSeconds(2)
		ChangeState(self, self.IdleState)
		WaitSeconds(2)
		self:SetEnabled(false)
		WaitSeconds(2)
		self.unit.LGatlingGun:SetEnabled(true)
		end)
		end,  
		},
		RGun = Class(ADFCannonQuantumWeapon) {
		OnWeaponFired = function(self)
		ForkThread(function()
        ADFCannonQuantumWeapon.OnLostTarget(self)
		ChangeState(self, self.RackSalvoReloadState)
		WaitSeconds(2)
		ChangeState(self, self.IdleState)
		WaitSeconds(2)
		self:SetEnabled(false)
		WaitSeconds(2)
		self.unit.RGatlingGun:SetEnabled(true)
		end)
		end, 
		},
		LGatlingGun = Class(ADFCannonQuantumWeapon) {
		OnWeaponFired = function(self)
		ForkThread(function()
        ADFCannonQuantumWeapon.OnLostTarget(self)
		self:SetEnabled(false)
		WaitSeconds(2)
		ChangeState(self, self.IdleState)
		WaitSeconds(5)
		self.unit.LGun:SetEnabled(true)
		end)
		end, 
		    PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                     self.SpinManip:SetSpinDown(true)
					 WaitFor(self.SpinManip)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Arm_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                ADFCannonQuantumWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Arm_Barrel_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
				self.SpinManip:SetSpinDown(false)
                    self.SpinManip:SetTargetSpeed(500)
                end
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
				self.SpinManip:SetSpinDown(false)
                    self.SpinManip:SetTargetSpeed(500)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Arm_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
		},
		RGatlingGun = Class(ADFCannonQuantumWeapon) {
		OnWeaponFired = function(self)
		ForkThread(function()
        ADFCannonQuantumWeapon.OnLostTarget(self)
		self:SetEnabled(false)
		WaitSeconds(2)
		ChangeState(self, self.IdleState)
		WaitSeconds(5)
		self.unit.RGun:SetEnabled(true)
		end)
		end, 
			PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetSpinDown(true)
					WaitFor(self.SpinManip)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Arm_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                ADFCannonQuantumWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_Arm_Barrel_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
				self.SpinManip:SetSpinDown(false)
                    self.SpinManip:SetTargetSpeed(500)
                end
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
				self.SpinManip:SetSpinDown(false)
                    self.SpinManip:SetTargetSpeed(500)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Arm_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.LGun = self:GetWeaponByLabel('LGun')
		self.RGun = self:GetWeaponByLabel('RGun')
	    self.LGatlingGun = self:GetWeaponByLabel('LGatlingGun')
		self.RGatlingGun = self:GetWeaponByLabel('RGatlingGun')
		self.LGatlingGun:SetEnabled(false)
		self.RGatlingGun:SetEnabled(false)
		if self:GetAIBrain().BrainType == 'Human' then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('UAL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo(-2, self, 'Spawn')
		self.unit:SetDoNotTarget(true)
		self.unit.CanTakeDamage = false
		self.unit.CanBeKilled = false
		self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', false)
		self.unit:RemoveCommandCap('RULEUCC_Attack')
		self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.unit:RemoveCommandCap('RULEUCC_Stop')
		self.unit:SetCollisionShape('Box', 0, 0, 0, 0, 0 ,0)
		self.unit:SetUnSelectable(true)
		--self.unit:HideRifle()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		EffectMesh1 = '/effects/entities/AeonShield01/AeonShield01_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 'Shield' )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.6)
		end
		self:RemoveCommandCap('RULEUCC_Transport')
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Effect1 then
	self.Effect1:Destroy()
	end	
	
	
	ForkThread(function()
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
			self.unit:ShowBone(0, true)
			self.unit:SetDoNotTarget(false)
			self.unit:SetUnSelectable(false)
			self.unit.CanTakeDamage = true
			self.unit.CanBeKilled = true
			self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', true)
			self.unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			self.unit:DetachFrom(true)
			self.unit:AddCommandCap('RULEUCC_Attack')
			self.unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.unit:AddCommandCap('RULEUCC_Stop')
	else
	self.unit:Destroy()
	end		
	end)
	
	AWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	OnReclaimed = function(self, reclaimer)
	if self.Effect1 then
	self.Effect1:Destroy()
	end	
		
			self.unit:ShowBone(0, true)
			self.unit:SetDoNotTarget(false)
			self.unit:SetUnSelectable(false)
			self.unit.CanTakeDamage = true
			self.unit.CanBeKilled = true
			self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', true)
			self.unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			self.unit:DetachFrom(true)
			self.unit:AddCommandCap('RULEUCC_Attack')
			self.unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.unit:AddCommandCap('RULEUCC_Stop')
    end,
	

}

TypeClass = CSKMDAL0300