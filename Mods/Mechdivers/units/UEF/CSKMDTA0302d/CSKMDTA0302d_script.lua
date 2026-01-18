#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFCarpetBombWeapon = import('/lua/terranweapons.lua').TIFCarpetBombWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

CSKMDTA0302d = Class(TAirUnit) {
	Weapons = {
		Bomb = Class(TIFCarpetBombWeapon) {
		OnWeaponFired = function(self)
		ForkThread( function()
		WaitSeconds(1)
		self.unit:GetWeaponByLabel'DropFlare':FireWeapon()
		end
        )
		end,
		},
		DropFlare = Class(TDFGaussCannonWeapon) {
		FxMuzzleFlashScale = 0.05,
		},
    },


	OnCreate = function(self)
		TAirUnit.OnCreate(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTA0302/CSKMDTA0302_MainWings.sca', false):SetRate(2)
		
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		local number = math.random(1,2)
		if number == 1 then
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTA0302/CSKMDTA0302_LeftBelowWing.sca', false):SetRate(2)
		elseif number == 2 then
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTA0302/CSKMDTA0302_RightBelowWing.sca', false):SetRate(2)
		end
		self:HideBone('Bomb' ,true)
		self:HideBone('L_Gatling' ,true)
		self:HideBone('R_Gatling' ,true)
		self:HideBone('MissilePod' ,true)
		self:HideBone('L_MissilePod' ,true)
		self:HideBone('L_MissilePod2' ,true)
		self:HideBone('R_MissilePod' ,true)
		self:HideBone('R_MissilePod2' ,true)
    end,


	OnStopBeingBuilt = function(self,builder,layer)
		TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.AnimationManipulator:SetRate(-2)
		self.AnimationManipulator2:SetRate(-2)
    end,
	
	OnMotionVertEventChange = function(self, new, old)
	    TAirUnit.OnMotionVertEventChange(self, new, old)
        
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimationManipulator:SetRate(-2)
			self.AnimationManipulator2:SetRate(-2)
        elseif (new == 'Down') then
        self.AnimationManipulator:SetRate(2)
		self.AnimationManipulator2:SetRate(2)
        elseif (new == 'Up') then
			self.AnimationManipulator:SetRate(-2)
			self.AnimationManipulator2:SetRate(-2)
        end
    end,

}

TypeClass = CSKMDTA0302d