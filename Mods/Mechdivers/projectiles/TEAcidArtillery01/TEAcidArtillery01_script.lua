#
# CDFProtonCannon03
#
local TSmallAcidArtilleryProjectile = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').TSmallAcidArtilleryProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TEAcidArtillery01 = Class(TSmallAcidArtilleryProjectile) {
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(1.50,1.0)
	        
			CreateDecal(self:GetPosition(), rotation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', size, size, 150, 15, self:GetArmy())
		end	 
		TSmallAcidArtilleryProjectile.OnImpact( self, TargetType, targetEntity )
    end,

}
TypeClass = TEAcidArtillery01

