#
# Terran Napalm Carpet Bomb
#
local TNapalmCarpetBombProjectile = import('/lua/sim/defaultprojectiles.lua').SinglePolyTrailProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

TIFEagleSmokeScreenBomb01 = Class(TNapalmCarpetBombProjectile) {

	OnImpact = function(self, TargetType, targetEntity)
	
		local FxFragEffect = EffectTemplate.TFragmentationSensorShellFrag 
              
        
        # Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
	
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UEFSSP0100b2', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		TNapalmCarpetBombProjectile.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TIFEagleSmokeScreenBomb01
