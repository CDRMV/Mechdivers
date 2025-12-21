#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

UEBMD00301 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {
        }
    },
	
	OnCreate = function(self)
		self:HideBone('B01', true)
		self:HideBone('B02', true)
		self:HideBone('B03', true)
        TStructureUnit.OnCreate(self)
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self:HideBone('B01', true)
		self:HideBone('B02', true)
		self:HideBone('B03', true)
		self.WindowEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.WindowEntity:AttachBoneTo( -1, self, 'Glass' )
        self.WindowEntity:SetMesh('/Mods/Mechdivers/units/UEF/Structures/UEBMD00301/Glass/Glass_mesh')
        self.WindowEntity:SetDrawScale(0.45)
        self.WindowEntity:SetVizToAllies('Intel')
        self.WindowEntity:SetVizToNeutrals('Intel')
        self.WindowEntity:SetVizToEnemies('Intel')        
        self.Trash:Add(self.WindowEntity)
		end)
	end,	
}

TypeClass = UEBMD00301