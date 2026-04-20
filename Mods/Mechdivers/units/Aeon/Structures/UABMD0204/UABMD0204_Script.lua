#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2101/UAB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Light Laser Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities

UABMD0204 = Class(AStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			EffectMesh1 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0204/UABMD0204_ForceField_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 0 )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.21)
			self:SetScriptBit('RULEUTC_ProductionToggle', true)
			self:SetScriptBit('RULEUTC_ProductionToggle', false)
    end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 4 then 
		KillThread(self.AutomaticForceFieldThreadHandle)
		self.RemoveAutomaticForceFieldThreadHandle = self:ForkThread(self.RemoveAutomaticForceFieldThread)
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
		self:SetMaintenanceConsumptionInactive()
		end
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
        if bit == 4 then
		ForkThread(function()
		KillThread(self.RemoveAutomaticForceFieldThreadHandle)
		self.AutomaticForceFieldThreadHandle = self:ForkThread(self.AutomaticForceFieldThread)
		self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		self:SetMaintenanceConsumptionActive()
		end)		
		end
    end,
	
	AutomaticForceFieldThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
			if unit:GetFractionComplete() == 1 then
			    if GetDistanceBetweenTwoEntities(unit, self) < 10 then
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth + 1000)
				  unit:SetHealth(unit, health + 1000)
                  unit:SetRegenRate(regen + 10)
				end
				if GetDistanceBetweenTwoEntities(unit, self) > 12 then
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth)
				  unit:SetHealth(unit, health)
                  unit:SetRegenRate(regen)	
                end
			end	
            end
			WaitSeconds(0.1)
			end
    end,
	
	RemoveAutomaticForceFieldThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
				if unit:GetFractionComplete() == 1 then
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth)
				  unit:SetHealth(unit, health)
                  unit:SetRegenRate(regen)
				end  
            end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		self:SetScriptBit('RULEUTC_ProductionToggle', true)
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	OnReclaimed = function(self, reclaimer)
		self:SetScriptBit('RULEUTC_ProductionToggle', true)
		if self.Effect1 then
		self.Effect1:Destroy()
		end
    end,
}

TypeClass = UABMD0204