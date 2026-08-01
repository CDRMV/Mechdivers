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
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CSKMDTL0309 = Class(TLandUnit) {

    Weapons = {
		ACGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
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
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0309/CSKMDTL0309_ADeploy.sca', false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0309/CSKMDTL0309_ADrill.sca', false):SetRate(0)
		if not self.AnimationManipulator3 then
            self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
        end
		self.AnimationManipulator3:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0309/CSKMDTL0309_APump.sca', true):SetRate(0)
		Spinner = CreateRotator(self, 'Drill_Head', 'z', nil, 0, 60, 360):SetTargetSpeed(0)
    end,
	
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)	
		ForkThread( function()
		if bit == 1 then 
		self:SetImmobile(true)
		self.AnimationManipulator1:SetRate(0.15)
		WaitFor(self.AnimationManipulator1)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		elseif bit == 7 then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		Spinner:SetTargetSpeed(180)
		self.AnimationManipulator2:SetRate(0.3)	
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(3,3)
		self.Effect1 = CreateAttachedEmitter(self,'Drill_Effect',self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(2):SetEmitterParam('LIFETIME', -1)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,'Drill_Effect',self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(2):SetEmitterParam('LIFETIME', -1):OffsetEmitter(0,-1,0)
		self.Trash:Add(self.Effect2)
		WaitSeconds(1)
		CreateDecal(self:GetPosition('Drill_Head'), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 0, self:GetArmy())
		WaitFor(self.AnimationManipulator2)
		if not self.AnimationManipulator3 then
            self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
			self.AnimationManipulator3:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0309/CSKMDTL0309_APump.sca', true):SetRate(0.15)
        end
		if self.AnimationManipulator3 then
			self.AnimationManipulator3:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0309/CSKMDTL0309_APump.sca', true):SetRate(0.15)
        end
		end
		end)
	end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread( function()
		if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator1:SetRate(-0.15)
		WaitFor(self.AnimationManipulator1)
		self:SetImmobile(false)
		elseif bit == 7 then
		Spinner:SetSpinDown(true)
		Spinner:SetTargetSpeed(0)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.AnimationManipulator2:SetRate(-0.3)
		self.AnimationManipulator3:Destroy()
		WaitFor(self.AnimationManipulator2)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		end
		end)
    end,

}

TypeClass = CSKMDTL0309