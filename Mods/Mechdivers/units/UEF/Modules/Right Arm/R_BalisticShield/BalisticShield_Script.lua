#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').MobileUnit

BalisticShield = Class(DummyUnit) { 
	
	Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        DummyUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
		
	OnStopBeingBuilt = function(self,builder,layer)
        DummyUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone(0, true)
		self:SetDoNotTarget(false)
    end,
	

	  
}
TypeClass = BalisticShield