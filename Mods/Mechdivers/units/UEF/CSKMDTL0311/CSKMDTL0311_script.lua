#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TMobileKamikazeBombWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TMobileKamikazeBombWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CSKMDTL0311 = Class(TLandUnit) {

    Weapons = {
		ACGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'L_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		if not self.AnimationManipulator1 then
            self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_ADeploy.sca', false):SetRate(0)
    end,
	

}

TypeClass = CSKMDTL0311