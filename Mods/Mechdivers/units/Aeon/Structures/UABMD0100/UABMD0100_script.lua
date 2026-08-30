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
	

UABMD0100 = Class(ALandFactoryUnit) {


	OnCreate = function(self)
		self:AddBuildRestriction(categories.AEON * categories.BUILTBYTIER1WARPSHIPFACTORY)
		self:AddBuildRestriction(categories.AEON * categories.BUILTBYTIER2WARPSHIPFACTORY)
		self:SetUnSelectable(true)
		self:HideBone(0, true)
		self:SetDoNotTarget(true)
        ALandFactoryUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ALandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
		self:DisableShield()
		self.ArmSlider1 = CreateSlider(self, 0)
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, 1000, -200)
		self.ArmSlider1:SetSpeed(1000)
		WaitSeconds(2)
		self:EnableShield()
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
		self:RemoveBuildRestriction(categories.AEON * categories.BUILTBYTIER1WARPSHIPFACTORY)
		self:AddBuildRestriction(categories.AEON *categories.BUILTBYTIER2WARPSHIPFACTORY)
		if self:GetAIBrain().BrainType == 'Human' then
		
		else
		WaitSeconds(600)
		local order = {
            TaskName = "EnhanceTask",
            Enhancement = 'T2Engineering'
        }
		IssueStop({self})
        IssueClearCommands({self})
        IssueScript({self}, order)
		end
		end)
    end,
	
	CreateEnhancement = function(self, enh)
        ALandFactoryUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='T2Engineering' then
		self.TECH2 = true
		self:SetMaxHealth(7800)
		self:SetHealth(self, 7800)
		self:SetBuildRate(40)
		self:RemoveBuildRestriction(categories.AEON * categories.BUILTBYTIER2WARPSHIPFACTORY)
        elseif enh =='T2EngineeringRemove' then
		self.TECH2 = false 
		self:SetMaxHealth(4400)
		self:SetHealth(self, 4400)
		self:SetBuildRate(20)
        self:AddBuildRestriction(categories.AEON * categories.BUILTBYTIER2WARPSHIPFACTORY) 
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




TypeClass = UABMD0100