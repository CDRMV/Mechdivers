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
		if ArmyIsCivilian(self:GetArmy()) then
		self.SpawnDroneThreadLVL2Handle = self:ForkThread(self.SpawnDroneThreadLVL2)
		else
		self.SpawnDroneThreadLVL0Handle = self:ForkThread(self.SpawnDroneThreadLVL0)
		end
    end,
	
	
	SpawnDroneThreadLVL0 = function(self)
		local army = self:GetArmy()
		local aiBrain = self:GetAIBrain()
		local position = self:GetPosition()
		local attachposition = self:GetPosition('Attachpoint')
		local number = 0
		local movenumber = 0
		local econumber = 0
		local stoporder = 0
		local idledrones = 0
		local reload = 0
		local build = 0
		local units1 = nil
		local units2 = nil
		local units3 = nil
		local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
 		while not self:IsDead() do
			if reload == 0 then
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone, self) < 8 then
			self.Drone:Destroy()
			self.Drone:DestroyScan()
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 8 then
			self.Drone2:Destroy()
			self.Drone2:DestroyScan()
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 8 then
			self.Drone3:Destroy()
			self.Drone3:DestroyScan()
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 then
			self.Drone:SetSpeedMult(2)
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 then
			self.Drone2:SetSpeedMult(2)
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 then
			self.Drone3:SetSpeedMult(2)
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			else
			self.OpenAnimManip:SetRate(-1)
			number = 0
			econumber = 0
			end
			if number == 0 then
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 55, 'Enemy')
			if units[1] == nil and units[2] == nil then

			else
			if build == 0 then
			WaitSeconds(1)
			build = 1
			else
			WaitSeconds(5)
			end
			if econumber == 0 then
			SetArmyEconomy(self:GetArmy(), -250,  -450)
			econumber = 1 
			end
			if aiBrain:GetEconomyStored("MASS") < 250 and aiBrain:GetEconomyStored("MASS") < 450 then
			elseif aiBrain:GetEconomyStored("MASS") < 250 and aiBrain:GetEconomyStored("MASS") > 450 then
			elseif aiBrain:GetEconomyStored("MASS") > 250 and aiBrain:GetEconomyStored("MASS") < 450 then
			else
			if self.Drone and self.Drone2 and self.Drone3 then
			table.empty(self.Drone) 
			table.empty(self.Drone2) 
			table.empty(self.Drone3) 
			end
			WaitFor(self.OpenAnimManip:SetRate(1))
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone:DetachFrom(true)
			self.Drone:Scan()
			IssueGuard({self.Drone}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 1
			end
			if number == 1 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone2 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone2:DetachFrom(true)
			self.Drone2:Scan()
			IssueGuard({self.Drone2}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 2
			end
			if number == 2 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone3 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone3:DetachFrom(true)
			self.Drone3:Scan()
			IssueGuard({self.Drone3}, self)
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
	
	SpawnDroneThreadLVL2 = function(self)
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
		local units1 = nil
		local units2 = nil
		local units3 = nil
		local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
 		while not self:IsDead() do
			if reload == 0 then
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone, self) < 8 then
			self.Drone:Destroy()
			self.Drone:DestroyScan()
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 8 then
			self.Drone2:Destroy()
			self.Drone2:DestroyScan()
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 8 then
			self.Drone3:Destroy()
			self.Drone3:DestroyScan()
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 then
			self.Drone:SetSpeedMult(2)
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 then
			self.Drone2:SetSpeedMult(2)
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 then
			self.Drone3:SetSpeedMult(2)
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() or self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() then
			else
			self.OpenAnimManip:SetRate(-1)
			number = 0
			econumber = 0
			end
			if number == 0 then
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 55, 'Enemy')
			if units[1] == nil and units[2] == nil then

			else
			if build == 0 then
			WaitSeconds(1)
			build = 1
			else
			WaitSeconds(5)
			end
			
			if self.Drone and self.Drone2 and self.Drone3 then
			table.empty(self.Drone) 
			table.empty(self.Drone2) 
			table.empty(self.Drone3) 
			end
			WaitFor(self.OpenAnimManip:SetRate(1))
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone:DetachFrom(true)
			self.Drone:Scan()
			IssueGuard({self.Drone}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 1
			if number == 1 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone2 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone2:DetachFrom(true)
			self.Drone2:Scan()
			IssueGuard({self.Drone2}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 2
			end
			if number == 2 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone3 = CreateUnitHPR('CSKMDCA0300', self:GetArmy(), attachposition.x, attachposition.y, attachposition.z, 0, 0, 0)
			self.Drone3:DetachFrom(true)
			self.Drone3:Scan()
			IssueGuard({self.Drone3}, self)
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