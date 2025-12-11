#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2101/URB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local CDFLaserHeavyWeapon = import('/lua/cybranweapons.lua').CDFLaserHeavyWeapon


URBMD0105 = Class(CStructureUnit) {

    Weapons = {
        MainGun = Class(CDFLaserHeavyWeapon) {}
    },
	
	OnCreate = function(self)
        CStructureUnit.OnCreate(self)
		self:HideBone('Bot', true)
		self:ShowBone('Barrel', true)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
		if self:GetAIBrain().BrainType == 'Human' then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.load = false
		self:RemoveCommandCap('RULEUCC_Transport')
		self:AddToggleCap('RULEUTC_IntelToggle')
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:SetWeaponEnabledByLabel('MainGun', false)
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveCommandCap('RULEUCC_Stop')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.Animation, false):SetRate(0)	
		else
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.Animation, false):SetRate(1)	
		self.load = true
		self:ShowBone('Bot', true)
		self:HideBone('B01', true)
		end
    end,
	
		
	OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
		if bit == 1 then
		self.load = false
		local units = self:GetCargo()
		local position = self:GetPosition()
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			unit:ShowBone(0, true)
			unit:HideBone('B01', true)
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit:SetWeaponEnabledByLabel('MainGun', true)
			unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			unit:ShowRifle()
			unit:DetachFrom(true)
			unit:AddCommandCap('RULEUCC_Attack')
			unit:AddCommandCap('RULEUCC_RetaliateToggle')
			unit:AddCommandCap('RULEUCC_Stop')
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:RemoveCommandCap('RULEUCC_Stop')
			self:SetWeaponEnabledByLabel('MainGun', false)
			self:HideBone('Bot', true)
			self:ShowBone('Barrel', true)
			self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.Animation, false):SetRate(-2)	
        end	
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
        end	
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
		if bit == 1 then
		self.load = true
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
        for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == 'Trooper' then
			if number < 1 then
			unit:AttachBoneTo(-2, self, 'AttachPoint')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('MainGun', false)
			unit:SetUnSelectable(true)
			unit:HideBone(0, true)
			unit:HideRifle()
			unit:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			IssueClearCommands({unit})
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:AddCommandCap('RULEUCC_Stop')
			self:ShowBone('Bot', true)
			self:HideBone('B01', true)
			self:SetWeaponEnabledByLabel('MainGun', true)
			self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.Animation, false):SetRate(2)	
			number = number + 1
			else
			end
			else
            end
		end	
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		end
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Beacon then
	self.Beacon:Destroy()
	end	
	
	if self.load == false then
	
	else
	self:HideBone('Bot', true)
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
	SetIgnoreArmyUnitCap(self:GetArmy(), true)
	local position = self:GetPosition()
	local orientation = self:GetOrientation()
	local angle = 2 * math.acos(orientation[2])
	self.unit = CreateUnitHPR('CSKMDCL0100', self:GetArmy(), position[1], position[2], position[3], 0, angle, 0)
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
	end
	end
	
	
    CStructureUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	
	OnReclaimed = function(self, reclaimer)
		
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		local units = self:GetCargo()
		if units[1] == nil then
		
		else
		if self.Bot then
			self.Bot:Destroy()
			units[1]:ShowBone(0, true)
			units[1]:SetDoNotTarget(false)
			units[1]:SetUnSelectable(false)
			units[1]:SetWeaponEnabledByLabel('MainGun', true)
			units[1]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[1]:DetachFrom(true)
			units[1]:AddCommandCap('RULEUCC_Attack')
			units[1]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[1]:AddCommandCap('RULEUCC_Stop')
		else
		
		end
		
		end
    end,
}

TypeClass = URBMD0105
