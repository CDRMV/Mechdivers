#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDAL0206 = Class(AWalkingLandUnit) {    
    Weapons = {
		Dummy = Class(DummyTurretWeapon) { 	
		PlayFxMuzzleChargeSequence = function(self)
		ForkThread(function()
			if self.unit.attackanimator then
			self.unit.attackanimator:Destroy()
			self.unit.attackanimator = nil
			end
		if self.unit.animator == nil then
			self.unit.animator = CreateAnimator(self.unit)
			self.unit.animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_Club.sca', false)
		end	
            self.unit.animator:SetRate(2)
			WaitFor(self.unit.animator)
            DummyTurretWeapon.PlayFxMuzzleChargeSequence(self)
			end)
        end,
		
		   PlayFxRackSalvoReloadSequence = function(self)
			ForkThread( function()
			if self.unit.animator == nil then
			self.unit.animator = CreateAnimator(self.unit)
			self.unit.animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_Club.sca', false)
			end	
            self.unit.animator:SetRate(-2)
			WaitFor(self.unit.animator)
			end)
                DummyTurretWeapon.PlayFxRackSalvoChargeSequence(self)
            end,  
		
		OnLostTarget = function(self)
		ForkThread( function()
		if self.unit.animator then
			self.unit.animator:Destroy()
			self.unit.animator = nil
			end
		end)
            DummyTurretWeapon.OnLostTarget(self)
        end,  
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.animator = nil
		self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
    end,
	
	
	DoMeleeThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			if self:GetFireState() == 1 then
			
			else
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Enemy')
            for _,unit in units do
			IssueAttack({self}, unit)
            end
			end
			WaitSeconds(0.1)
			end
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        AWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
		if self.attackanimator then
			self.attackanimator:SetRate(-1)
			end
			if self:IsUnitState('Attacking') then
			self.attackanimator = CreateAnimator(self)
			self.attackanimator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_Attack.sca', false):SetRate(1)
			self.walkanimator = CreateAnimator(self)
			self.Trash:Add(self.walkanimator)
			self.walkanimator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_AWalk2.sca', true):SetRate(1)
			self:SetSpeedMult(1.4)
			elseif self:IsUnitState('Moving')then
			self.walkanimator = CreateAnimator(self)
			self.Trash:Add(self.walkanimator)
			self.walkanimator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_AWalk.sca', true):SetRate(1)
			self:SetSpeedMult(1)
			else
			self.walkanimator = CreateAnimator(self)
			self.Trash:Add(self.walkanimator)
			self.walkanimator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0206/CSKMDAL0206_AWalk.sca', true):SetRate(1)
			self:SetSpeedMult(1)
			end
			
			
        elseif new == 'Stopped' then
			if self.attackanimator then
			self.attackanimator:SetRate(-1)
			end
		if self.walkanimator then
self.walkanimator:Destroy()
self.walkanimator = nil
end
        end
		end)
    end,
	

}

TypeClass = CSKMDAL0206