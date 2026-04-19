#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFLaserHydrogenWeapon = ModWeaponsFile.CDFLaserHydrogenWeapon
local CIFGrenadeWeapon = CybranWeaponsFile.CIFGrenadeWeapon

CSKMDCL0207 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserHydrogenWeapon) {},
		Grenade = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
            },
            FxMuzzleFlashScale = 0,
        },
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('Grenade', false)
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		--self:HideBone('B01', true)
	end,	
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(2)
		elseif bit == 7 then
		self:SetWeaponEnabledByLabel('Grenade', true)
		local TargetUnit = self:GetWeaponByLabel('MainGun'):GetCurrentTarget()
		local TargetPos = self:GetWeaponByLabel('MainGun'):GetCurrentTargetPos()
		IssueClearCommands({self})
		self:SetWeaponEnabledByLabel('MainGun', false)
		if TargetUnit and TargetPos == nil then
		self:GetWeaponByLabel('Grenade'):SetTargetEntity(TargetUnit)
		elseif TargetUnit == nil and TargetPos then
		self:GetWeaponByLabel('Grenade'):SetTargetGround(TargetPos)
		end
		self:SetImmobile(true)
		WaitSeconds(2)
		IssueClearCommands({self})
		self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
		elseif bit == 7 then
		self:SetWeaponEnabledByLabel('Grenade', false)
		self:SetWeaponEnabledByLabel('MainGun', true)
		self:SetImmobile(false)
        end
    end,
}

TypeClass = CSKMDCL0207