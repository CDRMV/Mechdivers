#
# CDFProtonCannon03
#
local CHeavyFusionRailGunProjectile = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').CHeavyFusionRailGunProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

CDFHeavyLaserFusionCannon03 = Class(CHeavyFusionRailGunProjectile) {
    OnImpact = function(self, targetType, targetEntity)
	local myBlueprint = self:GetBlueprint()
	    self.Data = {
            NukeOuterRingDamage = myBlueprint.NukeOuterRingDamage or 10,
            NukeOuterRingRadius = myBlueprint.NukeOuterRingRadius or 40,
            NukeOuterRingTicks = myBlueprint.NukeOuterRingTicks or 20,
            NukeOuterRingTotalTime = myBlueprint.NukeOuterRingTotalTime or 10,

            NukeInnerRingDamage = myBlueprint.NukeInnerRingDamage or 2000,
            NukeInnerRingRadius = myBlueprint.NukeInnerRingRadius or 30,
            NukeInnerRingTicks = myBlueprint.NukeInnerRingTicks or 24,
            NukeInnerRingTotalTime = myBlueprint.NukeInnerRingTotalTime or 24,
        }
	
        local myBlueprint = self:GetBlueprint()
        local myProjectile = self:CreateProjectile( '/effects/Entities/SCUDeath01/SCUDeath01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
        if self.Data then
            myProjectile:PassData(self.Data)
			self:Destroy()
        end
    end,	

}
TypeClass = CDFHeavyLaserFusionCannon03

