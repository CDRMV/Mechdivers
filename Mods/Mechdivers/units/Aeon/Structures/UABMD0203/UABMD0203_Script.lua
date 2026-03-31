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

UABMD0203 = Class(AStructureUnit) {


    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			EffectMesh1 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0203/Effect1_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 'Effect' )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.2)
			EffectMesh2 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0203/Effect2_mesh'
			self.Effect2 = import('/lua/sim/Entity.lua').Entity()
			self.Effect2:AttachBoneTo( -2, self, 'Effect' )
			self.Effect2:SetMesh(EffectMesh2)
			self.Effect2:SetDrawScale(0.2)
			self:SetScriptBit('RULEUTC_JammingToggle', true)
			self:SetScriptBit('RULEUTC_JammingToggle', false)
    end,


	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 2 then 
		KillThread(self.AutomaticCognitiveThreadHandle)
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
		self.Effect2:SetVizToAllies('Never')
		self.Effect2:SetVizToNeutrals('Never')
		self.Effect2:SetVizToEnemies('Never')
		self:SetMaintenanceConsumptionInactive()
		end
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
        if bit == 2 then
		ForkThread(function()
		self.AutomaticCognitiveThreadHandle = self:ForkThread(self.AutomaticCognitiveThread)
		self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		self.Effect2:SetVizToAllies('Intel')
		self.Effect2:SetVizToNeutrals('Intel')
		self.Effect2:SetVizToEnemies('Intel')
		self:SetMaintenanceConsumptionActive()
		end)		
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		self:SetScriptBit('RULEUTC_JammingToggle', true)
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		
		if self.Effect2 then
		self.Effect2:Destroy()
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
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		
		if self.Effect2 then
		self.Effect2:Destroy()
		end
    end,
	
	AutomaticCognitiveThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Enemy')
            for _,unit in units do
			local VisionRadius = unit:GetBlueprint().Intel.VisionRadius
			    if GetDistanceBetweenTwoEntities(unit, self) < 30 then
                  unit:SetIntelRadius('Vision', VisionRadius - 10)
				  unit:SetSpeedMult(-1)
			    end
				if GetDistanceBetweenTwoEntities(unit, self) > 30 then
				  unit:SetIntelRadius('Vision', VisionRadius + 10)
				  unit:SetSpeedMult(1)	
                end
            end
			WaitSeconds(0.1)
			end
    end,	

}

TypeClass = UABMD0203