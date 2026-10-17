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

TEB0103 = Class(TSeaFactoryUnit) {    
    OnStartBuild = function(self, unitBeingBuilt, order)
        TSeaFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)

        self.FactoryBuildFailed = nil
        self.BuildingUnit = true
        if order ~= 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = nil
        end
		
		if not self.Slider then
            self.Slider = CreateSlider(self, 'Bone')
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt, order)
        TSeaFactoryUnit.OnStopBuild(self, unitBeingBuilt, order)

        self.BuildingUnit = false

        if self.DisabledAssist then
            self:AddCommandCap('RULEUCC_Guard')
            self.DisabledAssist = nil
        end

        if not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 then
            unitBeingBuilt:Destroy()
        end

        if not (self.FactoryBuildFailed or IsDestroyed(self)) then
            self:StopBuildFx()

            local spin = nil
            if not EntityCategoryContains(categories.NAVAL, unitBeingBuilt) then
                local rollOffPoint = self.RollOffPoint
                local x, y, z
                spin, x, y, z = self:CalculateRollOffPoint()
                rollOffPoint[1], rollOffPoint[2], rollOffPoint[3] = x, y, z
                IssueToUnitMoveOffFactory(unitBeingBuilt, rollOffPoint)
            end

            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order, spin)
        end

    end,
	
    FinishBuildThread = function(self, unitBeingBuilt, order, rollOffPointSpin)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
		 local bp = self.Blueprint
            self.Slider:SetGoal(0, -0.2, 0)
            self.Slider:SetSpeed(0.1)

        if rollOffPointSpin and unitBeingBuilt and EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) then
            unitBeingBuilt:SetRotation(rollOffPointSpin)
        end
        if unitBeingBuilt and not unitBeingBuilt.Dead then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
             WaitFor(self.Slider)

		WaitTicks(100)
		self.Slider:SetGoal(0, 0, 0)
        WaitFor(self.Slider)
        if order ~= 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
    end,

}

TypeClass = TEB0103