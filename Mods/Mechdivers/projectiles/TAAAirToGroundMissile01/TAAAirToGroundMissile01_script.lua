#
# Terran Anti Air Missile
#
local TMissileAAProjectile = import('/lua/terranprojectiles.lua').TMissileAAProjectile
TAAAirToGroundMissile01 = Class(TMissileAAProjectile) {
    FxLandHitScale = 1.5,
    FxUnitHitScale = 1.5,

}

TypeClass = TAAAirToGroundMissile01

