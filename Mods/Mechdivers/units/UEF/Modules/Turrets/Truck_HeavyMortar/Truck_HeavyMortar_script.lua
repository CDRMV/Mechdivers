#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFShipGaussCannonWeapon = import('/lua/terranweapons.lua').TDFShipGaussCannonWeapon

Truck_HeavyMortar = Class(DummyUnit) {
    Weapons = {
        MainGun = Class(TDFShipGaussCannonWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
		DummyUnit.OnStopBeingBuilt(self,builder,layer)
        if not self.ArtyAnim then
            self.ArtyAnim = CreateAnimator(self)
            self.ArtyAnim:PlayAnim(self:GetBlueprint().Display.AnimationOpen):SetRate(1)
            self.Trash:Add(self.ArtyAnim)
        end
    end,
	
	CreateWreckage = function(self, overkillRatio)
    end,
}

TypeClass = Truck_HeavyMortar