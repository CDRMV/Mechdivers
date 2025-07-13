local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Mechdivers/lua/CSKMDBeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffects = '/mods/Commander Survival Kit Units/effects/emitters/'
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local ModEffectTemplate = import('/mods/Mechdivers/lua/CSKMDEffectTemplates.lua')


DummyTurretWeapon = Class(DefaultProjectileWeapon) {
    
}


ADFQuantumBeam = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.QuantumCollisionBeam,
    FxChargeMuzzleFlash = {
		'/effects/emitters/oblivion_cannon_flash_01_emit.bp',
        '/effects/emitters/oblivion_cannon_flash_02_emit.bp',
        '/effects/emitters/oblivion_cannon_flash_03_emit.bp',
    },
}

TDFHeatBeam = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.HeatCollisionBeam,
    FxChargeMuzzleFlash = {

    },
}
