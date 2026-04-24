local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
EmtBpPath = '/effects/emitters/'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local MineExplosion = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').MineExplosion

URBMD001 = Class(TStructureUnit) {

	Weapons = {
        Suicide = Class(MineExplosion) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self:SetCollisionShape('Sphere', 0, 0, 0, 0.5)
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()

				CreateAttachedEmitter(self, 0, army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
				CreateAttachedEmitter(self,0, army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
				CreateDeathExplosion( self, 0, 0.5)
				explosion.CreateFlash( self, 0, 1, army )
	        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
	        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        self:DestroyAllDamageEffects()
        --self:CreateWreckage( overkillRatio )
		
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = URBMD001
