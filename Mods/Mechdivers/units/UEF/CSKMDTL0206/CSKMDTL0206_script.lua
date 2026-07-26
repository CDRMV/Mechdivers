#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local Buff = import('/lua/sim/Buff.lua')
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities

CSKMDTL0206 = Class(TLandUnit) {

    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
        MachineGun = Class(TDFMachineGunWeapon) {
        },
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		if not self.AnimationManipulator1 then
            self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0206/CSKMDTL0206_Box2.sca', false):SetRate(0)
		self.Box = 0
		self.Buffed = false
		self.BuffTime = 10
		self:SetWeaponEnabledByLabel('Dummy', false)
    end,
	
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)	
		ForkThread( function()
		if bit == 1 then 
		self.Buffed = true
		if self.Box == 0 then
		self:HideBone('Box1', true)
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0206/CSKMDTL0206_Box3.sca', false):SetRate(0)
		end
		if self.Box == 1 then
		self:HideBone('Box2', true)
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0206/CSKMDTL0206_Box4.sca', false):SetRate(0)
		end
		if self.Box == 2 then
		self:HideBone('Box3', true)
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0206/CSKMDTL0206_Box5.sca', false):SetRate(0)
		end
		if self.Box == 3 then
		self:HideBone('Box4', true)
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		end
		if self.Box == 4 then
		self:HideBone('Box5', true)
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		end
		self.Box = self.Box + 1
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		WaitSeconds(self.BuffTime) -- Set the General Duration of the Weapon Buff
		self.Buffed = false
		self.GiveTemporaryWeaponBuffThreadHandle = self:ForkThread(self.GiveTemporaryWeaponBuffThread)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		elseif bit == 4 then
		self:SetSpeedMult(2)
		end
		end)
	end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread( function()
		if bit == 1 then 

		elseif bit == 4 then
		self:SetSpeedMult(1)
		end
		end)
    end,

	GiveTemporaryWeaponBuffThread = function(self)
			local unitPos = self:GetPosition()
			local radius = 5
			if not Buffs['ROFBuff'] then
             BuffBlueprint {
			Name = 'ROFBuff',
			DisplayName = 'ROFBuff',
			BuffType = 'ROF',
			Stacks = 'REPLACE',
			Duration = 0,
			Affects = {
				RateOfFire = {
			    Add = -0.5,
				
				},   
			},
            }   
            end
			while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
			if unit:GetFractionComplete() == 1 and self.Buffed == true then
			    if GetDistanceBetweenTwoEntities(unit, self) < 6 then
				if not Buff.HasBuff(unit, 'ROFBuff') then
					Buff.ApplyBuff(unit, 'ROFBuff')
				end	
                end
				if GetDistanceBetweenTwoEntities(unit, self) > 6 then
				if Buff.HasBuff(unit, 'ROFBuff') then
					Buff.RemoveBuff(unit, 'ROFBuff')
				end	
				end 
            end
			if unit:GetFractionComplete() == 1 and self.Buffed == false then
			    if GetDistanceBetweenTwoEntities(unit, self) < 6 then
				if Buff.HasBuff(unit, 'ROFBuff') then
					Buff.RemoveBuff(unit, 'ROFBuff')
				end	
                end
            end
            end
			WaitSeconds(5)
			end
    end,
}

TypeClass = CSKMDTL0206