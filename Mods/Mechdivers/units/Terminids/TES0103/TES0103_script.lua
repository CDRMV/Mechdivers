#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0103/UES0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Frigate Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TSeaUnit = import('/lua/defaultunits.lua').SeaUnit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon

TES0103 = Class(TSeaUnit) {

    Weapons = {
        MainGun = Class(AcidWeapon) {
        },
    },
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TES0103/TES0103_A01.sca', false):SetRate(2)
        TSeaUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TES0103/TES0103_ASwim01.sca', true):SetRate(1)	
    end,
}

TypeClass = TES0103