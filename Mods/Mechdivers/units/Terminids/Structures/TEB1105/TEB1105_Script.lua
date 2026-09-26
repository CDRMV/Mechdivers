#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1105/UEB1105_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  UEF Energy Storage
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TEnergyStorageUnit = import('/lua/defaultunits.lua').EnergyStorageUnit

TEB1105 = Class(TEnergyStorageUnit) {

    OnCreate = function(self)
        TEnergyStorageUnit.OnCreate(self)
        self.Trash:Add(CreateStorageManip(self, 'Storage', 'ENERGY', 0, -0.03, 0, 0, 0.21, 0))
    end,

}

TypeClass = TEB1105