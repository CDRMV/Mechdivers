#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0104/URA0104_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran T2 Air Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon

CSKMDCA0301 = Class(CAirUnit) {
    EngineRotateBones = {'Jet_Front', 'Jet_Back',},

    Weapons = {
		Missile01 = Class(CAAMissileNaniteWeapon) {},
    },


    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',
		

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
        end
        
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end
		
		EffectMesh = '/mods/Mechdivers/Decorations/CybranTransportEffect_mesh'
		self.Effect = import('/lua/sim/Entity.lua').Entity()
		self.Effect:AttachBoneTo( -2, self, 'Effect' )
		self.Effect:SetMesh(EffectMesh)
		self.Effect:SetDrawScale(0.05)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')

    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Effect then
		self.Effect:Destroy()
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
		if self.Effect then
		self.Effect:Destroy()
		end
    end,
	
	OnTransportAttach = function(self, bone, attachee)
        CAirUnit.OnTransportDetach(self, bone, attachee)
		ForkThread(function()
		local rate = attachee.Blueprint.Display.TransportAnimationSpeed
		attachee:TransportAnimation(rate)
        self.Effect:SetVizToAllies('Intel')
		self.Effect:SetVizToNeutrals('Intel')
		self.Effect:SetVizToEnemies('Intel')
		WaitSeconds(1)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')
		end)
    end,
	
	 OnTransportDetach = function(self, bone, attachee)
        CAirUnit.OnTransportDetach(self, bone, attachee)
		ForkThread(function()
        self.Effect:SetVizToAllies('Intel')
		self.Effect:SetVizToNeutrals('Intel')
		self.Effect:SetVizToEnemies('Intel')
		WaitSeconds(1)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')
		if attachee:GetBlueprint().General.UnitName == 'Hunter II' then
		attachee:SetUnSelectable(true)
		WaitSeconds(1)
		attachee:DisableShield()
		attachee:SetUnSelectable(false)
		end
		end)
    end,
    
}

TypeClass = CSKMDCA0301

