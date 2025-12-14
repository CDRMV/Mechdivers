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
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

UEBMD00300 = Class(TStructureUnit) {
    Weapons = {
        MissileRack01 = Class(TSAMLauncher) {},
    },
	
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(0)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack1, false):SetRate(1)	
		if not self.AnimationUnpack2Manipulator then
            self.AnimationUnpack2Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack2Manipulator)
        end
        self.AnimationUnpack2Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(0)
		if not self.AnimationUnpack3Manipulator then
            self.AnimationUnpack3Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack3Manipulator)
        end
        self.AnimationUnpack3Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack3, false):SetRate(0)
		if not self.AnimationUnpack4Manipulator then
            self.AnimationUnpack4Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack4Manipulator)
        end
        self.AnimationUnpack4Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack4, false):SetRate(-1)	
        TStructureUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self.AnimationManipulator:SetRate(0.03)
		WaitFor(self.AnimationManipulator)
        self.AnimationUnpack1Manipulator:SetRate(-1)
		WaitFor(self.AnimationUnpack1Manipulator)		
        self.AnimationUnpack2Manipulator:SetRate(1)
		WaitFor(self.AnimationUnpack2Manipulator)
        self.AnimationUnpack3Manipulator:SetRate(1)
		WaitFor(self.AnimationUnpack3Manipulator)
        self.AnimationUnpack4Manipulator:SetRate(1)
		WaitFor(self.AnimationUnpack4Manipulator)
		end)
	end,	
}

TypeClass = UEBMD00300