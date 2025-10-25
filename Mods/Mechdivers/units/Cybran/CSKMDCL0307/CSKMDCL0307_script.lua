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
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0307/CSKMDCL0307_ASaw01.sca', false):SetRate(2)
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
		self.Saw = CreateRotator(self, 'R_Arm_Saw', 'x', nil, 0, 60, 360):SetTargetSpeed(270)
    end,
}

TypeClass = CSKMDCL0307