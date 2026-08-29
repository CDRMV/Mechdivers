#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1201/URB1201_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Tier 2 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local modpath = '/mods/Mechdivers/effects/emitters/'

URBMD0203 = Class(CLandFactoryUnit) {
    BuildAttachBone = 'Attachpoint',
    UpgradeThreshhold1 = 0.167,
    UpgradeThreshhold2 = 0.5,
	
	OnCreate = function(self)
        CLandFactoryUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	----------------------------------------------------------------------------
    -- AI control
    ----------------------------------------------------------------------------
    AIStartOrders = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            local BpId = self.BpId or self:GetUnitId()
            self.Time = GetGameTimeSeconds()
            aiBrain:BuildUnit(self, self:ChooseUnit(), 1)
        end
    end,

    AIControl = function(self, unitBeingBuilt)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            if self.AIUnitControl then
                self.AIUnitControl(self, unitBeingBuilt, aiBrain)
            end
            aiBrain:BuildUnit(self, self:ChooseUnit(), 1)
        end
    end,

    ChooseUnit = function(self)
        if not self.RequestedUnits then self.RequestedUnits = {} end
        if not self.AcceptedRequests then self.AcceptedRequests = {} end
        if not self.BuiltUnitsCount then self.BuiltUnitsCount = 1 else self.BuiltUnitsCount = self.BuiltUnitsCount + 1 end
        local bp = self:GetBlueprint()
        local buildorder = bp.AI.BuildOrder

        if type(buildorder[self.BuiltUnitsCount]) == 'string' and self:CanBuild(buildorder[self.BuiltUnitsCount]) then
            return buildorder[self.BuiltUnitsCount]
        end

        if self.RequestedUnits[1] and math.mod(self.BuiltUnitsCount, 2) == 0 then
            local req = self.RequestedUnits[1][1]
            table.insert(self.AcceptedRequests,self.RequestedUnits[1])
            table.remove(self.RequestedUnits, 1)
            if type(req) == 'string' and self:CanBuild(req) then
                return req
            end
        end

        local BuildBackups = bp.AI.BuildBackups

        if self:GetAIBrain():GetNoRushTicks() > 1 and type(BuildBackups.EarlyNoRush) == 'string' and self:CanBuild(BuildBackups.EarlyNoRush) then
            return BuildBackups.EarlyNoRush
        end

        if self.Lastbuilt then
            return self.Lastbuilt
        end

        for i, v in BuildBackups.LastResorts do
            if type(v) == 'string' and self:CanBuild(v) then
                return v
            end
        end
    end,

    ----------------------------------------------------------------------------
    -- AI Cheats
    ----------------------------------------------------------------------------
    AIStartCheats = function(self)
        local aiBrain = self:GetAIBrain()
        if aiBrain.BrainType ~= 'Human' then
            if aiBrain.CheatEnabled then

            else

            end
        end
    end,

    AICheats = function(self)

    end,
}	

TypeClass = URBMD0203