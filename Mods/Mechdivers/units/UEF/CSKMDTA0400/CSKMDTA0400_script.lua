#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TIFMediumArtilleryStrike = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TIFMediumArtilleryStrike
local TDFHeatBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TDFHeatBeam
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

CSKMDTA0400 = Class(TAirUnit) {
	Weapons = {
		RailGun = Class(DummyTurretWeapon) {

    IdleState = State(DummyTurretWeapon.IdleState) {
        Main = function(self)
            DummyTurretWeapon.IdleState.Main(self)
        end,

        OnGotTarget = function(self)
            DummyTurretWeapon.IdleState.OnGotTarget(self)
			self:ForkThread(function()
            self.targetbeam = CreateBeamEmitterOnEntity(self.unit, 'RailGun_Muzzle', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/railgun_beam_01_emit.bp')
			WaitSeconds(5)
			end)
        end,
    },

    ---@param self CAMZapperWeapon
    OnLostTarget = function(self)
        DummyTurretWeapon.OnLostTarget(self)
        self.targetbeam:Destroy()
    end,
		},
		Dummy = Class(DummyTurretWeapon) {},
		Beam = Class(TDFHeatBeam) {},
		HArtillery = Class(TIFMediumArtilleryStrike) {},
		HPreciArtillery = Class(TIFMediumArtilleryStrike) {},
		LAcidBarrage = Class(TIFMediumArtilleryStrike) {},
		RAcidBarrage = Class(TIFMediumArtilleryStrike) {},
		LSmokeBarrage = Class(TIFMediumArtilleryStrike) {},
		RSmokeBarrage = Class(TIFMediumArtilleryStrike) {},
		LEMPBarrage = Class(TIFMediumArtilleryStrike) {},
		REMPBarrage = Class(TIFMediumArtilleryStrike) {},
		LArtillery1 = Class(TIFMediumArtilleryStrike) {},
		LArtillery2 = Class(TIFMediumArtilleryStrike) {},
		GatlingCannon1 = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'L_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'L_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
		GatlingCannon2 = Class(TDFMachineGunWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'R_Gatling_Rotate', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'R_Gatling_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.Beam = self:GetWeaponByLabel('Beam')
		self.HArtillery = self:GetWeaponByLabel('HArtillery')
		self.HPreciArtillery = self:GetWeaponByLabel('HPreciArtillery')
		self.LArtillery1 = self:GetWeaponByLabel('LArtillery1')
		self.LArtillery2 = self:GetWeaponByLabel('LArtillery2')
		self.LAcidBarrage = self:GetWeaponByLabel('LAcidBarrage')
		self.RAcidBarrage = self:GetWeaponByLabel('RAcidBarrage')
		self.LEMPBarrage = self:GetWeaponByLabel('LEMPBarrage')
		self.REMPBarrage = self:GetWeaponByLabel('REMPBarrage')
		self.LSmokeBarrage = self:GetWeaponByLabel('LSmokeBarrage')
		self.RSmokeBarrage = self:GetWeaponByLabel('RSmokeBarrage')
		self.GatlingCannon1 = self:GetWeaponByLabel('GatlingCannon1')
		self.GatlingCannon2 = self:GetWeaponByLabel('GatlingCannon2')
		self.RailGun = self:GetWeaponByLabel('RailGun')
		self.Beam:SetEnabled(false)
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
	end,
	
	CreateEnhancement = function(self, enh)
        TAirUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		local wep = self:GetWeaponByLabel('MainGun')
        if enh == 'OrbitalHeavyArtilleryBarrage' then
		self.HArtillery:SetEnabled(true)
		self.HArtillery:ChangeProjectileBlueprint('/projectiles/TIFArtillery01/TIFArtillery01_proj.bp')
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
        elseif enh == 'OrbitalLaser' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(true)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalArtilleryBarrage' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(true)
		self.LArtillery2:SetEnabled(true)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalGatlingBarrage' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(true)
		self.GatlingCannon2:SetEnabled(true)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalRailGun' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(true)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalGasStrike' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(true)
		self.RAcidBarrage:SetEnabled(true)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalEMSStrike' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(true)
		self.REMPBarrage:SetEnabled(true)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalSmokeStrike' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(true)
		self.RSmokeBarrage:SetEnabled(true)
		elseif enh == 'OrbitalNapalmBarrage' then
		self.HArtillery:SetEnabled(true)
		self.HArtillery:ChangeProjectileBlueprint('/mods/mechdivers/projectiles/TIFNapalmShell01/TIFNapalmShell01_proj.bp')
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalPrecisionStrike' then
		self.HArtillery:SetEnabled(false)
		self.HPreciArtillery:SetEnabled(true)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
		elseif enh == 'OrbitalAirburstStrike' then
		self.HArtillery:SetEnabled(true)
		self.HArtillery:ChangeProjectileBlueprint('/mods/mechdivers/projectiles/TIFAirburstShell01/TIFAirburstShell01_proj.bp')
		self.HPreciArtillery:SetEnabled(false)
		self.Beam:SetEnabled(false)
		self.LArtillery1:SetEnabled(false)
		self.LArtillery2:SetEnabled(false)
		self.GatlingCannon1:SetEnabled(false)
		self.GatlingCannon2:SetEnabled(false)
		self.RailGun:SetEnabled(false)
		self.LAcidBarrage:SetEnabled(false)
		self.RAcidBarrage:SetEnabled(false)
		self.LEMPBarrage:SetEnabled(false)
		self.REMPBarrage:SetEnabled(false)
		self.LSmokeBarrage:SetEnabled(false)
		self.RSmokeBarrage:SetEnabled(false)
        end
    end,


}

TypeClass = CSKMDTA0400