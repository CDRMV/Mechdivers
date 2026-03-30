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
local ADFQuantumBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFQuantumBeam
local TDFLightningBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TDFLightningBeam

UABMD0202 = Class(AStructureUnit) {
    Weapons = {
        LightningBeam = Class(TDFLightningBeam) {
		PlayFxMuzzleChargeSequence = function(self, muzzle)
            self.emit = CreateAttachedEmitter( self.unit, 'Muzzle', self.unit:GetArmy(), self.unit.SphereEffectBp ):ScaleEmitter(1)
			self.emit2 = CreateAttachedEmitter( self.unit, 'Muzzle', self.unit:GetArmy(), self.unit.SphereEffectBp2 ):ScaleEmitter(2)
		end,

		OnWeaponFired = function(self)
        TDFLightningBeam.OnLostTarget(self)
		self.emit:Destroy() 
		self.emit2:Destroy()
		end,  	
		}, 
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
			ForkThread( function()
		self.SphereEffectBp = '/mods/Mechdivers/effects/emitters/electricity_01_emit.bp'
		self.SphereEffectBp2 = '/mods/Mechdivers/effects/emitters/electricity_02_emit.bp'
		self.Spinner2 = CreateRotator(self, 'Electro_Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(90)
		self.emit3 = CreateAttachedEmitter( self, 'Muzzle', self:GetArmy(), self.SphereEffectBp ):ScaleEmitter(0.5)
		self:DoElectroEffect()
		end
		)
    end,
	
	DoElectroEffect = function(self)
		ForkThread( function()
		local ChoosedBone = nil
		while not self.Dead do
		local number = math.random(0, 4)
		if number == 0 then
		
		else
		if number == 1 then
		ChoosedBone = 'Electro_Effect01'
		end
		if number == 2 then
		ChoosedBone = 'Electro_Effect02'
		end
		if number == 3 then
		ChoosedBone = 'Electro_Effect03'
		end
		if number == 4 then
		ChoosedBone = 'Electro_Effect04'
		end
		self.Beam = AttachBeamEntityToEntity(self, 'Muzzle', self, ChoosedBone, self:GetArmy(), '/mods/Mechdivers/effects/emitters/Lightning_beam_02_emit.bp')
		WaitSeconds(0.1)
		self.Beam:Destroy()
		end
		WaitSeconds(0.1)
		end
		end)
    end,
}

TypeClass = UABMD0202