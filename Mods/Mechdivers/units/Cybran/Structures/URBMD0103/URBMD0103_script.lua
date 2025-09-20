#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0101/URB0101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran T1 Land Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit

URBMD0103 = Class(CLandFactoryUnit) {
    BuildAttachBone = 'Attachpoint',
    UpgradeThreshhold1 = 0.167,
    UpgradeThreshhold2 = 0.5,
}
TypeClass = URBMD0103