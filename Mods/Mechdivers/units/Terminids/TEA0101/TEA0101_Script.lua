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
local Unit = import('/lua/sim/Unit.lua').Unit
local TDFMachineGunWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon


TEA0101 = Class(TWalkingLandUnit) {
    Weapons = {
        ArmCannonTurret = Class(TDFMachineGunWeapon) {
        },
    },
	
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TEA0101/TEA0101_A01.sca', false):SetRate(0)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TEA0101/TEL0101_AWings01.sca', true):SetRate(2)	
        TWalkingLandUnit.OnCreate(self)
    end,
}
TypeClass = TEA0101

