-- Flamethrower Projectile

local Flamethrower02 = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').SmallAcidthrower
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TEAcidThrower01 = Class(Flamethrower02) {
    OnImpact = function(self, TargetType, targetEntity)
		if TargetType != 'Water' then 
			local rotation = RandomFloat(0,2*math.pi)
			local size = RandomFloat(2.50,2.0)
	        
			CreateDecal(self:GetPosition(), rotation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', size, size, 150, 15, self:GetArmy())
		end	 
		Flamethrower02.OnImpact( self, TargetType, targetEntity )
    end,
}

TypeClass = TEAcidThrower01
