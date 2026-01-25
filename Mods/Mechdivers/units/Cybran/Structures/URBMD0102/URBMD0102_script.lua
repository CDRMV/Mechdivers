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
		self:SetCapturable(false)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.SpawnDroneThreadLVL1Handle = self:ForkThread(self.SpawnDroneThreadLVL1)
    end,
	
	
	SpawnDroneThreadLVL1 = function(self)
		local army = self:GetArmy()
		local aiBrain = self:GetAIBrain()
		local position = self:GetPosition()
		local attachposition = self:GetPosition('Attachpoint')
		local number = 0
		local movenumber = 0
		local stoporder = 0
		local idledrones = 0
		local reload = 0
		local build = 0
		local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
 		while not self:IsDead() do
			if reload == 0 then
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 55, 'Enemy')
			if units[1] == nil and units[2] == nil then
			if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			if GetDistanceBetweenTwoEntities(self.Drone, self) > 55 then
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			stoporder = 0
			end
			if GetDistanceBetweenTwoEntities(self.Drone2, self) > 55 then
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			stoporder = 0
			end
			if GetDistanceBetweenTwoEntities(self.Drone3, self) > 55 then
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			stoporder = 0
			end
			if movenumber == 0 then
			stoporder = 0
			IssueMove({self.Drone, self.Drone2, self.Drone3}, position)
			movenumber = 1
			end
			else
			self.OpenAnimManip:SetRate(-1)
			reload = 30
			end
			else
			if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			if GetDistanceBetweenTwoEntities(self.Drone, self) > 55 then
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			stoporder = 0
			end
			if GetDistanceBetweenTwoEntities(self.Drone2, self) > 55 then
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			stoporder = 0
			end
			if GetDistanceBetweenTwoEntities(self.Drone3, self) > 55 then
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			stoporder = 0
			end
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 55, 'Enemy')
			for i, unit in units do
			if stoporder == 0 and GetDistanceBetweenTwoEntities(self.Drone, self) < 35 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 35 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 35 then
			IssueClearCommands({self.Drone, self.Drone2 , self.Drone3})
			stoporder = 1
			movenumber = 0
			end
			if GetDistanceBetweenTwoEntities(self.Drone, self) < 35 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 35 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 35 then
			IssueFormAttack({self.Drone, self.Drone2, self.Drone3}, unit, 'AttackFormation', 0)
			end
			end
			end
			if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
			self.OpenAnimManip:SetRate(-1)
			number = 0
			movenumber = 0
			end
			if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
			IssueMove({self.Drone, self.Drone2}, position)
			end
			if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			IssueMove({self.Drone, self.Drone3}, position)
			end
			if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			IssueMove({self.Drone2, self.Drone3}, position)
			end
			if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
			IssueMove({self.Drone}, position)
			end
			if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
			IssueMove({self.Drone2}, position)
			end
			if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			IssueMove({self.Drone3}, position)
			end
			if number == 0 then
			SetArmyEconomy(self:GetArmy(), -250,  -450)
			if aiBrain:GetEconomyStored("MASS") < 250 and aiBrain:GetEconomyStored("MASS") < 450 then
			elseif aiBrain:GetEconomyStored("MASS") < 250 and aiBrain:GetEconomyStored("MASS") > 450 then
			elseif aiBrain:GetEconomyStored("MASS") > 250 and aiBrain:GetEconomyStored("MASS") < 450 then
			else
			if self.Drone and self.Drone2 and self.Drone3 then
			table.empty(self.Drone) 
			table.empty(self.Drone2) 
			table.empty(self.Drone3) 
			end
			if build == 0 then
			WaitSeconds(1)
			build = 1
			else
			WaitSeconds(5)
			end
			WaitFor(self.OpenAnimManip:SetRate(1))
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone:DetachFrom(true)
			self.Drone:Scan()
			for i, unit in units do
			IssueFormAttack({self.Drone}, unit, 'AttackFormation', 0)
			end	
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 1
			end
			if number == 1 then
			WaitSeconds(0.5)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone2 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone2:DetachFrom(true)
			self.Drone2:Scan()
			for i, unit in units do
			IssueFormAttack({self.Drone2}, unit, 'AttackFormation', 0)
			end	
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 2
			end
			if number == 2 then
			WaitSeconds(0.5)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone3 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone3:DetachFrom(true)
			self.Drone3:Scan()
			for i, unit in units do
			IssueFormAttack({self.Drone3}, unit, 'AttackFormation', 0)
			end	
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 3
			end
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
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone2:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone2:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
		self.Drone3:Kill()
	end
	


    CStructureUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	
	OnReclaimed = function(self, reclaimer)
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone2:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() then
		self.Drone2:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
		self.Drone3:Kill()
	end
	
    end,
}


TypeClass = URBMD0102