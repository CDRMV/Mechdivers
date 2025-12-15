local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile

TAAMissile01 = Class(SingleBeamProjectile) {
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

}

TypeClass = TAAMissile01

