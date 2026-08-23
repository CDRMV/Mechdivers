#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0101/UEA0101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  UEF Scout Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDGuideMissile01 = Class(TAirUnit) {
    Weapons = {
	    Dummy = Class(DummyTurretWeapon) {},
	},	

    DestructionPartsLowToss = {'CSKUJP0100'},
    DestroySeconds = 7.5,
	
	OnCreate = function(self)
		TAirUnit.OnCreate(self)
		self:ForkThread(
        function()
		self:HideBone(0, true)

		end
        )
	end, 
	
}

TypeClass = CSKMDGuideMissile01