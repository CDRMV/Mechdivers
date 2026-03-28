#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB0101/UAB0101_script.lua
#**  Author(s):  David Tomandl, Gordon Duclos
#**
#**  Summary  :  Aeon Land Factory Tier 1 Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local ALandFactoryUnit = import('/lua/defaultunits.lua').StructureUnit

EmtBpPath = '/effects/emitters/'
	

UABAA0100b = Class(ALandFactoryUnit) {


	OnCreate = function(self)
		self:SetUnSelectable(true)
		self:HideBone(0, true)
		self:SetDoNotTarget(true)
        ALandFactoryUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ALandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
		self.ArmSlider1 = CreateSlider(self, 0)
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, 1000, -200)
		self.ArmSlider1:SetSpeed(1000)
		WaitSeconds(2)
		self.ArmSlider1 = CreateSlider(self, 0)
		self.ArmSlider1:SetGoal(0, -1000, 200)   
		self.ArmSlider1:SetSpeed(20)
		self:ShowBone(0, true)
		self.Effect1 = CreateAttachedEmitter(self, 'L_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
		self.Effect2 = CreateAttachedEmitter(self, 'R_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
		self:HideBone('RampsandLegs', true)
		self:HideBone('Gate', true)
		WaitFor(self.ArmSlider1)
		self:HideBone('Hull', true)
		self:ShowBone('RampsandLegs', true)
		self:ShowBone('Gate', true)
		self:SetDoNotTarget(false)
		self:SetUnSelectable(false)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		end)
    end,


}




TypeClass = UABAA0100b