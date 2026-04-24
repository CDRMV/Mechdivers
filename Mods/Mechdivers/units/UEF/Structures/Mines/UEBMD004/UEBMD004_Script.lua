local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local MineExplosion = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').MineExplosion
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
EmtBpPath = '/effects/emitters/'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UEBMD004 = Class(TStructureUnit) {

    Weapons = {
        Suicide = Class(MineExplosion) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self:SetCollisionShape('Sphere', 0, 0, 0, 0.5)
    end,
	
	FxImpactLand = {
	EmtBpPath .. 'uef_t2_artillery_hit_01_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_02_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_03_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_04_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_05_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_06_emit.bp',
	EmtBpPath .. 'uef_t2_artillery_hit_07_emit.bp',
	},

	
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()
		local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND - categories.AIR, unitPos, 1, 'Enemy')
            for _,unit in units do
				local location = self:GetPosition()
				SetIgnoreArmyUnitCap(self:GetArmy(), true)
				local Unit =CreateUnitHPR('UEFSSP0200r', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
				if unit then
				Unit:AttachBoneTo(0, unit, 0)
				end
				SetIgnoreArmyUnitCap(self:GetArmy(), false)
            end

				for e, effect in self.FxImpactLand do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(0.5)
				end
			self.Effect1 = CreateEmitterAtEntity(self,self:GetArmy(), EmtBpPath .. 'miasma_cloud_01_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', 60)
		self.Effect2 = CreateEmitterAtEntity(self,self:GetArmy(), EmtBpPath .. 'miasma_cloud_01_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', 60)			
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

TypeClass = UEBMD004
