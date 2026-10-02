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

TEL0102 = Class(TWalkingLandUnit) {
    Weapons = {
		Melee = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Terminids/TEL0102/TEL0102_AMelee01.sca', false):SetRate(2)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
    },
}
TypeClass = TEL0102

