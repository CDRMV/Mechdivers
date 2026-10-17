#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB3102/UEB3102_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Sonar Installation Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TSonarUnit = import('/lua/defaultunits.lua').SonarUnit

TEB3102 = Class(TSonarUnit) {
    TimedSonarTTIdleEffects = {
        {
            Bones = {
                'Effect',
            },
            Offset = {
                0,
                0,
                0,
            },
            Type = 'SonarBuoy01',
        },
    },
}

TypeClass = TEB3102