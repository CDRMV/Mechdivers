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
		self:GiveTacticalSiloAmmo(50)
		self:RefuelStorage()
		end)
	end,	
	
	RefuelStorage = function(self)
		ForkThread( function()	
		local number = 0
		local ammonumber = 0
		while not self.Dead do
		if self:GetTacticalSiloAmmoCount() == 0 and number == 0 then
		number = 1
		self:HideBone('B03', true)
		self:HideBone('B04', true)
		self:HideBone('B05', true)
		WaitSeconds(60)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local RandomPos1 = math.random(-60, 60)
		local RandomPos2 = math.random(-60, 60)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('CSKMDTA0301Ammo', self:GetArmy(), position[1] + RandomPos1, position[2], position[3] + RandomPos2, 0, 0, 0)
		local RotateTowards = import('/lua/defaultunits.lua').RotateTowards
		RotateTowards(self.unit,position)
		IssueMove({self.unit}, position)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		while not self.unit.Dead do
		if self.unit:IsMoving() == true then
		self.unit:SetElevation(2)
		elseif self.unit:IsIdleState() then
		if ammonumber == 0 then
	    ammonumber = 1
		WaitSeconds(50)
		self:ShowBone('B03', true)
		self:ShowBone('B04', true)
		self:ShowBone('B05', true)
		self:GiveTacticalSiloAmmo(50)
		end
		self.unit:SetElevation(120)
		unitpos = self.unit:GetPosition()
		IssueMove({self.unit}, {unitpos[1], unitpos[1], unitpos[3] + 120})
		WaitSeconds(10)
		self.unit:Destroy()
		ammonumber = 0
		break
		end
		WaitSeconds(0.1)
		end
		number = 0
		end
		WaitSeconds(0.1)
		end
		end)
	end,	
}

TypeClass = UEBMD00302