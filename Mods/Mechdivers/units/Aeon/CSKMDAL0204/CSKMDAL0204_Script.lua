#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0106/UAL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDAL0204 = Class(AWalkingLandUnit) {
    Weapons = {
			Dummy = Class(DummyTurretWeapon) {},
MainGun = Class(ADFCannonQuantumWeapon) { 			


		    PlayFxWeaponPackSequence = function(self)
				ForkThread(function()
				self.unit.UnpackAnimManip:SetRate(-2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponPackSequence(self)
            end,
			
			PlayFxWeaponUnpackSequence = function(self)
				ForkThread(function()
				self.unit.UnpackAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0204/CSKMDAL0204_Attack.sca', false)
				self.unit.UnpackAnimManip:SetRate(2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponUnpackSequence(self)
            end,

},

MainGun2 = Class(ADFCannonQuantumWeapon) { 			


		    PlayFxWeaponPackSequence = function(self)
				ForkThread(function()
				self.unit.UnpackAnimManip:SetRate(-2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponPackSequence(self)
            end,
			
			PlayFxWeaponUnpackSequence = function(self)
				ForkThread(function()
				self.unit.UnpackAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0204/CSKMDAL0204_Attack2.sca', false)
				self.unit.UnpackAnimManip:SetRate(2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponUnpackSequence(self)
            end,

}
    },
	
	OnScriptBitSet = function(self, bit)
        AWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		IssueClearCommands({self})
		self.MainGun2:SetEnabled(true)
		self.Dummy:ChangeMaxRadius(30)
		self.Dummy:ChangeMinRadius(0)
		self.MainGun:ChangeMaxRadius(0)
		self.MainGun:ChangeMinRadius(0)
		self.MainGun2:ChangeMaxRadius(30)
		self.MainGun2:ChangeMinRadius(0)
		self.MainGun:SetEnabled(false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        AWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		IssueClearCommands({self})
		self.MainGun:SetEnabled(true)
		self.Dummy:ChangeMaxRadius(128)
		self.Dummy:ChangeMinRadius(5)
		self.MainGun:ChangeMaxRadius(128)
		self.MainGun:ChangeMinRadius(5)
		self.MainGun2:ChangeMaxRadius(0)
		self.MainGun2:ChangeMinRadius(0)
		self.MainGun2:SetEnabled(false)
        end
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.UnpackAnimManip = CreateAnimator(self)
		self.Trash:Add(self.UnpackAnimManip)
		self.UnpackAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0204/CSKMDAL0204_Attack.sca', false):SetRate(0)
		self.Dummy = self:GetWeaponByLabel('Dummy')
		self.MainGun = self:GetWeaponByLabel('MainGun')
		self.MainGun2 = self:GetWeaponByLabel('MainGun2')
		self.MainGun2:SetEnabled(false)
    end,

	OnMotionHorzEventChange = function(self, new, old)
        AWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Mechdivers/units/Aeon/CSKMDAL0204/CSKMDAL0204_Awalk01.sca', true):SetRate(1)
        elseif new == 'Stopped' then
			if self.OpenAnimManip then
			self.OpenAnimManip:Destroy()
			end
			if self.ArmAnimManip then
			self.ArmAnimManip:Destroy()
			end
        end       
		end)
    end,

}


TypeClass = CSKMDAL0204