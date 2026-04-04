#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0302/UAA0302_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
EmtBpPath = '/effects/emitters/'
	

CSKMDAA0100 = Class(AAirUnit) {


    OnCreate = function(self)
        AAirUnit.OnCreate(self)
		self:HideBone('RampsandLegs', true)
		self:HideBone('Gate', true)
		self.Effect1 = CreateAttachedEmitter(self, 'L_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
		self.Effect2 = CreateAttachedEmitter(self, 'R_Exhaust', self:GetArmy(), EmtBpPath .. 'aeon_gate_01_emit.bp')
		EffectMesh1 = '/mods/Mechdivers/units/Aeon/CSKMDAA0100/Effect1_mesh'
		self.Effect1 = import('/lua/sim/Entity.lua').Entity()
		self.Effect1:AttachBoneTo( -2, self, 'DropEffect' )
		self.Effect1:SetMesh(EffectMesh1)
		self.Effect1:SetDrawScale(0)
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Dummy = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Dummy:AttachBoneTo('AttachPoint', self, 'Spawn')
		self.Dummy:HideBone(0, true)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		AAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	
	
	OnTransportDetach = function(self, attachBone, unit)
	 	ForkThread( function()
		self:SetImmobile(true)
		self.Dummy:Destroy()
		self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		for i = 0,0.5,0.1 do
		WaitSeconds(0.1)
		self.Effect1:SetDrawScale(i)
		end
		WaitSeconds(0.3)
		local RandomSpawn = math.random(1, 3)
		if RandomSpawn == 1 then
		self:SpawnDroneSquadRef(5)
		elseif RandomSpawn == 2 then
		self:SpawnTripodRef(1)
		elseif RandomSpawn == 3 then
		self:SpawnHTripodRef()
		end
		WaitSeconds(0.6)
		for i = 0.5,0,-0.1 do
		WaitSeconds(0.1)
		self.Effect1:SetDrawScale(i)
		end
		WaitSeconds(0.3)
		self.Effect1:SetVizToAllies('Never')
		self.Effect1:SetVizToNeutrals('Never')
		self.Effect1:SetVizToEnemies('Never')
		self.Effect1:Destroy()
		self:SetImmobile(false)
		IssueClearCommands({self})
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		local position = self:GetPosition()
		IssueMove({self}, {position[1] + 120, position[2], position[3] + 120})
		WaitSeconds(10)
		self:Destroy()
        end)
	 end,
	 
	 SpawnDroneSquadRef = function(self, amount)
	 	ForkThread( function()
		local spawnposition = self:GetPosition('Spawn')
		for i = 0,amount,1 do
		
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local RandomPos1 = math.random(-2, 2)
		local RandomPos2 = math.random(-2, 2)
		self.unit = CreateUnitHPR('CSKMDAL0201', self:GetArmy(), spawnposition.x + RandomPos1, spawnposition.y, spawnposition.z + RandomPos2, 0, 0, 0)	
		CreateLightParticleIntel(self.unit, 0, self:GetArmy(), 18, 4, 'flare_lens_add_02', 'ramp_blue_13')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
        end)
	 end,
	 
	 SpawnTripodRef = function(self, amount)
	 	ForkThread( function()
		local spawnposition = self:GetPosition('Spawn')
		for i = 0,amount,1 do
		
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local RandomUnit = math.random(1, 2)
		if RandomUnit == 1 then
		self.unit = CreateUnitHPR('CSKMDAL0300', self:GetArmy(), spawnposition.x, spawnposition.y, spawnposition.z, 0, 0, 0)	
		else
		self.unit = CreateUnitHPR('CSKMDAL0301', self:GetArmy(), spawnposition.x, spawnposition.y, spawnposition.z, 0, 0, 0)	
		end
		CreateLightParticleIntel(self.unit, 0, self:GetArmy(), 18, 4, 'flare_lens_add_02', 'ramp_blue_13')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
        end)
	 end,
	 
	 SpawnHTripodRef = function(self)
	 	ForkThread( function()
		local spawnposition = self:GetPosition('Spawn')
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.unit = CreateUnitHPR('CSKMDAL0306', self:GetArmy(), spawnposition.x, spawnposition.y, spawnposition.z, 0, 0, 0)	
		self.unit:DisableShield()
		CreateLightParticleIntel(self.unit, 0, self:GetArmy(), 18, 4, 'flare_lens_add_02', 'ramp_blue_13')
		WaitSeconds(0.2)
		self.unit:EnableShield()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
        end)
	 end,
	

}
TypeClass = CSKMDAA0100