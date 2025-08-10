ModBpPath = '/mods/Mechdivers/effects/emitters/'
EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'
TableCat = import('/lua/utilities.lua').TableCat


CFusionLaserMuzzleFlash = {
    ModBpPath .. 'Fusion_laser_muzzle_flash_01_emit.bp',
    ModBpPath .. 'Fusion_laser_muzzle_flash_02_emit.bp',
}

CFusionMortarMuzzleFlash = {
   '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
   '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
   '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
    ModBpPath .. 'Fusion_laser_muzzle_flash_01_emit.bp',
    ModBpPath .. 'Fusion_laser_muzzle_flash_02_emit.bp',
}


CHeavyFusionLaserFXTrail01 =  { 
    ModBpPath .. 'HFusion_laser_fxtrail_01_emit.bp',     
}
CHeavyFusionLaserPolyTrail =  {
ModBpPath .. 'Fusion_Laser_emit.bp',
}

CHeavyFusionMortarFXTrail01 =  { 
'/effects/emitters/mortar_munition_03_emit.bp',
    ModBpPath .. 'HFusion_laser_fxtrail_01_emit.bp',     
}
CHeavyFusionMortarPolyTrail =  ModBpPath .. 'Fusion_Laser_emit.bp'


CPhotonMissileFxtrails= {
	ModBpPath .. 'proton_missile_fxtrail_emit.bp',
    ModBpPath .. 'proton_missile_smoke_exhaust_emit.bp',
}