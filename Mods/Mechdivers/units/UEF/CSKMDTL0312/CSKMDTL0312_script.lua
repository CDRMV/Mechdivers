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
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TMobileKamikazeBombWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TMobileKamikazeBombWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CSKMDTL0312 = Class(TLandUnit) {

    Weapons = {
		ACGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'L_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		if not self.AnimationManipulator1 then
            self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_ADeploy.sca', false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.Mech = nil
    end,
	
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)	
		ForkThread( function()
		if bit == 1 then 
		self:SetImmobile(true)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('Mech_Crane_Attach')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddToggleCap('RULEUTC_IntelToggle')
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
		elseif bit == 7 then 
		local position = self.Beacon:GetPosition()
		local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.MODULARMECH + categories.TECH3, position, 10, 'Ally')
		local number = 0
		local Mech = nil
        for _,unit in units do
			if unit:IsUnitState('WaitForFerry') then
			if number < 1 then
			unit:AttachBoneTo('AttachPoint', self, 'Mech_Crane_Attach')
			unit:SetDoNotTarget(true)
			unit:SetUnSelectable(true)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			IssueClearCommands({unit})
			self.Mech = unit
			number = number + 1
			else
			end
			else
            end
		end
		if self.Beacon then
		self.Beacon:Destroy()
		end
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 1 then
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_LCrane.sca', false)
		else
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_RCrane.sca', false)
		end
		self.AnimationManipulator2:SetRate(0.2)
		WaitFor(self.AnimationManipulator2)
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:AttachBoneTo(-2, self, 'Mech_Attachpoint')
		end
		end
		end)
	end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread( function()
		if bit == 1 then 
		if self.Beacon then
		self.Beacon:Destroy()
		end
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator1:SetRate(-1)
		WaitFor(self.AnimationManipulator1)
		self:SetImmobile(false)
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		elseif bit == 7 then 
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:AttachBoneTo('AttachPoint', self, 'Mech_Crane_Attach')
		end
		self.AnimationManipulator2:SetRate(-0.2)
		WaitFor(self.AnimationManipulator2)
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:SetDoNotTarget(false)
		self.Mech:SetUnSelectable(false)
		self.Mech:AddCommandCap('RULEUCC_Attack')
		self.Mech:AddCommandCap('RULEUCC_RetaliateToggle')
		self.Mech:AddCommandCap('RULEUCC_Stop')
		local Position = self.Mech:GetPosition()
		IssueMove({self.Mech}, {Position[1], Position[2], Position[3] - 2})
		self.Mech = nil
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('Mech_Crane_Attach')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		end)
    end,
	

}

TypeClass = CSKMDTL0312