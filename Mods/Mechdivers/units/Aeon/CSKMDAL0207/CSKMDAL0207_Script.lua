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

CSKMDAL0207 = Class(AWalkingLandUnit) {    
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			if self.unit.animator == nil then
			self.unit.animator = CreateAnimator(self.unit)
            self.unit.animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0207/CSKMDAL0207_Claw.sca', false):SetRate(2)
			WaitFor(self.unit.animator)
						self.unit.animator:Destroy()
			self.unit.animator = nil
			end
			end)
		end,
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
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
			local tpos = unit:GetPosition()
			local mpos = self:GetPosition()
			local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
			if dist > 8 and dist < 15 then
			CreateLightParticle( self, 0, self:GetArmy(), 3, 3, 'glow_03', 'ramp_white_01' ) 
			Warp(self, {tpos[1] + math.random(-1,1), tpos[2], tpos[3] + math.random(-1,1)}, self:GetOrientation())
			CreateLightParticle( self, 0, self:GetArmy(), 3, 3, 'glow_03', 'ramp_white_01' ) 
			IssueClearCommands({self})
			end
			IssueAttack({self}, unit)
            end
			end
			WaitSeconds(0.1)
			end
    end,
	
	
	

}

TypeClass = CSKMDAL0207