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

UABMD0201 = Class(AStructureUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			self.Rotate = CreateRotator(self, 0, 'y', nil, 0, 0, 0)
			self.RotateValue = 0
    end,

    OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue - 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		if self.RotateValue == 360 then
		self.RotateValue = 0
		end
		elseif bit == 7 then 
		if self.RotateValue == 360 then
		self.RotateValue = 0
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue + 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue - 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		if self.RotateValue == 360 then
		self.RotateValue = 0
		end
		elseif bit == 7 then 
		if self.RotateValue == 360 then
		self.RotateValue = 0
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue + 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
        end
    end,
}

TypeClass = UABMD0201