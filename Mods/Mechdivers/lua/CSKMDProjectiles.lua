local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffectTemplate = import('/mods/Mechdivers/lua/CSKMDEffectTemplates.lua')
local NullShell = DefaultProjectileFile.NullShell

#------------------------------------------------------------------------
#  UEF PROJECTILES
#------------------------------------------------------------------------


Flamethrower01 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Mechdivers/Effects/Emitters/FlamerthrowerTrailFX.bp',},
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
}

Flamethrower02 = Class(EmitterProjectile) {
    FxTrails = {'/mods/Mechdivers/Effects/Emitters/FlamerthrowerTrailFX.bp',},
       FxTrailScale = 0.5,
    
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmCarpetBombHitWater01,
    FxImpactUnderWater = {},
    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxNoneHitScale = 0.5,
}

TDFMineProjectile = Class(MultiPolyTrailProjectile) {
    FxTrails = {},
    PolyTrails = {'/mods/Mechdivers/Effects/Emitters/empty_trail_emit.bp',},
    PolyTrailOffset = {0,0},
    FxImpactUnit = EffectTemplate.TGaussCannonHitUnit01,
    FxImpactProp = EffectTemplate.TGaussCannonHitUnit01,
    FxImpactLand = nil,
    FxTrailOffset = 0,
    FxImpactUnderWater = {},
}





