#
# UEF Small Yield Nuclear Bomb
#
local TIFSmallYieldNuclearBombProjectile = import('/lua/sim/defaultprojectiles.lua').SinglePolyTrailProjectile
TIFEagle500KGBomb01 = Class(TIFSmallYieldNuclearBombProjectile) {
DestroyOnImpact = false,
PolyTrail = '/effects/emitters/default_polytrail_01_emit.bp',

    OnCreate = function(self, inWater)
		self.army = self:GetArmy()
		self.aibrain = GetArmyBrain(self.army)
		self.number = 0
		TIFSmallYieldNuclearBombProjectile.OnCreate( self, inWater )
    end,
	
	OnImpactDestroy = function(self, targetType, targetEntity)
        if self.DestroyOnImpact == false then
        if targetType != 'Water' then 
		local position = self:GetPosition()
		ForkThread(function()
		WaitSeconds(2)
		if self.number == 0 then
		DamageArea(self, position, 15, 1, 'Force', true)
		DamageArea(self, position, 15, 1, 'Force', true)
		local units = self.aibrain:GetUnitsAroundPoint(categories.MOBILE + categories.LAND, position, 15, 'Enemy')
        for _,unit in units do
			Damage(self, position, unit, 15000, 'Fire')
        end
		local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(45.75,45.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self.army)
		nukeProjectile = self:CreateProjectile('/mods/Mechdivers/effects/Entities/Blu3000/Blu3000EffectController01/Blu3000EffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
        nukeProjectile:PassDamageData(self.DamageData)
        nukeProjectile:PassData(self.Data)
		self.number = 1
		self:Destroy()
		end
		end)
		end
        end
    end,
}

TypeClass = TIFEagle500KGBomb01