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
local TAAFlakArtilleryCannon = import('/lua/terranweapons.lua').TAAFlakArtilleryCannon

UEBMD00303 = Class(TStructureUnit) {
	Weapons = {
        MainGun = Class(TAAFlakArtilleryCannon) {
            FxMuzzleFlashScale = 3,
        },
		GroundGun = Class(TAAFlakArtilleryCannon) {
            FxMuzzleFlashScale = 3,
        },
    },
	
	OnCreate = function(self)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(0)
		if not self.AnimationUnpack1Manipulator then
            self.AnimationUnpack1Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack1Manipulator)
        end
        self.AnimationUnpack1Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack1, false):SetRate(0)	
		if not self.AnimationUnpack2Manipulator then
            self.AnimationUnpack2Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack2Manipulator)
        end
        self.AnimationUnpack2Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(0)
		if not self.AnimationUnpack3Manipulator then
            self.AnimationUnpack3Manipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationUnpack3Manipulator)
        end
        self.AnimationUnpack3Manipulator:PlayAnim(self:GetBlueprint().Display.AnimationUnpack3, false):SetRate(0)
        TStructureUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('GroundGun', false)
		self.wep = self:GetWeaponByLabel('MainGun')
		self.wep:SetEnabled(false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread( function()	
		self.wep = self:GetWeaponByLabel('MainGun')
		self.wep:SetEnabled(false)
		self.AnimationManipulator:SetRate(1)
		WaitFor(self.AnimationManipulator)
        self.AnimationUnpack1Manipulator:SetRate(0.2)
		WaitFor(self.AnimationUnpack1Manipulator)		
        self.AnimationUnpack2Manipulator:SetRate(0.2)
		WaitFor(self.AnimationUnpack2Manipulator)
        self.AnimationUnpack3Manipulator:SetRate(0.6)
		WaitFor(self.AnimationUnpack3Manipulator)
		self.wep:SetEnabled(true)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		end)
	end,

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('GroundGun', true)
            self:SetWeaponEnabledByLabel('MainGun', false)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
            self:SetWeaponEnabledByLabel('GroundGun', false)
            self:SetWeaponEnabledByLabel('MainGun', true)
        end
    end,	
	
	
}

TypeClass = UEBMD00303