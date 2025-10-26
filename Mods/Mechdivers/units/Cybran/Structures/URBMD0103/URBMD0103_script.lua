#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0101/URB0101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran T1 Land Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandFactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local modpath = '/mods/Mechdivers/effects/emitters/'

URBMD0103 = Class(CLandFactoryUnit) {
    BuildAttachBone = 'Attachpoint',
    UpgradeThreshhold1 = 0.167,
    UpgradeThreshhold2 = 0.5,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
		while not self.Dead do
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_06_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_07_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_11_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect1',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_12_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_06_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_07_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_11_emit.bp'):ScaleEmitter(0.2)
		CreateAttachedEmitter(self,'Effect2',self:GetArmy(), modpath .. 'botfabricatoreffect_smoke_12_emit.bp'):ScaleEmitter(0.2)
		WaitSeconds(1.2)
		end
		end)
    end,
	
}
TypeClass = URBMD0103