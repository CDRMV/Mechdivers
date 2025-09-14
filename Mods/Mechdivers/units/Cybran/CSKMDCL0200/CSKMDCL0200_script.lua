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
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon

CSKMDCL0200 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.build = true
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('CSKMDCL0100', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo(-2, self, 'Bot')
		self.unit:SetDoNotTarget(true)
		self.unit:SetWeaponEnabledByLabel('MainGun', false)
		self.unit:SetCollisionShape('Box', 0, 0, 0, 0, 0 ,0)
		self.unit:HideBone(0, true)
		self.unit:SetUnSelectable(true)
		self.unit:HideRifle()
		self:EnableShield()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:AddToggleCap('RULEUTC_ShieldToggle')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0200/CSKMDCL0200_Afold01.sca', false):SetRate(0)
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(2)
		elseif bit == 0 then 
		ForkThread(function()
		self:RemoveCommandCap('RULEUCC_Move')
		self:RemoveCommandCap('RULEUCC_Attack')
		self:SetImmobile(true)
		self.AnimationManipulator:SetRate(1)
		WaitFor(self.AnimationManipulator)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_IntelToggle')
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:SetScriptBit('RULEUTC_ShieldToggle', true)
		self:SetWeaponEnabledByLabel('MainGun', false)
		LOG(self:GetScriptBit(7))
		end)
		elseif bit == 7 then
		if self.build == true then
		self:SetScriptBit('RULEUTC_SpecialToggle', false)
		self.build = false
		else
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
            for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == 'Trooper' then
			if number < 1 then
			unit:AttachBoneTo(-2, self, 'Bot')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('MainGun', false)
			unit:SetUnSelectable(true)
			unit:HideBone(0, true)
			unit:HideRifle()
			unit:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
			self:SetScriptBit('RULEUTC_ShieldToggle', false)
			--self:RemoveToggleCap('RULEUTC_SpecialToggle')
			self:AddToggleCap('RULEUTC_ShieldToggle')
			self:ShowBone('Bot', true)
			self:SetWeaponEnabledByLabel('MainGun', true)
			number = number + 1
			else
			end
			else
            end
			end	
		end	
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
        end	
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
		elseif bit == 0 then 
		ForkThread(function()
		self.Beacon:Destroy()
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator:SetRate(-1)
		WaitFor(self.AnimationManipulator)
		self:SetImmobile(false)
		self:AddCommandCap('RULEUCC_Move')
		self:AddCommandCap('RULEUCC_Attack')
		self:SetWeaponEnabledByLabel('MainGun', true)
		end)
		elseif bit == 7 then
		local units = self:GetCargo()
		local position = self:GetPosition()
		self:HideBone('Bot', true)
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			unit:ShowBone(0, true)
			unit:ShowRifle()
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit:SetWeaponEnabledByLabel('MainGun', true)
			unit:SetCollisionShape('Box', 0, 0,0, 0.6, 0.6, 0.6)
			unit:DetachFrom(true)
			self:RemoveToggleCap('RULEUTC_ShieldToggle')
			self:SetWeaponEnabledByLabel('MainGun', false)
			self:SetDoNotTarget(true)
        end
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		end
    end,
	
	OnTransportDetach = function(self, attachBone, unit)
        CWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        unit:AttachBoneTo(-2, self, 'Bot')
    end,
	
	
}

TypeClass = CSKMDCL0200