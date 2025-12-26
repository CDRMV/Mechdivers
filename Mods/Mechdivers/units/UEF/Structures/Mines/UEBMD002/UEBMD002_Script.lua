local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
EmtBpPath = '/effects/emitters/'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

UEBMD002 = Class(TStructureUnit) {
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self:SetCollisionShape('Sphere', 0, 0, 0, 0.5)
		self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
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

	AutomaticDetonationThread = function(self)
		local army = self:GetArmy()
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 1, 'Enemy')
            for _,unit in units do
				self:Kill()
            end
            
            #Wait 2 seconds
            WaitSeconds(1)
		end	
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()

				for e, effect in self.FxImpactLand do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(0.5)
				end
    explosion.CreateFlash( self, 0, 1, army )
	DamageArea(self, self:GetPosition(), 1, 750, 'Fire', false, true)
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

TypeClass = UEBMD002
