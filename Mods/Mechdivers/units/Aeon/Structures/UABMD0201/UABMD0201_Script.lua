#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2101/UAB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Light Laser Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ADFQuantumBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFQuantumBeam

UABMD0201 = Class(AStructureUnit) {
    Weapons = {
        QuantumBeam = Class(ADFQuantumBeam) {},
    },
}

TypeClass = UABMD0201