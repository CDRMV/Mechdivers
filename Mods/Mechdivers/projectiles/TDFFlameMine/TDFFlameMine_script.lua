#
# Terran Gauss Cannon Projectile

local TDFMineProjectile = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').TDFMineProjectile
TDFFlameMine = Class(TDFMineProjectile) {
	
    OnCreate = function(self, inWater)
        TDFMineProjectile.OnCreate(self, inWater)
        if not inWater then
            self:SetDestroyOnWater(true)
        else
            self:ForkThread(self.DestroyOnWaterThread)
        end
    end,
    
    DestroyOnWaterThread = function(self)
        WaitSeconds(0.2)
        self:SetDestroyOnWater(true)
    end,
	
	OnImpact = function(self, TargetType, targetEntity)
		TDFMineProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UEBMD001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
	end,
}
TypeClass = TDFFlameMine

