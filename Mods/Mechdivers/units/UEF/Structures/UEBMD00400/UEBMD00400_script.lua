#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2305/UEB2305_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  UEF Strategic Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon

UEBMD00400 = Class(TStructureUnit) {
    Weapons = {
        NukeMissiles = Class(TIFStrategicMissileWeapon) {
		OnWeaponFired = function(self)
			ForkThread( function()	
			CreateAttachedEmitter(self.unit, 0, self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/icbm_launch_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0.8)      
			self.unit.LaunchEffect = false
			WaitSeconds(0.1)
			self.unit:HideBone('Missile', true)        
			end)
		end,
		
		PlayFxWeaponUnpackSequence = function(self)
			self.unit.LaunchEffect = true
            TIFStrategicMissileWeapon.PlayFxWeaponUnpackSequence(self)
        end,
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self.LaunchEffect = false
		while true do
		if self.LaunchEffect == true then
		self:ShowBone('Missile', true)
		self.Effect1 = CreateAttachedEmitter(self, 'R_Exhaust1', self:GetArmy(), '/mods/Mechdivers/effects/emitters/icbm_exhaust_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0)
		self.Effect2 = CreateAttachedEmitter(self, 'R_Exhaust2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/icbm_exhaust_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0)
		self.Effect3 = CreateAttachedEmitter(self, 'L_Exhaust1', self:GetArmy(), '/mods/Mechdivers/effects/emitters/icbm_exhaust_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0)
		self.Effect4 = CreateAttachedEmitter(self, 'L_Exhaust2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/icbm_exhaust_smoke_01_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0)
		self.Effect5 = CreateAttachedEmitter(self, 0, self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_03_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0, -0.3, 0.8)
		self.Effect6 = CreateAttachedEmitter(self, 0, self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_07_emit.bp'):SetEmitterParam('LIFETIME', 5):ScaleEmitter(0.8):OffsetEmitter(0,-0.3, 0.8)
		elseif self.LaunchEffect == false then
		WaitSeconds(1)
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		if self.Effect2 then
		self.Effect2:Destroy()
		end
		if self.Effect3 then
		self.Effect3:Destroy()
		end
		if self.Effect4 then
		self.Effect4:Destroy()
		end
		if self.Effect5 then
		self.Effect5:Destroy()
		end
		if self.Effect6 then
		self.Effect6:Destroy()
		end
		end
		WaitSeconds(0.1)
		end
		end)
	end,
}

TypeClass = UEBMD00400
     