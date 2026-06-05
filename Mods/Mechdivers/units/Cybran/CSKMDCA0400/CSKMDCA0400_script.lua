#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').MobileUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local CIFGrenadeWeapon = import('/lua/cybranweapons.lua').CIFGrenadeWeapon
local CDFHLaserFusionWeapon3 = ModWeaponsFile.CDFHLaserFusionWeapon3
local ModEffects = '/mods/Mechdivers/effects/emitters/'
local CDFTronBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').CDFTronBeam

CSKMDCA0400 = Class(CAirUnit) {
	ChargeEffects = {
		ModEffects .. 'fusion_electricity_01_emit.bp',
		ModEffects .. 'heavyfusion_flash_01_emit.bp',
        ModEffects .. 'heavyfusion_flash_02_emit.bp',
        ModEffects .. 'heavyfusion_flash_03_emit.bp',
    },
	
	Weapons = {
		Beam = Class(CDFTronBeam) {},
		Beam2 = Class(CDFTronBeam) {},
		Dummy = Class(DummyTurretWeapon) {},
		RailGun = Class(CDFHLaserFusionWeapon3) {
		PlayFxRackSalvoChargeSequence = function(self)
		ForkThread( function()
        local bp = self.Blueprint
        local muzzleBones = {
			'MainGun_Muzzle',
		}
        for _, effect in self.unit.ChargeEffects do
            for _, muzzle in muzzleBones do
                CreateAttachedEmitter(self.unit, muzzle, self.unit:GetArmy(), effect):ScaleEmitter(1)
				WaitSeconds(1)
            end
        end
        local chargeStart = bp.Audio.ChargeStart
        if chargeStart then
            self:PlaySound(chargeStart)
        end
		end)
		end,
		},
		FusionGun01 = Class(CDFLaserFusionWeapon) {},
		FusionGun02 = Class(CDFLaserFusionWeapon) {},
		FusionGun03 = Class(CDFLaserFusionWeapon) {},
		FusionGun04 = Class(CDFLaserFusionWeapon) {},
		FusionGun05 = Class(CDFLaserFusionWeapon) {},
		FusionGun06 = Class(CDFLaserFusionWeapon) {},
		FusionGun07 = Class(CDFLaserFusionWeapon) {},
		FusionGun08 = Class(CDFLaserFusionWeapon) {},
		FusionGun09 = Class(CDFLaserFusionWeapon) {},
		FusionGun10 = Class(CDFLaserFusionWeapon) {},
		FusionGun11 = Class(CDFLaserFusionWeapon) {},
		FusionGun12 = Class(CDFLaserFusionWeapon) {},
		MissileRack = Class(CIFGrenadeWeapon) {},
		MissileRack2 = Class(CIFGrenadeWeapon) {},
    },
	
	BuildAttachBone = 'Build',
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCA0400/CSKMDCA0400_AOpen.sca', false):SetRate(0)
		self.Beam = self:GetWeaponByLabel('Beam')
		self.Beam2 = self:GetWeaponByLabel('Beam2')
		self.RailGun = self:GetWeaponByLabel('RailGun')
		self.FusionGun01 = self:GetWeaponByLabel('FusionGun01')
		self.FusionGun02 = self:GetWeaponByLabel('FusionGun02')
		self.FusionGun03 = self:GetWeaponByLabel('FusionGun03')
		self.FusionGun04 = self:GetWeaponByLabel('FusionGun04')
		self.FusionGun05 = self:GetWeaponByLabel('FusionGun05')
		self.FusionGun06 = self:GetWeaponByLabel('FusionGun06')
		self.FusionGun07 = self:GetWeaponByLabel('FusionGun07')
		self.FusionGun08 = self:GetWeaponByLabel('FusionGun08')
		self.FusionGun09 = self:GetWeaponByLabel('FusionGun09')
		self.FusionGun10 = self:GetWeaponByLabel('FusionGun10')
		self.FusionGun11 = self:GetWeaponByLabel('FusionGun11')
		self.FusionGun12 = self:GetWeaponByLabel('FusionGun12')
		self.MissileRack = self:GetWeaponByLabel('MissileRack')
		self.MissileRack2 = self:GetWeaponByLabel('MissileRack2')
		self.Beam:SetEnabled(false)
		self.Beam2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.FusionGun01:SetEnabled(false)
		self.FusionGun02:SetEnabled(false)
		self.FusionGun03:SetEnabled(false)
		self.FusionGun04:SetEnabled(false)
		self.FusionGun05:SetEnabled(false)
		self.FusionGun06:SetEnabled(false)
		self.FusionGun07:SetEnabled(false)
		self.FusionGun08:SetEnabled(false)
		self.FusionGun09:SetEnabled(false)
		self.FusionGun10:SetEnabled(false)
		self.FusionGun11:SetEnabled(false)
		self.FusionGun12:SetEnabled(false)
		self.MissileRack:SetEnabled(false)
		self.MissileRack2:SetEnabled(false)
		self.Drones = {}
		ChangeState(self, self.IdleState)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:CreateEnhancement('HangarbayRemove')
    end,
	
	OnFailedToBuild = function(self)
        CAirUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
			self:SetImmobile(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            CAirUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
			self:SetImmobile(true)
            ChangeState(self, self.BuildingState)
        end,
    },

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            self:SetBusy(true)
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            unitBuilding:HideBone(0, true)
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            CAirUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.FinishedBuildingState)
        end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
			table.insert(self.Drones, unitBuilding)
            unitBuilding:DetachFrom(true)
			unitBuilding:HideScan()
			unitBuilding:MakeSelectable()
			unitBuilding:SetFuelUseTime(500)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() then
                self:AddUnitToStorage(unitBuilding)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBuilding}, worldPos)
                unitBuilding:ShowBone(0,true)
            end
            self:SetBusy(false)
            self:RequestRefreshUI()
            ChangeState(self, self.IdleState)
        end,
    },
	
	
	OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
		self:AddCommandCap('RULEUCC_Transport')
        end
    end,

    OnScriptBitClear = function(self, bit)
        CAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(-1)
		self:RemoveCommandCap('RULEUCC_Transport')
        end
    end,
	
	
	OnKilled = function(self, instigator, type, overkillRatio)
	
	for _, Drone in self.Drones do
	if Drone and not Drone:IsDead() then
		Drone:Kill()
	end
	end
	
	    CAirUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	CreateEnhancement = function(self, enh)
        CAirUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		local wep = self:GetWeaponByLabel('MainGun')
		if enh == 'Hangarbay' then
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:RemoveBuildRestriction(categories.PREDATORDRONE)
		elseif enh == 'HangarbayRemove' then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:AddBuildRestriction(categories.PREDATORDRONE)
        elseif enh == 'OrbitalHeavyFusionLaserBarrage' then
		self.Beam:SetEnabled(false)
		self.Beam2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.FusionGun01:SetEnabled(true)
		self.FusionGun02:SetEnabled(true)
		self.FusionGun03:SetEnabled(true)
		self.FusionGun04:SetEnabled(true)
		self.FusionGun05:SetEnabled(true)
		self.FusionGun06:SetEnabled(true)
		self.FusionGun07:SetEnabled(true)
		self.FusionGun08:SetEnabled(true)
		self.FusionGun09:SetEnabled(true)
		self.FusionGun10:SetEnabled(true)
		self.FusionGun11:SetEnabled(true)
		self.FusionGun12:SetEnabled(true)
		self.MissileRack:SetEnabled(false)
		self.MissileRack2:SetEnabled(false)
        elseif enh == 'OrbitalLaser' then
		self.Beam:SetEnabled(true)
		self.Beam2:SetEnabled(true)
		self.RailGun:SetEnabled(false)
		self.FusionGun01:SetEnabled(false)
		self.FusionGun02:SetEnabled(false)
		self.FusionGun03:SetEnabled(false)
		self.FusionGun04:SetEnabled(false)
		self.FusionGun05:SetEnabled(false)
		self.FusionGun06:SetEnabled(false)
		self.FusionGun07:SetEnabled(false)
		self.FusionGun08:SetEnabled(false)
		self.FusionGun09:SetEnabled(false)
		self.FusionGun10:SetEnabled(false)
		self.FusionGun11:SetEnabled(false)
		self.FusionGun12:SetEnabled(false)
		self.MissileRack:SetEnabled(false)
		self.MissileRack2:SetEnabled(false)
		elseif enh == 'OrbitalHeavyFusionRailgun' then
		self.Beam:SetEnabled(false)
		self.Beam2:SetEnabled(false)
		self.RailGun:SetEnabled(true)
		self.FusionGun01:SetEnabled(false)
		self.FusionGun02:SetEnabled(false)
		self.FusionGun03:SetEnabled(false)
		self.FusionGun04:SetEnabled(false)
		self.FusionGun05:SetEnabled(false)
		self.FusionGun06:SetEnabled(false)
		self.FusionGun07:SetEnabled(false)
		self.FusionGun08:SetEnabled(false)
		self.FusionGun09:SetEnabled(false)
		self.FusionGun10:SetEnabled(false)
		self.FusionGun11:SetEnabled(false)
		self.FusionGun12:SetEnabled(false)
		self.MissileRack:SetEnabled(false)
		self.MissileRack2:SetEnabled(false)
		elseif enh == 'OrbitalProtonMissileBarrage' then
		self.Beam:SetEnabled(false)
		self.Beam2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.FusionGun01:SetEnabled(false)
		self.FusionGun02:SetEnabled(false)
		self.FusionGun03:SetEnabled(false)
		self.FusionGun04:SetEnabled(false)
		self.FusionGun05:SetEnabled(false)
		self.FusionGun06:SetEnabled(false)
		self.FusionGun07:SetEnabled(false)
		self.FusionGun08:SetEnabled(false)
		self.FusionGun09:SetEnabled(false)
		self.FusionGun10:SetEnabled(false)
		self.FusionGun11:SetEnabled(false)
		self.FusionGun12:SetEnabled(false)
		self.MissileRack:SetEnabled(true)
		self.MissileRack2:SetEnabled(true)
        end
    end,

}

TypeClass = CSKMDCA0400