#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0103/UEB0103_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  UEF Tier 1 Naval Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TSeaFactoryUnit = import('/lua/defaultunits.lua').SeaFactoryUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

TEB0103 = Class(TSeaFactoryUnit) {    
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateTerminideConstructionUnitBuildingEffects2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateTerminideConstructionUnitBuildingEffects2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )        
        end           
    end,
}

TypeClass = TEB0103