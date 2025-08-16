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
		if Thruster1 and Thruster2 then
		Thruster1:SetGoal(-90)
		Thruster2:SetGoal(-90)
		end
		Spinner2:SetTargetSpeed(0)
		Spinner2:SetGoal(Spinner2:GetCurrentAngle() - Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
		if Thruster1 and Thruster2 then
		Thruster1:SetGoal(-90)
		Thruster2:SetGoal(-90)
		end
		Spinner2:SetTargetSpeed(0)
		Spinner2:SetGoal(Spinner2:GetCurrentAngle() - Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
		if Thruster1 and Thruster2 then
		Thruster1:SetGoal(-20)
		Thruster2:SetGoal(-20)
		end
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
		    Thruster1 = CreateRotator(self, 'Jet_Front', 'x',-20, 10, 0, 10):SetTargetSpeed(5)
            Thruster2 = CreateRotator(self, 'Jet_Back', 'x', -20, 10, 0, 10):SetTargetSpeed(5)	
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
    
}

TypeClass = CSKMDCA0300

