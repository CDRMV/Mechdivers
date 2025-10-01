#****************************************************************************
#** 
#**  File     :  /cdimage/units/UEB5101/UEB5101_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  UEF Wall Piece Script 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWallStructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEBMD0001 = Class(TWallStructureUnit) {

	OnCreate = function(self)
		self:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
        TWallStructureUnit.OnCreate(self)
    end,
}


TypeClass = UEBMD0001

