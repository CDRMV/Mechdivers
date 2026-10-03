#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local MineExplosion = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').MineExplosion
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local explosion = import('/lua/defaultexplosions.lua')

TEB0100 = Class(TStructureUnit) {
	
	OnStartBuild = function(self, built, order)
		TStructureUnit.OnStartBuild(self,built,order)
		built:HideBone(0,true)
    end,
	
	OnStopBuild = function(self, unitBeingBuilt, order)
        TStructureUnit.OnStopBuild(self, unitBeingBuilt, order)

        self.BuildingUnit = false

        -- re-introduce the ability to assist
        if self.DisabledAssist then
            self:AddCommandCap('RULEUCC_Guard')
            self.DisabledAssist = nil
        end

        -- Factory can stop building but still have an unbuilt unit if a mobile build order is issued and the order is cancelled
        if not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 then
            unitBeingBuilt:Destroy()
        end

        if not (self.FactoryBuildFailed or IsDestroyed(self)) then

            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order)
        end

    end,
	
	FinishBuildThread = function(self, unitBeingBuilt, order)
		self:SetUnSelectable(true)
		self:AddBuildRestriction( categories.TERMINIDS * categories.BUILTBYTIER1BUGHOLE )
		self:HideBone('Egg',true)
		unitBeingBuilt:ShowBone(0,true)
		WaitSeconds(20)
		self:Destroy()
    end,
	
}

TypeClass = TEB0100