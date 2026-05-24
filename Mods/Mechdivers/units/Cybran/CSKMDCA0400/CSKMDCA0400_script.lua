#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

CSKMDCA0400 = Class(CAirUnit) {
	Weapons = {

    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCA0400/CSKMDCA0400_AOpen.sca', false):SetRate(0)
    end,
	
	OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(-1)
        end
    end,

}

TypeClass = CSKMDCA0400