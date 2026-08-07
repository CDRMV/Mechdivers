local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
EmtBpPath = '/effects/emitters/'
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TDFMissile01 = Class(SingleBeamProjectile) {
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
		CreateBeamEmitterOnEntity(self, 'Exhaust', army, self.BeamName):SetBeamParam('THICKNESS', 0.01):SetBeamParam('LENGTH', 1.5)
        self.CreateEffects( self, self.InitialEffects, army, 1 )
        self.CreateEffects( self, self.LaunchEffects, army, 1 )
        self.CreateEffects( self, self.ThrustEffects, army, 1 )
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

TypeClass = TDFMissile01

