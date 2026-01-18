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
		self.unit.Spinner2:SetTargetSpeed(0)
		self.unit.Spinner2:SetGoal(self.unit.Spinner2:GetCurrentAngle() - self.unit.Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
		self.unit.Spinner2:SetTargetSpeed(0)
		self.unit.Spinner2:SetGoal(self.unit.Spinner2:GetCurrentAngle() - self.unit.Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
		self.unit.Spinner2:SetTargetSpeed(5)
		self.unit.Spinner2:SetGoal(30)
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
			self.Spinner2 = CreateRotator(self, 'Barrel', 'x', 10, 10, 0, 10):SetTargetSpeed(5)
			self:ForkThread(self.CreateIntelEntity,'Scanner', 'Vision')	
		while not self.Dead do
		if self:IsIdleState() == true then
		self:DestroyScan()
		self:Destroy()
		end
		WaitSeconds(0.1)
		end	

		end)
    end,
	
	CreateIntelEntity = function(self, bone, intel)
	local radius = 25
    if not self.IntelEntity then
        self.IntelEntity = {}
    end
    if not self:BeenDestroyed() and radius > 0 then
        local counter = 1
		local anglevalue = 1
        while counter <= radius do
		anglevalue = anglevalue + 1
            local angle = math.ceil((anglevalue) / 3.14)
            if counter + angle < radius then
                ent = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                table.insert(self.IntelEntity, ent)
                self.Trash:Add(ent)					
                ent:AttachBoneTo( -1, self, bone or 0 )
                local pos = self:CalculateWorldPositionFromRelative({0, 0, counter})
                ent:SetParentOffset(Vector(0,0, counter))
                ent:SetVizToFocusPlayer('Always')
                ent:SetVizToAllies('Always')
                ent:SetVizToNeutrals('Never')
                ent:SetVizToEnemies('Never')
                ent:InitIntel(self:GetArmy(), intel, angle)
                ent:EnableIntel(intel)
            end
            counter = counter + 1
        end	
    end
end,

	Scan = function( self)  
	ForkThread(function()
		while not self.Dead do
		if self.Spinner2 then
		self.Spinner2:SetGoal(math.random(30,40))
		end
		WaitSeconds(0.1)
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
	
	OnReclaimed = function(self, reclaimer)
		if self.Scan then
		self.Scan:Destroy()
		end
    end,
    
}

TypeClass = CSKMDCA0300

