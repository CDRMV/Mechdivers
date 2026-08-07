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
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

Truck_MissileBattery = Class(DummyUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },
	
	
	CreateWreckage = function(self, overkillRatio)
    end,
}

TypeClass = Truck_MissileBattery