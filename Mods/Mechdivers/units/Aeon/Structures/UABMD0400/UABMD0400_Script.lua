#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2101/UAB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Light Laser Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModEffectpath = '/mods/Mechdivers/effects/emitters/'
UABMD0400 = Class(AStructureUnit) {
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			EffectMesh1 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect01_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 'Effect' )
			self.Beam = nil
			self.Effect01 = nil
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.35)
			EffectMesh2 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect02_mesh'
			self.Effect2 = import('/lua/sim/Entity.lua').Entity()
			self.Effect2:AttachBoneTo( -2, self, 'Effect' )
			self.Effect2:SetMesh(EffectMesh2)
			self.Effect2:SetDrawScale(0.4)
			EffectMesh3 = '/mods/Mechdivers/units/Aeon/Structures/UABMD0400/Exospire_Effect03_mesh'
			self.Effect3 = import('/lua/sim/Entity.lua').Entity()
			self.Effect3:AttachBoneTo( -2, self, 'Effect' )
			self.Effect3:SetMesh(EffectMesh3)
			self.Effect3:SetDrawScale(0.345)
					self.Effect1:SetVizToAllies('Intel')
		self.Effect1:SetVizToNeutrals('Intel')
		self.Effect1:SetVizToEnemies('Intel')
		self.Effect2:SetVizToAllies('Intel')
		self.Effect2:SetVizToNeutrals('Intel')
		self.Effect2:SetVizToEnemies('Intel')
				self.Effect3:SetVizToAllies('Intel')
		self.Effect3:SetVizToNeutrals('Intel')
		self.Effect3:SetVizToEnemies('Intel')
		self.Spinner1 = CreateRotator(self, 'Effect', 'y', nil, 0, 60, 360):SetTargetSpeed(5)
		self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/weather_rainfall_01_emit.bp'):ScaleEmitter(3):OffsetEmitter(0,30,0)
		self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'smoke_cloud_01_emit.bp'):ScaleEmitter(40):OffsetEmitter(0,-20,0)

	end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
		if bit == 3 then 
	
		elseif bit == 1 then 
		
		elseif bit == 7 then
		
        end	
		end)
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
		if bit == 3 then 

		elseif bit == 1 then 

		elseif bit == 7 then

		end
		end)
    end,
	
}

TypeClass = UABMD0400