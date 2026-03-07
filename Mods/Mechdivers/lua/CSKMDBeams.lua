local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Mechdivers/lua/CSKMDEffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local utilities = import('/lua/utilities.lua')

SCCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},#EffectTemplate.DefaultProjectileLandImpact,
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},    
    FxImpactNone = {},
}

HeatCollisionBeam = Class(CollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = {

	},
    FxBeam = {
		'/mods/Mechdivers/effects/emitters/heat_beam_01_emit.bp'
	},
    FxBeamEndPoint = {
		--'/mods/Mechdivers/effects/emitters/heat_beam_end_01_emit.bp',
		'/mods/Mechdivers/effects/emitters/heat_beam_end_02_emit.bp',
		'/mods/Mechdivers/effects/emitters/heat_beam_end_03_emit.bp',
		--'/mods/Mechdivers/effects/emitters/heat_beam_end_04_emit.bp',
		--'/mods/Mechdivers/effects/emitters/heat_beam_end_05_emit.bp',
		'/mods/Mechdivers/effects/emitters/heat_beam_end_06_emit.bp',
	},
	FxBeamEndPointScale = 0.5,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
    
    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.75 + (Random() * 0.75) 
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end
                
            WaitSeconds( self.ScorchSplatDropTime )
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

QuantumCollisionBeam = Class(CollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = {
		'/mods/Mechdivers/effects/emitters/quantum_beam_flash_01_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_flash_01_emit.bp',
	},
    FxBeam = {
		'/mods/Mechdivers/effects/emitters/quantum_beam_01_emit.bp'
	},
    FxBeamEndPoint = {
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_01_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_02_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_03_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_04_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_05_emit.bp',
		'/mods/Mechdivers/effects/emitters/quantum_beam_end_06_emit.bp',
	},
	FxBeamEndPointScale = 0.5,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
    
    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.75 + (Random() * 0.75) 
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end
                
            WaitSeconds( self.ScorchSplatDropTime )
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

LightningCollisionBeam = Class(SCCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.1,
    FxBeamStartPoint = EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
	FxBeam = {
		'/mods/Mechdivers/effects/emitters/Lightning_beam_01_emit.bp'
	},
    FxBeamEndPoint = EffectTemplate.OthuyElectricityStrikeHit,
	FxBeamEndPointScale = 0.1,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    OnImpact = function(self, impactType, targetEntity)
		if targetEntity then
		targetEntity:SetStunned(10)
		end
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )   
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 1.5 + (Random() * 1.5) 
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end
                
            WaitSeconds( self.ScorchSplatDropTime )
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

TerranLightningCollisionBeam = Class(SCCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 0.1,
    FxBeamStartPoint = EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
	FxBeam = {
		'/mods/Commander Survival Kit Units/effects/emitters/lightning_beam_01_emit.bp',
	},
    FxBeamEndPoint = EffectTemplate.OthuyElectricityStrikeHit,
	FxBeamEndPointScale = 0.1,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
	
	    ChainJumps = 3,
    ChainRange = 10,

    DoDamage = function(self, instigator, damageData, targetEntity)
        -- Ensure we have valid data       
        if self and damageData and targetEntity then
		targetEntity:SetStunned(2)
           -- Set the lifetime of the beams
           local beamLifeTime
           local wpBp = self.Weapon:GetBlueprint()
           if wpBp.BeamLifetime > 0.25 then
               beamLifeTime = wpBp.BeamLifetime
           elseif wpBp.BeamCollisionDelay > 0.25 then
               beamLifeTime = wpBp.BeamCollisionDelay
           else
               beamLifeTime = 0.25
           end
           -- Show targetEntity during debug mode
           if self.BeamDebug then
               WARN('***')     
               WARN('   Beam Life Time', beamLifeTime)         
               WARN('   Impacted Target ID: ', targetEntity:GetEntityId() )
           end         
            -- Ensure we have an instigator of some type
            if not instigator then
                instigator = self
            end
            -- Jump beam to other targets only if ChainJumps and ChainRange are defined     
            if self.ChainJumps > 0  and self.ChainRange > 0 then                                       
               -- Check for targets in range             
               local tPos = targetEntity:GetPosition()
               local targets = {}
               targets = utilities.GetEnemyUnitsInSphere( self, tPos, self.ChainRange )
               table.removeByValue(targets, targetEntity)           
               -- Check if targets avalible beyond the first
               if table.getsize(targets) > 1 then                                     
                   -- Sort targets by range to create a valid target list
                   local army = self:GetArmy()
                   local iPos = instigator:GetPosition()                   
                   local targByDist = {}
                   for a, b in targets do
                       if not b:BeenDestroyed() then                 
                           table.insert(targByDist, {dist = utilities.XZDistanceTwoVectors(iPos, b:GetPosition()), unit = b})
                       end
                   end
                   table.sort(targByDist, sort_by('dist'))                 
                   local validTarg = {}
                   table.insert(validTarg, targetEntity)
                   for c = 1, (self.ChainJumps) do
                        table.insert(validTarg, targByDist[c].unit)
                   end                 
                   -- Show avalible targets by range during debug mode
                   if self.BeamDebug then           
                       for d, e in validTarg do
                           WARN('   Unit: ', e:GetEntityId(), ' Distance: ', utilities.XZDistanceTwoVectors(iPos, e:GetPosition()) )                           
                       end
                   end                                                           
                   -- Loop thru avalible targets
                   local num = table.getsize(validTarg)               
                   while self and num > 1 do       
                       -- Create beam and dmg FX
                       self:ForkThread(self.ChainBeamFX, validTarg[(num - 1)], validTarg[num], army, beamLifeTime)
                       self:ForkThread(self.ChainDmgFX, validTarg[num], army, self.FxBeamEndPointScale, beamLifeTime)                                                                             
                       -- Apply Damage   
                       self:ForkThread(self.ChainDamage, instigator, validTarg[num], (damageData.DamageAmount / num), damageData.DamageType)   
                       num = num - 1                             
                   end                                                                                                                   
               end
           end         
        end
        CollisionBeam.DoDamage(self, instigator, damageData, targetEntity)                     
    end,
   
    ChainBeamFX = function(self, target1, target2, army, duration)
        for f, g in self.FxBeam do
            if target1 and not target1:BeenDestroyed() and target2 and not target2:BeenDestroyed() then                     
               local beam = AttachBeamEntityToEntity(target1, -1, target2, -1, army, g)                         
               table.insert(self.BeamEffectsBag, beam)
               self.Trash:Add(beam)
               WaitSeconds(duration)
               if self and beam then
                   beam:Destroy()
               end
           end
        end   
    end,
   
    ChainDmgFX = function(self, target, army, scale, duration)
        for h, i in self.FxBeamEndPoint do
            if target and not target:BeenDestroyed() then   
                local fx = CreateAttachedEmitter(target, -1, army, i ):ScaleEmitter(scale)
                table.insert(self.BeamEffectsBag, fx)
                self.Trash:Add(fx)
               WaitSeconds(duration)
               if self and fx then
                   fx:Destroy()
               end               
            end
        end   
    end,   
   
    ChainDamage = function(self, instigator, target, dmg, dmgtype)
        if target and not target:BeenDestroyed() then
			target:SetStunned(2)		
            Damage(instigator, self:GetPosition(), target, dmg, dmgtype)
        end   
    end,  

    OnDisable = function( self )
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil   
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 1.5 + (Random() * 1.5) 
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end
                
            WaitSeconds( self.ScorchSplatDropTime )
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}