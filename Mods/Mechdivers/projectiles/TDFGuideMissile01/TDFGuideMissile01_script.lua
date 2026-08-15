local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
EmtBpPath = '/effects/emitters/'
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TDFGuideMissile01 = Class(SingleBeamProjectile) {
    InitialEffects = {'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',},
    LaunchEffects = {
        '/effects/emitters/nuke_munition_launch_trail_03_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_05_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_07_emit.bp',
    },
    ThrustEffects = {'/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
                     '/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    },
	
	BeamName = '/effects/emitters/missile_exhaust_fire_beam_01_emit.bp',
	
	# Hit Effects
    FxImpactUnit = {  
	EmtBpPath .. 'uef_t2_artillery_hit_01_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_02_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_03_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_04_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_05_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_06_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_07_emit.bp',
	EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',
	},
    FxImpactProp = {  
	EmtBpPath .. 'uef_t2_artillery_hit_01_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_02_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_03_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_04_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_05_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_06_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_07_emit.bp',
	},
    FxImpactLand = {
	EmtBpPath .. 'uef_t2_artillery_hit_01_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_02_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_03_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_04_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_05_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_06_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_07_emit.bp',
	},
    FxLandHitScale = 1.2,
    FxUnitHitScale = 1.5,
    FxSplatScale = 4,
    FxImpactUnderWater = {},
	
	OnCreate = function(self)
	    self.DamageData = {
            DamageRadius = 0,
            DamageAmount = nil,
            DamageType = nil,
            DamageFriendly = nil,
            MetaImpactAmount = nil,
            MetaImpactRadius = nil,
        }
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
		local army = self:GetArmy()
		self.Army = self:GetArmy()
		self:MovementThread()
    end,
	
	 MovementThread = function(self)
	 ForkThread( function()
        local army = self:GetArmy()
        local launcher = self:GetLauncher()
		self:TrackTarget(false)
		self.CreateEffects( self, self.InitialEffects, army, 1 )
		self.CreateEffects( self, self.LaunchEffects, army, 1 )
		self.CreateEffects( self, self.ThrustEffects, army, 3 )
		CreateBeamEmitterOnEntity(self, 'Exhaust', army, self.BeamName):SetBeamParam('THICKNESS', 0.01):SetBeamParam('LENGTH', 1.5)
        WaitSeconds(0.3)		# Height
        self:SetCollision(true)
        WaitSeconds(0.3)
        self:TrackTarget(true) # Turn ~90 degrees towards target
        self:SetDestroyOnWater(true)
        self:SetTurnRate(47.36)
        WaitSeconds(2) 					# Now set turn rate to zero so nuke flies straight
        self:SetTurnRate(0)
        self:SetAcceleration(0.001)
        self.WaitTime = 0.5
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
		end)
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        #Get the nuke as close to 90 deg as possible
        if dist > 150 then        
            #Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(0)
        elseif dist > 75 and dist <= 150 then
						# Increase check intervals
            self.WaitTime = 0.3
        elseif dist > 32 and dist <= 75 then
						# Further increase check intervals
            self.WaitTime = 0.1
        elseif dist < 32 then
						# Turn the missile down
            self:SetTurnRate(50)
        end
    end,
    
    CheckMinimumSpeed = function(self, minSpeed)
        if self:GetCurrentSpeed() < minSpeed then
            return false
        end
        return true
    end,
    
    SetMinimumSpeed = function(self, minSpeed, resetAcceleration)
        if self:GetCurrentSpeed() < minSpeed then
            self:SetVelocity(minSpeed)
            if resetAcceleration then
                self:SetAcceleration(0)
            end
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,
	
	CreateEffects = function( self, EffectTable, army, scale)
        for k, v in EffectTable do
            CreateAttachedEmitter(self, -1, army, v):ScaleEmitter(scale):OffsetEmitter(0,0,2)
        end
    end,
	
	OnImpact = function(self, targetType, targetEntity)
        if targetType == 'Terrain' then
           	local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(5,5)
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
        end
        SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
    end,

}

TypeClass = TDFGuideMissile01

