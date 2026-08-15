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
local ADFQuantumBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFQuantumBeam3
local modpath = '/mods/Mechdivers/effects/emitters/'

UABMD0303 = Class(AStructureUnit) {
    Weapons = {
	    AntiOrbitalQuantumBeam = Class(ADFQuantumBeam) {
		PlayFxMuzzleChargeSequence = function(self)
		ForkThread(function()
			if self.unit.Scan then
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_Alert_mesh') 
			self.unit.Scan:SetVizToAllies('Intel')
			self.unit.Scan:SetVizToNeutrals('Intel')
			self.unit.Scan:SetVizToEnemies('Intel')
			end
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_01_emit.bp')
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_02_emit.bp')
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_03_emit.bp')
			self.unit.FocusBeam01 = CreateAttachedBeam(self.unit, 'FocusBeam01', self.unit:GetArmy(),4, 0.025, '/textures/particles/beam_disruptor.dds')
			self.unit.FocusBeam02 = CreateAttachedBeam(self.unit, 'FocusBeam02', self.unit:GetArmy(),4, 0.025, '/textures/particles/beam_disruptor.dds')
			self.unit.FocusBeam03 = CreateAttachedBeam(self.unit, 'FocusBeam03', self.unit:GetArmy(),4, 0.025, '/textures/particles/beam_disruptor.dds')
			self.unit.AnimationManipulator2:SetRate(2)
            ADFQuantumBeam.PlayFxMuzzleChargeSequence(self)
			end)
        end,
		
		IdleState = State (ADFQuantumBeam.IdleState) {
        Main = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_mesh') 
			end
           ADFQuantumBeam.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			self.unit:AddToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Intel')
			self.unit.Scan:SetVizToNeutrals('Intel')
			self.unit.Scan:SetVizToEnemies('Intel')
			end
			if self.unit.Beam01 then
			self.unit.Beam01:Destroy()
			self.unit.Beam01 = AttachBeamEntityToEntity(self.unit, 'MainBeam01', self.unit, 'MainBeam01_End', self.unit:GetArmy(), modpath .. 'glazer_spire_beam_02_emit.bp')
			end
			ADFQuantumBeam.OnGotTarget(self)
        end,                
        },
       
        
        OnLostTarget = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Never')
			self.unit.Scan:SetVizToNeutrals('Never')
			self.unit.Scan:SetVizToEnemies('Never')
			end
			if self.unit.Beam01 then
			self.unit.Beam01:Destroy()
			self.unit.Beam01 = AttachBeamEntityToEntity(self.unit, 'MainBeam01', self.unit, 'MainBeam01_End', self.unit:GetArmy(), modpath .. 'glazer_spire_beam_01_emit.bp')
			end
            ADFQuantumBeam.OnLostTarget(self)
        end,
		OnWeaponFired = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Never')
			self.unit.Scan:SetVizToNeutrals('Never')
			self.unit.Scan:SetVizToEnemies('Never')
			end
			self.unit.FocusBeam01:Destroy()
			self.unit.FocusBeam02:Destroy()
			self.unit.FocusBeam03:Destroy()
			self.unit.AnimationManipulator2:SetRate(-2)
            ADFQuantumBeam.OnWeaponFired(self)
        end, 	
		},
        GroundQuantumBeam = Class(ADFQuantumBeam) {
		PlayFxMuzzleChargeSequence = function(self)
		ForkThread(function()
			if self.unit.Scan then
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_Alert_mesh') 
			self.unit.Scan:SetVizToAllies('Intel')
			self.unit.Scan:SetVizToNeutrals('Intel')
			self.unit.Scan:SetVizToEnemies('Intel')
			end
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_01_emit.bp')
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_02_emit.bp')
			CreateAttachedEmitter(self.unit, 'Eye_Muzzle', self.unit:GetArmy(),'/effects/emitters/oblivion_cannon_flash_03_emit.bp')
			self.unit.FocusBeam01 = CreateAttachedBeam(self.unit, 'FocusBeam01', self.unit:GetArmy(),4, 0.1, '/textures/particles/beam_disruptor.dds')
			self.unit.FocusBeam02 = CreateAttachedBeam(self.unit, 'FocusBeam02', self.unit:GetArmy(),4, 0.1, '/textures/particles/beam_disruptor.dds')
			self.unit.FocusBeam03 = CreateAttachedBeam(self.unit, 'FocusBeam03', self.unit:GetArmy(),4, 0.1, '/textures/particles/beam_disruptor.dds')
			self.unit.AnimationManipulator2:SetRate(2)
             ADFQuantumBeam.PlayFxMuzzleChargeSequence(self)
			 end)
        end,
		
		IdleState = State (ADFQuantumBeam.IdleState) {
        Main = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_mesh') 
			end
           ADFQuantumBeam.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			self.unit:AddToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Intel')
			self.unit.Scan:SetVizToNeutrals('Intel')
			self.unit.Scan:SetVizToEnemies('Intel')
			end
			if self.unit.Beam01 then
			self.unit.Beam01:Destroy()
			self.unit.Beam01 = AttachBeamEntityToEntity(self.unit, 'MainBeam01', self.unit, 'MainBeam01_End', self.unit:GetArmy(), modpath .. 'glazer_spire_beam_02_emit.bp')
			end
			ADFQuantumBeam.OnGotTarget(self)
        end,                
        },
       
        
        OnLostTarget = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Never')
			self.unit.Scan:SetVizToNeutrals('Never')
			self.unit.Scan:SetVizToEnemies('Never')
			end
			if self.unit.Beam01 then
			self.unit.Beam01:Destroy()
			self.unit.Beam01 = AttachBeamEntityToEntity(self.unit, 'MainBeam01', self.unit, 'MainBeam01_End', self.unit:GetArmy(), modpath .. 'glazer_spire_beam_01_emit.bp')
			end
            ADFQuantumBeam.OnLostTarget(self)
        end,
		OnWeaponFired = function(self)
			self.unit.FocusBeam01:Destroy()
			self.unit.FocusBeam02:Destroy()
			self.unit.FocusBeam03:Destroy()
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			if self.unit.Scan then
			self.unit.Scan:SetVizToAllies('Never')
			self.unit.Scan:SetVizToNeutrals('Never')
			self.unit.Scan:SetVizToEnemies('Never')
			end
			self.unit.AnimationManipulator2:SetRate(-2)
            ADFQuantumBeam.OnWeaponFired(self)
        end, 	
		},
    },
	
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
        self.AnimationManipulator2:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(0)
        AStructureUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('AntiOrbitalQuantumBeam', false)
		self.wep = self:GetWeaponByLabel('GroundQuantumBeam')
		self.wep:SetEnabled(false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self.Beam01 = AttachBeamEntityToEntity(self, 'MainBeam01', self, 'MainBeam01_End', self:GetArmy(), modpath .. 'glazer_spire_beam_01_emit.bp')
		self.wep = self:GetWeaponByLabel('GroundQuantumBeam')
		self.wep:SetEnabled(false)
		self.AnimationManipulator:SetRate(1)
		WaitFor(self.AnimationManipulator)
		self.wep:SetEnabled(true)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		ScanMesh = '/mods/Mechdivers/Decorations/AeonScan_mesh'
		self.Scan = import('/lua/sim/Entity.lua').Entity()
		self.Scan:AttachBoneTo( -2, self, 'Eye_Muzzle' )
		self.Scan:SetMesh(ScanMesh)
		self.Scan:SetDrawScale(0.1)
		self.Scan:SetVizToAllies('Never')
		self.Scan:SetVizToNeutrals('Never')
		self.Scan:SetVizToEnemies('Never')
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.FocusBeam01 = nil
		self.FocusBeam02 = nil
		self.FocusBeam03 = nil
		end)
	end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('GroundQuantumBeam', true)
            self:SetWeaponEnabledByLabel('AntiOrbitalQuantumBeam', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('GroundQuantumBeam', false)
            self:SetWeaponEnabledByLabel('AntiOrbitalQuantumBeam', true)
        end
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	ForkThread( function()
	if self.Scan then
	self.Scan:Destroy()
	end	
	
	if self.Beam01 then
	self.Beam01:Destroy()
	end	
	
	self.AnimationManipulator:SetRate(-2)
	WaitFor(self.AnimationManipulator)
    AStructureUnit.OnKilled(self, instigator, type, overkillRatio)	
	end)
    end,
	
	OnReclaimed = function(self, reclaimer)
	if self.Scan then
	self.Scan:Destroy()
	end	
	
	if self.Beam01 then
	self.Beam01:Destroy()
	end	
	
    AStructureUnit.OnReclaimed(self, reclaimer)	
    end,
}

TypeClass = UABMD0303