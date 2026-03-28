#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0302/UAA0302_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
EmtBpPath = '/effects/emitters/'
	

CSKMDAA0100 = Class(AAirUnit) {


    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('RampsandLegs', true)
		self:HideBone('Gate', true)
		self.Effect1 = CreateAttachedEmitter(self, 'L_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
		self.Effect2 = CreateAttachedEmitter(self, 'R_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
    end,

}
TypeClass = CSKMDAA0100