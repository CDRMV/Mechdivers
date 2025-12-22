#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEBMD00302 = Class(TStructureUnit) {
	
	OnCreate = function(self)
		self:HideBone('B01', true)
		self:HideBone('B02', true)
        TStructureUnit.OnCreate(self)
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self:HideBone('B01', true)
		self:HideBone('B02', true)
		end)
	end,	
}

TypeClass = UEBMD00302