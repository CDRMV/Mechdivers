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

CSKMDCL0103 = Class(CWalkingLandUnit) {
	Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
			local number = math.random(1,2)
			if number == 1 then
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0103/CSKMDCL0103_ASword01.sca', false):SetRate(2)
			else
			animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0103/CSKMDCL0103_ASword02.sca', false):SetRate(2)
			end
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
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
	
}

TypeClass = CSKMDCL0103