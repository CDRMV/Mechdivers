#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1201/URB1201_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Tier 2 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local modpath = '/mods/Mechdivers/effects/emitters/'

URBMD0203 = Class(CLandFactoryUnit) {
    BuildAttachBone = 'Attachpoint',
    UpgradeThreshhold1 = 0.167,
    UpgradeThreshhold2 = 0.5,
	
	OnCreate = function(self)
        CLandFactoryUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
    end,
}	

TypeClass = URBMD0203