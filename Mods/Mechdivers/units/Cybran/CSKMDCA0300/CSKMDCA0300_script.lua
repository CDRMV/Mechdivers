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
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFHLaserFusionWeapon = ModWeaponsFile.CDFHLaserFusionWeapon
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon

CSKMDCA0300 = Class(CAirUnit) {
    EngineRotateBones = {'Jet_Front', 'Jet_Back',},

    Weapons = {
      MainGun = Class(CDFLaserFusionWeapon) {		
	   IdleState = State (CDFLaserFusionWeapon.IdleState) {
        Main = function(self)
           CDFLaserFusionWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
		Spinner2:SetTargetSpeed(0)
		Spinner2:SetGoal(Spinner2:GetCurrentAngle() - Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
		Spinner2:SetTargetSpeed(0)
		Spinner2:SetGoal(Spinner2:GetCurrentAngle() - Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
		Spinner2:SetTargetSpeed(5)
		Spinner2:SetGoal(30)
            CDFLaserFusionWeapon.OnLostTarget(self)
        end,  			
		},
		MissileRack1 = Class(CIFGrenadeWeapon) {},
		MissileRack2 = Class(CIFGrenadeWeapon) {},
    },


    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',
		
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
        self.EngineManipulators = {}

			ScanMesh = '/mods/Mechdivers/Decorations/CybranScan2_mesh'
			self.Scan = import('/lua/sim/Entity.lua').Entity()
			self.Scan:AttachBoneTo( -2, self, 'Scanner' )
			self.Scan:SetMesh(ScanMesh)
			self.Scan:SetDrawScale(0.90)
			self.Scan:SetVizToAllies('Intel')
			self.Scan:SetVizToNeutrals('Intel')
			self.Scan:SetVizToEnemies('Intel')
				Spinner2 = CreateRotator(self, 'Barrel', 'x', 10, 10, 0, 10):SetTargetSpeed(5)
		while not self.Dead do
		if Spinner2 then
		Spinner2:SetGoal(math.random(30,40))
		else
		end
		WaitSeconds(1)
		end	

		end)
    end,
	
	DestroyScan = function( self)  
		if self.Scan then
		self.Scan:Destroy()
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Scan then
		self.Scan:Destroy()
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
    
}

TypeClass = CSKMDCA0300

