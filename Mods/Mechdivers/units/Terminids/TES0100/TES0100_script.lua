#****************************************************************************
#**
#**  File     :  /cdimage/units/UES0103/UES0103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Frigate Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TSeaUnit = import('/lua/defaultunits.lua').SeaUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

TES0100 = Class(TSeaUnit) {

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
        },
    },
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TES0100/TES0100_A01.sca', false):SetRate(0)
        TSeaUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
		self.AnimationManipulator:SetRate(2)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim('/mods/Mechdivers/units/Terminids/TES0100/TES0100_ASwim01.sca', true):SetRate(1)	
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateTerminideConstructionUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateTerminideConstructionUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )        
        end           
    end,
}

TypeClass = TES0100