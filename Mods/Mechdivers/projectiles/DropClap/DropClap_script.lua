#
# Null projectile
#

DropClap = Class(import('/lua/terranprojectiles.lua').TShellRiotProjectileLand) { 
    PolyTrails = {'/mods/Mechdivers/effects/emitters/Null_polytrail_emit.bp'},
    PolyTrailOffset = {0.05,0.05,0.05},
    FxTrails = {'/mods/Mechdivers/effects/emitters/Null_munition_emit.bp'},
    RandomPolyTrails = 1,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactLand = {},
    FxImpactUnderWater = {}, 

    OnCreate = function(self, inWater)
 
    end,

    OnImpact = function(self, impactType, targetEntity)
        self:DetachFrom(true)
    end,	
}

TypeClass = DropClap

