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
local ModEffectpath = '/mods/Mechdivers/effects/emitters/'
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local R, Ceil = Random, math.ceil

UABMD0400 = Class(AStructureUnit) {
	Weapons = {	
		Dummy = Class(DummyTurretWeapon) {
		    IdleState = State (DummyTurretWeapon.IdleState) {
                OnGotTarget = function(self)
                    DummyTurretWeapon.IdleState.OnGotTarget(self)
					Warp(self.unit.unit2, self:GetCurrentTargetPos(), self.unit.unit2:GetOrientation())
					IssueClearCommands({self.unit.unit2})
                end,
            },

            OnLostTarget = function(self)
                DummyTurretWeapon.OnLostTarget(self)
				Warp(self.unit.unit2, self.unit:GetPosition(), self.unit.unit2:GetOrientation())
            end,
		},
	},
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			EffectMesh1 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect01_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 'Effect' )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.35)
			EffectMesh2 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect02_mesh'
			self.Effect2 = import('/lua/sim/Entity.lua').Entity()
			self.Effect2:AttachBoneTo( -2, self, 'Effect' )
			self.Effect2:SetMesh(EffectMesh2)
			self.Effect2:SetDrawScale(0.4)
			EffectMesh3 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect03_mesh'
			self.Effect3 = import('/lua/sim/Entity.lua').Entity()
			self.Effect3:AttachBoneTo( -2, self, 'Effect' )
			self.Effect3:SetMesh(EffectMesh3)
			self.Effect3:SetDrawScale(0.345)
						EffectMesh5 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect04_mesh'
			self.Effect4 = import('/lua/sim/Entity.lua').Entity()
			self.Effect4:AttachBoneTo( -2, self, 'Base_Effect' )
			self.Effect4:SetMesh(EffectMesh5)
			self.Effect4:SetDrawScale(0.30)
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
		self.Effect2:SetVizToAllies('Never')
		self.Effect2:SetVizToNeutrals('Never')
		self.Effect2:SetVizToEnemies('Never')
		self.Effect3:SetVizToAllies('Never')
		self.Effect3:SetVizToNeutrals('Never')
		self.Effect3:SetVizToEnemies('Never')
		self.Effect4:SetVizToAllies('Never')
		self.Effect4:SetVizToNeutrals('Never')
		self.Effect4:SetVizToEnemies('Never')
		self.Spinner1 = CreateRotator(self, 'Effect', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner2 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Spinner3 = CreateRotator(self, 'Spinner2', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self:SetScriptBit('RULEUTC_IntelToggle',true)
		self:SetScriptBit('RULEUTC_IntelToggle',false)
		self:SetMaintenanceConsumptionInactive()
	end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
		if bit == 3 then 
		self:SetMaintenanceConsumptionInactive()
		if self.unit then
		self.unit:Destroy()
		end
		if self.unit2 then
		self.unit2:Destroy()
		end
		if self.Spinner1 then
		self.Spinner1:SetTargetSpeed(0)
		end
		if self.Spinner2 then
		self.Spinner2:SetTargetSpeed(0)
		end
		if self.Spinner3 then
		self.Spinner3:SetTargetSpeed(0)
		end
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
		self.Effect2:SetVizToAllies('Never')
		self.Effect2:SetVizToNeutrals('Never')
		self.Effect2:SetVizToEnemies('Never')
		self.Effect3:SetVizToAllies('Never')
		self.Effect3:SetVizToNeutrals('Never')
		self.Effect3:SetVizToEnemies('Never')
		self.Effect4:SetVizToAllies('Never')
		self.Effect4:SetVizToNeutrals('Never')
		self.Effect4:SetVizToEnemies('Never')
		if self.Effect5 then
		self.Effect5:Destroy()
		end
		if self.Effect6 then
		self.Effect6:Destroy() 
		end
		if self.Effect7 then
		self.Effect7:Destroy()
		end
		if self.Effect8 then
		self.Effect8:Destroy()
		end
		if self.Effect9 then
		self.Effect9:Destroy()
		end
		if self.Effect10 then
		self.Effect10:Destroy()
		end
		if self.Effect11 then
		self.Effect11:Destroy()
		end
		if self.Effect12 then
		self.Effect12:Destroy()
		end
        end	
		end)
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
		if bit == 3 then 
		self.Spinner1:SetTargetSpeed(5)
		self.Spinner2:SetTargetSpeed(45)
		self.Spinner3:SetTargetSpeed(-45)
		self.Effect5 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/weather_rainfall_01_emit.bp'):ScaleEmitter(3):OffsetEmitter(0,30,0)
		self.Effect6 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'storm_01_emit.bp'):ScaleEmitter(40):OffsetEmitter(0,-20,0)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('UABMD0400b', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit2 = CreateUnitHPR('UABMD0400c', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Effect7 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModEffectpath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(0.55)
		self.Effect8 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModEffectpath .. 'aeon_teleport_02_emit.bp'):ScaleEmitter(0.55)
		self.Effect9 = CreateAttachedEmitter(self,'Effect',self:GetArmy(), ModEffectpath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.65)
		self.Effect10 = CreateAttachedEmitter(self,'Core',self:GetArmy(), ModEffectpath .. 'aeon_teleport_01_emit.bp'):ScaleEmitter(0.55)
		self.Effect11 = CreateAttachedEmitter(self,'Core',self:GetArmy(), ModEffectpath .. 'aeon_teleport_02_emit.bp'):ScaleEmitter(0.55)
		self.Effect12 = CreateAttachedEmitter(self,'Core',self:GetArmy(), ModEffectpath .. 'aeon_teleport_03_emit.bp'):ScaleEmitter(0.65)
		self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		self.Effect2:SetVizToAllies('Intel')
		self.Effect2:SetVizToNeutrals('Intel')
		self.Effect2:SetVizToEnemies('Intel')
		self.Effect3:SetVizToAllies('Intel')
		self.Effect3:SetVizToNeutrals('Intel')
		self.Effect3:SetVizToEnemies('Intel')
		self.Effect4:SetVizToAllies('Intel')
		self.Effect4:SetVizToNeutrals('Intel')
		self.Effect4:SetVizToEnemies('Intel')
		self:SetMaintenanceConsumptionActive()
		end
		end)
    end,
	
	
}

TypeClass = UABMD0400