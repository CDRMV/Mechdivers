#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local MineExplosion = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').MineExplosion
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local explosion = import('/lua/defaultexplosions.lua')

TEB0001 = Class(TStructureUnit) {
	Weapons = {
        Suicide = Class(MineExplosion) {},
    },
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetDoNotTarget(true)
		self:CreateTarmac()
		self:SetCollisionShape('Sphere', 0, 0, 0, 0.5)
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()

				CreateAttachedEmitter(self, 'Bone', army, '/mods/Mechdivers/effects/emitters/acid_mine_cloud_01_emit.bp'):ScaleEmitter(0.3)
				explosion.CreateFlash( self, 0, 1, army )
	        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		CreateDecal(self:GetPosition(), orientation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', 2, 2, 150, 15, self:GetArmy())
        self:DestroyAllDamageEffects()
        --self:CreateWreckage( overkillRatio )
		
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = TEB0001