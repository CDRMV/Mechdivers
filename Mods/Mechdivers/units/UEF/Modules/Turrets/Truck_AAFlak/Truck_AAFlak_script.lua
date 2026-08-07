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

Truck_AAFlak = Class(DummyUnit) {
    Weapons = {
        AAGun = Class(TDFShipGaussCannonWeapon) {
            PlayOnlyOneSoundCue = true,
        },
    },
	
	
	
	CreateWreckage = function(self, overkillRatio)
    end,
}

TypeClass = Truck_AAFlak