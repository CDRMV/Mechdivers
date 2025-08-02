local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

URBMD001 = Class(TStructureUnit) {
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
    end,

	AutomaticDetonationThread = function(self)
		local army = self:GetArmy()
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 1, 'Enemy')
            for _,unit in units do
				ForkThread( function()
				CreateAttachedEmitter(self, 0, army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
				CreateAttachedEmitter(self,0, army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
				CreateDeathExplosion( self, 0, 0.5)
				explosion.CreateFlash( self, 0, 1, army )
				DamageArea(self, self:GetPosition(), 1, 250, 'Fire', false, true)
				self:Kill()
				end)
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,
}

TypeClass = URBMD001
