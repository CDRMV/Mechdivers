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

L_BalisticShield = Class(DummyUnit) { 
	
	Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
		if self.Shield and not self.Shield.Dead then
		self.Shield:Destroy()
		end
        DummyUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	NotifyOfPodDeath = function(self, pod)
        if pod == 'BalisticShield' then
		self:ShowBone('BalisticShield_Arm_Damaged', true)
		self:HideBone('BalisticShield_Arm_Damaged2', true)
		self:HideBone('BalisticShield_B01', true)
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/Modules/Left Arm/L_BalisticShield/L_BalisticShield_Unpack.sca', false):SetRate(-2)
        end
    end,
	
		
	OnStopBeingBuilt = function(self,builder,layer)
        DummyUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self:HideBone('BalisticShield_Arm_Damaged', true)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.Shield = CreateUnitHPR('BalisticShield', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.Shield:SetParent(self, 'BalisticShield')
        self.Shield:SetCreator(self)
		self.Shield:AttachBoneTo(0, self, 'BalisticShield_Entity')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
    end,
	
	RevertAnimation = function(self)
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/Modules/Left Arm/L_BalisticShield/L_BalisticShield_Unpack.sca', false):SetRate(-2)
    end,
	
	DoAnimation = function(self)
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/Modules/Left Arm/L_BalisticShield/L_BalisticShield_Unpack.sca', false):SetRate(2)
    end,
	
	OnDestroy = function(self) 
        DummyUnit.OnDestroy(self)
		if self.Shield and not self.Shield.Dead then
		self.Shield:Destroy()
		end
    end,
	
	OnReclaimed = function(self) 
        DummyUnit.OnReclaimed(self)
		if self.Shield and not self.Shield.Dead then
		self.Shield:Destroy()
		end
    end,
	  
}
TypeClass = L_BalisticShield