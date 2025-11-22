#
# Cybran EMP Grenade
#
local CArtilleryProjectile = import('/lua/cybranprojectiles.lua').CArtilleryProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

CIFGrenade02 = Class(CArtilleryProjectile) {
	
	OnCreate = function(self)
		CArtilleryProjectile.OnCreate(self)
		self:SetMaxSpeed(math.random(5,12))
		self.Number = 0
		CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Mechdivers/effects/emitters/Cybergrenade_01_emit.bp'):OffsetEmitter(0,0,0.1):ScaleEmitter(0.1)
		CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Mechdivers/effects/emitters/Cybergrenade_02_emit.bp'):OffsetEmitter(0,0,0.1):ScaleEmitter(0.1)
		CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/Mechdivers/effects/emitters/Cybergrenade_03_emit.bp'):OffsetEmitter(0,0,0.1):ScaleEmitter(0.1)
	end,  

    OnImpact = function(self, targetType, targetEntity)
		if self.Number == 0 then
        ForkThread( function()
		if targetType == 'Water' then
            self:Destroy()
        end
        if targetType == 'Terrain' then
			WaitSeconds(3) 
			CreateEmitterAtEntity(self, self:GetArmy(), '/effects/emitters/cybran_empgrenade_hit_01_emit.bp'):ScaleEmitter(1)
			CreateEmitterAtEntity(self, self:GetArmy(), '/effects/emitters/cybran_empgrenade_hit_02_emit.bp'):ScaleEmitter(1)	
			CreateEmitterAtEntity(self, self:GetArmy(), '/effects/emitters/cybran_empgrenade_hit_03_emit.bp'):ScaleEmitter(1)	
			CreateLightParticle( self, -1, self:GetArmy(), 7, 12, 'glow_03', 'ramp_red_06' )
			CreateLightParticle( self, -1, self:GetArmy(), 7, 22, 'glow_03', 'ramp_antimatter_02' ) 
			self:Destroy()
        end
		end)
		self.Number = 1
		end
    end,	
}

TypeClass = CIFGrenade02