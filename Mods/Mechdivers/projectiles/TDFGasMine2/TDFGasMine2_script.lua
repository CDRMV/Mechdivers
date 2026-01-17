#
# Terran Gauss Cannon Projectile

local TDFMineProjectile = import('/mods/Mechdivers/lua/CSKMDProjectiles.lua').TDFMineProjectile
TDFGasMine2 = Class(TDFMineProjectile) {
	
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
		local position = self:GetPosition()
		if TargetType == 'Water' then
		
		else
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('UEBMD004', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		TDFMineProjectile.OnImpact( self, TargetType, targetEntity )
	end,
}
TypeClass = TDFGasMine2

