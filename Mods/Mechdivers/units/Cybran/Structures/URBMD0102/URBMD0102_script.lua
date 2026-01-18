#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0303/URB0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran T3 Naval Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit


URBMD0102 = Class(CStructureUnit) {    
    OnCreate = function(self)
        CStructureUnit.OnCreate(self)
		self:HideBone('B01', true)
		self:HideBone('B02', true)
		self.OpenAnimManip = CreateAnimator(self)
		self.Trash:Add(self.OpenAnimManip)
		self.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Cybran/Structures/URBMD0102/URBMD0102_AOpen.sca', false):SetRate(0)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.SpawnDroneThreadLVL1Handle = self:ForkThread(self.SpawnDroneThreadLVL1)
    end,
	
	SpawnDroneThreadLVL1 = function(self)
		local army = self:GetArmy()
		local position = self:GetPosition()
		local attachposition = self:GetPosition('Attachpoint')
		local number = 0
		local movenumber = 0
		local idledrones = 0
		local reload = 0
 		while not self:IsDead() do
			if reload == 0 then
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 55, 'Enemy')
			if units[1] == nil and units[2] == nil then
			if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			if movenumber == 0 then
			IssueMove({self.Drone, self.Drone2, self.Drone3}, position)
			movenumber = 1
			end
			else
			self.OpenAnimManip:SetRate(-1)
			reload = 30
			end
			else
			if number == 0 then
			WaitSeconds(1)
			WaitFor(self.OpenAnimManip:SetRate(1))
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone2 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone3 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone:DetachFrom(true)
			self.Drone2:DetachFrom(true)
			self.Drone3:DetachFrom(true)
			self.Drone:Scan()
			self.Drone2:Scan()
			self.Drone3:Scan()
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			for i, unit in units do
			IssueFormAttack({self.Drone, self.Drone2, self.Drone3}, unit, 'AttackFormation', 0)
			end
			number = 1
			end
			end
            WaitSeconds(0.1)
			else
			reload = reload - 1
			if reload == 0 then
			number = 0
			movenumber = 0
			end
			end
			WaitSeconds(0.1)
		end	
    end,
}


TypeClass = URBMD0102