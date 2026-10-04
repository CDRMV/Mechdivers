#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWalkingLandUnit = import('/lua/Defaultunits.lua').WalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

TEL0106 = Class(TWalkingLandUnit) {
    Weapons = {
		Melee = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Terminids/TEL0106/TEL0106_AMelee01.sca', false):SetRate(2)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
    },
	
	OnMotionHorzEventChange = function(self, new, old)
        TWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
        elseif new == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        TWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			local Oldlocation = self:GetPosition()
			local MovePos = self:GetCurrentMoveLocation()
			local LandUnit = nil 
			local bp = self:GetBlueprint()
			local AirDummyUnit = bp.Display.AirDummyUnit
			local aiBrain = self:GetAIBrain()
			local qx, qy, qz, qw = unpack(self:GetOrientation())
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			LandUnit = CreateUnit(AirDummyUnit,self:GetArmy(),Oldlocation[1], Oldlocation[2], Oldlocation[3],qx, qy, qz, qw, 0)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			self:AttachBoneTo(-2, LandUnit, 0)
			LandUnit:SetElevation(10)
            IssueTransportUnload({LandUnit}, MovePos)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        elseif bit == 7 then 
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
        end
    end,
}
TypeClass = TEL0106

