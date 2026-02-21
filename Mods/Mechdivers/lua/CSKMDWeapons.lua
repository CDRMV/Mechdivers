local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local CollisionBeams = import('/lua/defaultcollisionbeams.lua')
local ModCollisionBeams = import('/mods/Mechdivers/lua/CSKMDBeams.lua')
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local GinsuCollisionBeam = CollisionBeams.GinsuCollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ModEffects = '/mods/Mechdivers/effects/emitters/'
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

ADFLightningBeam = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.LightningCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {}, ####EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.1,
}

TDFHeatBeam = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.HeatCollisionBeam,
    FxChargeMuzzleFlash = {

    },
}

CDFLaserHydrogenWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CHydrogenLaserMuzzleFlash,
}

CDFHLaserHydrogenWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CHydrogenLaserMuzzleFlash,
	FxChargeMuzzleFlash = {
		ModEffects .. 'heavyHydrogen_flash_01_emit.bp',
        ModEffects .. 'heavyHydrogen_flash_02_emit.bp',
        ModEffects .. 'heavyHydrogen_flash_03_emit.bp',
    },
}

CDFLaserFusionWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CFusionLaserMuzzleFlash,
}

CDFHLaserFusionWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CFusionLaserMuzzleFlash,
	FxChargeMuzzleFlash = {
		ModEffects .. 'heavyfusion_flash_01_emit.bp',
        ModEffects .. 'heavyfusion_flash_02_emit.bp',
        ModEffects .. 'heavyfusion_flash_03_emit.bp',
    },
}

CDFHLaserFusionWeapon2 = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CFusionLaserMuzzleFlash,
	FxRackChargeMuzzleFlash  = {
		ModEffects .. 'heavyfusion_flash_01_emit.bp',
        ModEffects .. 'heavyfusion_flash_02_emit.bp',
        ModEffects .. 'heavyfusion_flash_03_emit.bp',
    },
}

CDFFusionMortarWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = ModEffectTemplate.CFusionMortarMuzzleFlash,
}


TDFLightningBeam = Class(DefaultBeamWeapon) {
    BeamType = ModCollisionBeams.TerranLightningCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {}, ####EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.1,
}