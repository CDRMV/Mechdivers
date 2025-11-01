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
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDCL0307 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
            DummyTurretWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
			local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			wep1:SetEnabled(true)
            DummyTurretWeapon.OnLostTarget(self)
        end,  
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
			local number = math.random(1,2)
			if number == 1 then
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0307/CSKMDCL0307_ASaw01.sca', false):SetRate(2)
			else
			animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0307/CSKMDCL0307_ASaw02.sca', false):SetRate(2)
			end
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
        Flamethrower = Class(TDFMachineGunWeapon) {},
    },
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(2)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        end
    end,
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self.FireEffect = CreateAttachedEmitter(self,'L_Arm_Fire',self:GetArmy(), '/effects/emitters/op_ambient_fire_01_emit.bp'):ScaleEmitter(0.05)
		self.SawEffect = CreateAttachedEmitter(self,'R_Arm_Saw',self:GetArmy(), '/effects/emitters/destruction_damaged_sparks_01_emit.bp'):ScaleEmitter(0.8)
		self.Saw = CreateRotator(self, 'R_Arm_Saw', 'x', nil, 0, 60, 360):SetTargetSpeed(270)
		self:HideBone('B01', true)
    end,
}

TypeClass = CSKMDCL0307