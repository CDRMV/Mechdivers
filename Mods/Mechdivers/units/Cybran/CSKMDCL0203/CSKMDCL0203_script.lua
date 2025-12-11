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
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon

CSKMDCL0203 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
		MissileRack = Class(CIFGrenadeWeapon) {
		
		-------------------------------------------- 
		-- Missilelauncher Unpack and Pack Sequence
		--------------------------------------------
		-- To Fix an Walk Animation Issue caused by the Weapon Unpack Animation is not getting deleted by the Game itself.
		-- We need to do that manually with the Code below.
		------------------------------------------------------------------------------------------------------------------
		
		PlayFxWeaponUnpackSequence = function(self)
			if self.WeaponPackState == 'Unpacked' then
		
			else
			local bp = self.Blueprint
			self.UnpackAnimator = CreateAnimator(self.unit)
			self.UnpackAnimator:PlayAnim('/mods/Mechdivers/units/Cybran/CSKMDCL0203/CSKMDCL0203_AUnpack2.sca'):SetRate(2)
			self.WeaponPackState = 'Unpacking'
			WaitFor(self.UnpackAnimator)
			self.WeaponPackState = 'Unpacked'
			end
		end,

		PlayFxWeaponPackSequence = function(self)
			local bp = self.Blueprint
			local unpackAnimator = self.UnpackAnimator
			if unpackAnimator and self.WeaponPackState == 'Unpacked' then
				unpackAnimator:SetRate(-2)
				self.WeaponPackState = 'Packing'
				WaitFor(unpackAnimator)
				unpackAnimator:Destroy()
				self.unit:SetImmobile(false)
			end	
			self.WeaponPackState = 'Packed'
		end,
		
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('R_Arm_B04', true)
		self:HideBone('L_Arm_Shield', true)
		self:HideBone('L_Arm_Shield2', true)
		self:HideBone('B01', true)
		self:HideBone('B03', true)
		self:HideBone('B04', true)
	end,
	
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(1.4)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        end
    end,
}

TypeClass = CSKMDCL0203