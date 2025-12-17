#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

UEBMD00300b = Class(TStructureUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {
		OnWeaponFired = function(self)
		local bp = self:GetBlueprint()
		if self.CurrentRackSalvoNumber == 2 then 
		self.unit:HideBone('Missile01', true)
		end
		
		if self.CurrentRackSalvoNumber == 3 then 
		self.unit:HideBone('Missile02', true)
		end
		
		if self.CurrentRackSalvoNumber == 4 then 
		self.unit:HideBone('Missile03', true)
		end
		
		if self.CurrentRackSalvoNumber == 5 then 
		self.unit:HideBone('Missile04', true)
		end
		
		if self.CurrentRackSalvoNumber == 6 then 
		self.unit:HideBone('Missile05', true)
		end
		
		if self.CurrentRackSalvoNumber == 7 then 
		self.unit:HideBone('Missile06', true)
		end
		
		if self.CurrentRackSalvoNumber == 8 then 
		self.unit:HideBone('Missile07', true)
		end
		
		if self.CurrentRackSalvoNumber == 9 then 
		self.unit:HideBone('Missile08', true)
		end
		
		if self.CurrentRackSalvoNumber == 10 then 
		self.unit:HideBone('Missile09', true)
		end
		
		if self.CurrentRackSalvoNumber == 11 then 
		self.unit:HideBone('Missile10', true)
		end
		
		if self.CurrentRackSalvoNumber == 12 then 
		self.unit:HideBone('Missile11', true)
		end
		
		if self.CurrentRackSalvoNumber == 13 then 
		self.unit:HideBone('Missile12', true)
		end
		
		if self.CurrentRackSalvoNumber == 14 then 
		self.unit:HideBone('Missile13', true)
		end
		
		if self.CurrentRackSalvoNumber == 15 then 
		self.unit:HideBone('Missile14', true)
		end
		
		if self.CurrentRackSalvoNumber == 16 then 
		self.unit:HideBone('Missile15', true)
		end
		
		if self.CurrentRackSalvoNumber == 17 then 
		self.unit:HideBone('Missile16', true)
		end
		
		if self.CurrentRackSalvoNumber == 18 then 
		self.unit:HideBone('Missile17', true)
		end
		
		if self.CurrentRackSalvoNumber == 19 then 
		self.unit:HideBone('Missile18', true)
		end
		
		if self.CurrentRackSalvoNumber == 20 then 
		self.unit:HideBone('Missile19', true)
		end
		
		if self.CurrentRackSalvoNumber == 21 then 
		self.unit:HideBone('Missile20', true)
		end
		
		if self.CurrentRackSalvoNumber == 22 then 
		self.unit:HideBone('Missile21', true)
		end
		
		if self.CurrentRackSalvoNumber == 23 then 
		self.unit:HideBone('Missile22', true)
		end
		
		if self.CurrentRackSalvoNumber == 24 then 
		self.unit:HideBone('Missile23', true)
		end
		
		if self.CurrentRackSalvoNumber == 25 then 
		self.unit:HideBone('Missile24', true)
		end
		
		end,
		
		},
    },
	
	OnCreate = function(self)
		ForkThread( function()
		while true do
		self:FlattenSkirt()
		WaitSeconds(0.1)
		end
		end)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(0)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack1, false):SetRate(1)	
		if not self.AnimationUnpack2Manipulator then
            self.AnimationUnpack2Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack2Manipulator)
        end
        self.AnimationUnpack2Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(0)
		if not self.AnimationUnpack3Manipulator then
            self.AnimationUnpack3Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack3Manipulator)
        end
        self.AnimationUnpack3Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack3, false):SetRate(0)
		if not self.AnimationUnpack4Manipulator then
            self.AnimationUnpack4Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack4Manipulator)
        end
        self.AnimationUnpack4Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack4, false):SetRate(-1)	
        TStructureUnit.OnCreate(self)
    end,
	
	CheckSiloAmount = function(self)
		if self:GetTacticalSiloAmmoCount() == 24 then 
		self:ShowBone('Missile24', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 23 then 
		self:ShowBone('Missile23', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 22 then 
		self:ShowBone('Missile22', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 21 then 
		self:ShowBone('Missile21', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 20 then 
		self:ShowBone('Missile20', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 19 then 
		self:ShowBone('Missile19', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 18 then 
		self:ShowBone('Missile18', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 17 then 
		self:ShowBone('Missile17', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 16 then 
		self:ShowBone('Missile16', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 15 then 
		self:ShowBone('Missile15', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 14 then 
		self:ShowBone('Missile14', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 13 then 
		self:ShowBone('Missile13', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 12 then 
		self:ShowBone('Missile12', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 11 then 
		self:ShowBone('Missile11', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 10 then 
		self:ShowBone('Missile10', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 9 then 
		self:ShowBone('Missile09', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 8 then 
		self:ShowBone('Missile08', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 7 then 
		self:ShowBone('Missile07', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 6 then 
		self:ShowBone('Missile06', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 5 then 
		self:ShowBone('Missile05', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 4 then 
		self:ShowBone('Missile04', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 3 then 
		self:ShowBone('Missile03', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 2 then 
		self:ShowBone('Missile02', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 1 then 
		self:ShowBone('Missile01', true)
		end
    end,
	
	OnSiloBuildStart = function(self, weapon)
		if self:GetTacticalSiloAmmoCount() == 24 then 
		self:ShowBone('Missile24', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 23 then 
		self:ShowBone('Missile23', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 22 then 
		self:ShowBone('Missile22', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 21 then 
		self:ShowBone('Missile21', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 20 then 
		self:ShowBone('Missile20', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 19 then 
		self:ShowBone('Missile19', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 18 then 
		self:ShowBone('Missile18', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 17 then 
		self:ShowBone('Missile17', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 16 then 
		self:ShowBone('Missile16', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 15 then 
		self:ShowBone('Missile15', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 14 then 
		self:ShowBone('Missile14', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 13 then 
		self:ShowBone('Missile13', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 12 then 
		self:ShowBone('Missile12', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 11 then 
		self:ShowBone('Missile11', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 10 then 
		self:ShowBone('Missile10', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 9 then 
		self:ShowBone('Missile09', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 8 then 
		self:ShowBone('Missile08', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 7 then 
		self:ShowBone('Missile07', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 6 then 
		self:ShowBone('Missile06', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 5 then 
		self:ShowBone('Missile05', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 4 then 
		self:ShowBone('Missile04', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 3 then 
		self:ShowBone('Missile03', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 2 then 
		self:ShowBone('Missile02', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 1 then 
		self:ShowBone('Missile01', true)
		end
        TStructureUnit.OnSiloBuildStart(self,weapon)
    end,
	
	OnSiloBuildEnd = function(self, weapon)
		if self:GetTacticalSiloAmmoCount() == 24 then 
		self:ShowBone('Missile24', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 23 then 
		self:ShowBone('Missile23', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 22 then 
		self:ShowBone('Missile22', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 21 then 
		self:ShowBone('Missile21', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 20 then 
		self:ShowBone('Missile20', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 19 then 
		self:ShowBone('Missile19', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 18 then 
		self:ShowBone('Missile18', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 17 then 
		self:ShowBone('Missile17', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 16 then 
		self:ShowBone('Missile16', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 15 then 
		self:ShowBone('Missile15', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 14 then 
		self:ShowBone('Missile14', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 13 then 
		self:ShowBone('Missile13', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 12 then 
		self:ShowBone('Missile12', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 11 then 
		self:ShowBone('Missile11', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 10 then 
		self:ShowBone('Missile10', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 9 then 
		self:ShowBone('Missile09', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 8 then 
		self:ShowBone('Missile08', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 7 then 
		self:ShowBone('Missile07', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 6 then 
		self:ShowBone('Missile06', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 5 then 
		self:ShowBone('Missile05', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 4 then 
		self:ShowBone('Missile04', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 3 then 
		self:ShowBone('Missile03', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 2 then 
		self:ShowBone('Missile02', true)
		end
		
		if self:GetTacticalSiloAmmoCount() == 1 then 
		self:ShowBone('Missile01', true)
		end
        TStructureUnit.OnSiloBuildEnd(self,weapon)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:CreateTarmac(true, true, true, false, false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.wep = self:GetWeaponByLabel('MissileRack01')
		self.wep:SetEnabled(false)
	end,
	
	CreateEnhancement = function(self, enh)
        TStructureUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'RaiseMissileLauncher' then
		
        elseif enh == 'RemoveRaiseMissileLauncher' then
		
		elseif enh == 'Guidance' then
		
		elseif enh == 'RemoveGuidance' then
		
		elseif enh == 'Targeting' then
		
		elseif enh == 'RemoveTargeting' then
		
		elseif enh == 'WarHead' then
		
		elseif enh == 'RemoveWarHead' then
		
		elseif enh == 'Propulsion' then
		
		elseif enh == 'RemovePropulsion' then
        end
    end,
	
    OnWorkBegin = function(self, work)
		TStructureUnit.OnWorkBegin(self, work)
		local tempEnhanceBp = self:GetBlueprint().Enhancements[work]
		if tempEnhanceBp.Name == '<LOC RaiseMissileLauncher>Raise surface to air launcher' then
		self.AnimationManipulator:SetRate(0.03)
		return true
		end
		if tempEnhanceBp.Name == '<LOC GuidanceSubsystem>Guidance Subsystem' then
		 self.AnimationUnpack1Manipulator:SetRate(-1)
		return true
		end
		if tempEnhanceBp.Name == '<LOC TargetingSubsystem>Targeting Subsystem' then
		 self.AnimationUnpack2Manipulator:SetRate(1)
		 return true
		end
		if tempEnhanceBp.Name == '<LOC WarheadSubsystem>Warhead Subsystem' then
		 self.AnimationUnpack3Manipulator:SetRate(1)
		 return true
		end
		if tempEnhanceBp.Name == '<LOC PropulsionSubsystem>Propulsion Subsystem' then
		 self.AnimationUnpack4Manipulator:SetRate(1)
		 ForkThread( function()	
		 WaitFor(self.AnimationUnpack4Manipulator)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Stop')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self.wep:SetEnabled(true)
		local number = 0
		while true do
		if self:GetTacticalSiloAmmoCount() == 0 then
		self:SetFireState('HoldFire')
		WaitSeconds(1)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		if number == 0 then
		number = 1
		if self:GetAIBrain().BrainType == 'Human' then
		while self:GetTacticalSiloAmmoCount() <= 24 do
		WaitSeconds(2)
		self:GiveTacticalSiloAmmo(1)
		self:CheckSiloAmount()
		end
		--self:AddCommandCap('RULEUCC_SiloBuildTactical')
		else
		while self:GetTacticalSiloAmmoCount() <= 24 do
		WaitSeconds(2)
		self:GiveTacticalSiloAmmo(1)
		self:CheckSiloAmount()
		end
		end
		end
		elseif self:GetTacticalSiloAmmoCount() == 25 then
		self:RemoveTacticalSiloAmmo(1)
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Stop')
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		WaitSeconds(1)
		self:SetFireState('ReturnFire')
		self:ShowBone('Missile24', true)
		number = 0
		--[[
		self:ShowBone('Missile24', true)
		if number == 1 then
		self:StopSiloBuild()
		self:RemoveCommandCap('RULEUCC_SiloBuildTactical')
		number = 0
		end
		]]--
		end
		WaitSeconds(0.1)
		end
		end)
		return true
		end
		return false
    end,	
}

TypeClass = UEBMD00300b