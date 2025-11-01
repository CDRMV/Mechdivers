#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0101/URB0101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran T1 Land Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local modpath = '/mods/Mechdivers/effects/emitters/'

URBMD0103 = Class(CLandFactoryUnit) {
    BuildAttachBone = 'Attachpoint',
    UpgradeThreshhold1 = 0.167,
    UpgradeThreshhold2 = 0.5,
	
	OnCreate = function(self)
        CLandFactoryUnit.OnCreate(self)
		self:CreateEnhancement('RegularLegion')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
		while not self.Dead do
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_06_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_07_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_11_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_12_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_06_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_07_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_11_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_12_emit.bp'):ScaleEmitter(0.2)
		WaitSeconds(1.2)
		end
		end)
    end,
	
	
	CreateEnhancement = function(self, enh)
        CLandFactoryUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'RegularLegion' then
		self:AddBuildRestriction(categories.CYBRAN * categories.JETBRIGADE)
		self:AddBuildRestriction(categories.CYBRAN * categories.INCINERATIONCORPS)
        elseif enh == 'RegularLegionRemove' then
		
		elseif enh == 'JetBrigade' then
		self:RemoveBuildRestriction(categories.CYBRAN * categories.JETBRIGADE)		
		elseif enh == 'JetBrigadeRemove' then
		self:AddBuildRestriction(categories.CYBRAN * categories.JETBRIGADE)				
		elseif enh == 'IncinerationCorps' then
		self:RemoveBuildRestriction(categories.CYBRAN * categories.INCINERATIONCORPS)						
		elseif enh == 'IncinerationCorpsRemove' then
		self:AddBuildRestriction(categories.CYBRAN * categories.INCINERATIONCORPS)
        end
    end,
	
	--------------------------------------------------------------------------------
	-- AI Unit control
	--------------------------------------------------------------------------------
    --This is called by AI control if this exists
    --Which is called on stop build
    AIUnitControl = function(self, uBB, aiBrain)
        if uBB:GetUnitId() == self.AcceptedRequests[1][1] then
            if not self.AcceptedRequests[1][2].Dead then
                IssueGuard({uBB}, self.AcceptedRequests[1][2])
            --Something for passing along the requested units here, and/or, for sharing them out.
            --else
            --    for i,v in self.AcceptedRequests do
            --        if not
            --    end
            end
            table.remove(self.AcceptedRequests, 1)
        end
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
TypeClass = URBMD0103