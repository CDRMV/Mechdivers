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
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local Buff = import('/lua/sim/Buff.lua')
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities

UABMD0204 = Class(AStructureUnit) {

    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0205/CSKMDAL0205_Claw.sca', false):SetRate(1)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
		},
    },
    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			EffectMesh1 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0204/UABMD0204_ForceField_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 0 )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.21)
			self:SetScriptBit('RULEUTC_ProductionToggle', true)
			self:SetScriptBit('RULEUTC_ProductionToggle', false)
			self.AuraEffect = nil
			
    end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 4 then 
		if self.AuraEffect then
		self.AuraEffect:Destroy()
		end
		KillThread(self.AutomaticForceFieldThreadHandle)
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
		self.AutomaticForceFieldThreadHandle = self:ForkThread(self.AutomaticForceFieldThread)
		self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		self:SetMaintenanceConsumptionActive()
		end)		
		end
    end,
	
	AutomaticForceFieldThread = function(self)
	self.AuraEffect = CreateAttachedEmitter( self, 0, self:GetArmy(), '/effects/emitters/seraphim_regenerative_aura_01_emit.bp' )
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
            if not Buffs['MonolithRegenAura'] then
                BuffBlueprint {
                    Name = 'MonolithRegenAura',
                    DisplayName = 'MonolithRegenAura',
                    BuffType = 'COMMANDERAURA',
                    Stacks = 'REPLACE',
                    Duration = 5,
                    Affects = {
                        RegenPercent = {
                            Add = 0,
                            Mult = 0.0055555555 or 0.1,
                            Ceil = 75,
                            Floor = 0,
                        },
                    },
                }
                
            end
			while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
			if unit:GetFractionComplete() == 1 then
			    if GetDistanceBetweenTwoEntities(unit, self) < 10 then
				if not Buff.HasBuff(unit, 'MonolithRegenAura') then
					Buff.ApplyBuff(unit, 'MonolithRegenAura')
				end	
				end
				if GetDistanceBetweenTwoEntities(unit, self) > 12 then
				if Buff.HasBuff(unit, 'MonolithRegenAura') then
					Buff.RemoveBuff(unit, 'MonolithRegenAura')
				end	
				end  
            end
            end
			WaitSeconds(5)
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