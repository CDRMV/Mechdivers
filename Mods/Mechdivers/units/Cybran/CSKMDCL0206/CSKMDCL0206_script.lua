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
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDCL0206 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
			local number = math.random(1,3)
			if number == 1 then
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0205/CSKMDCL0206_ASaw01.sca', false):SetRate(2)
			elseif number == 2 then
			animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0206/CSKMDCL0206_ASaw02.sca', false):SetRate(2)
			elseif number == 3 then
			animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0206/CSKMDCL0206_ASaw03.sca', false):SetRate(2)
			end
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		if not self.AnimationManipulator2 then
         self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.AnimationManipulator2:PlayAnim('/mods/Mechdivers/units/Cybran/CSKMDCL0206/Saw.sca', true):SetRate(4)
		if not self.AnimationManipulator then
         self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/mods/Mechdivers/units/Cybran/CSKMDCL0206/CSKMDCL0206_Activate.sca', false):SetRate(2)
		if not self.AnimationManipulator3 then
         self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
        end
		self.AnimationManipulator3:PlayAnim('/mods/Mechdivers/units/Cybran/CSKMDCL0206/CSKMDCL0206_Attack.sca', false):SetRate(0)
		self.SawEffect1 = CreateAttachedEmitter(self,'R_Arm_Saw',self:GetArmy(), '/effects/emitters/destruction_damaged_sparks_01_emit.bp'):ScaleEmitter(0.4)
		self.SawEffect2 = CreateAttachedEmitter(self,'L_Arm_Saw',self:GetArmy(), '/effects/emitters/destruction_damaged_sparks_01_emit.bp'):ScaleEmitter(0.4)
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(1.8)
		self.AnimationManipulator3:SetRate(2)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
		self.AnimationManipulator3:SetRate(-2)
        end
    end,
}

TypeClass = CSKMDCL0206