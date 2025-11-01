-- Ship-based Anti-Torpedo Script

local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Flare = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').Flare
local EffectTemplate = import('/lua/effecttemplates.lua')

local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile
local EmitterProjectileOnCreate = EmitterProjectile.OnCreate

-- upvalue scope for performance
local IsEnemy = IsEnemy
local EntityCategoryContains = EntityCategoryContains

-- pre-computed for performance
local FlareCategories = categories.MISSILE


flare = Class(EmitterProjectile) {
	

    FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 3,
    FxPropHitScale = 1,
    FxProjectileHitScale = 3,
    FxProjectileUnderWaterHitScale = 0.1,
    FxShieldHitScale = 1,
    FxUnderWaterHitScale = 0.1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 0.1,
    FxOnKilledScale = 3,
    FxTrails = {
	--'/mods/Mechdivers/effects/emitters/mgpF1_flaresmoke_emit.bp', --SMOKE
	'/mods/Mechdivers/effects/emitters/mgpF1_flare01_emit.bp', --FIRE
	'/mods/Mechdivers/effects/emitters/mgpF1_flare02_emit.bp', --GLOW
	'/mods/Mechdivers/effects/emitters/mgpF1_flare03_emit.bp', --SPARKS
	},

}

TypeClass = flare
