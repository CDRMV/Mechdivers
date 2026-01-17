#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/sim/defaultprojectiles.lua').SinglePolyTrailProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

TIFEagleNapalmBomb01 = Class(TNapalmCarpetBombProjectile) {

    FxTrails = {},
    
    FxImpactTrajectoryAligned = false,

    # Hit Effects
    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxImpactUnderWater = {},
    PolyTrail = '/effects/emitters/default_polytrail_01_emit.bp',

    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(3.75,5.0)
	        
			CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 15, self:GetArmy())
		end	 
		TNapalmCarpetBombProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFEagleNapalmBomb01
