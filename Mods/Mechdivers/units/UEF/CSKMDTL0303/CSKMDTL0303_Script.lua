#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKMDTL0303 = Class(TWalkingLandUnit) {

    Weapons = {
        L_MissileLauncher = Class(TSAMLauncher) {},
		R_MissileLauncher = Class(TSAMLauncher) {},
		Dummy = Class(DummyTurretWeapon) {},
		R_Cannon = Class(TDFGaussCannonWeapon) {

		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'R_Cannon_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell01', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'R_Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell02', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
		L_Cannon = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Cannon_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'L_Cannon_Shell01', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'L_Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'L_Cannon_Shell02', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
		R_GatlingCannon = Class(TDFMachineGunWeapon) 
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
		L_GatlingCannon = Class(TDFMachineGunWeapon) 
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
    },  

	OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
		ForkThread( function()
		self:HideBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:HideBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_Cannon_Arm', true )
		self:HideBone( 'R_Cannon_Arm', true )
		self:HideBone( 'L_LaserCannon', true )
		self:HideBone( 'R_LaserCannon', true )
		Dummy = self:GetWeaponByLabel('Dummy')
		self.R_Cannon = self:GetWeaponByLabel('R_Cannon')
		self.L_Cannon = self:GetWeaponByLabel('L_Cannon')
		self.L_GatlingCannon = self:GetWeaponByLabel('L_GatlingCannon')
		self.R_GatlingCannon = self:GetWeaponByLabel('R_GatlingCannon')
		self.L_MissileLauncher = self:GetWeaponByLabel('L_MissileLauncher')
		self.R_MissileLauncher = self:GetWeaponByLabel('R_MissileLauncher')

		local RandomNumber = 1
		
		if RandomNumber == 1 then
		self:HideBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:HideBone( 'R_Gatling_Arm', true )
		self:ShowBone( 'L_Cannon_Arm', true )
		self:ShowBone( 'R_Cannon_Arm', true )
		Dummy:SetEnabled(true)
		self:CreateEnhancement('RightAutoCannon')
		self:CreateEnhancement('LeftAutoCannon')
		elseif RandomNumber == 2 then
		self:ShowBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:ShowBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_Cannon_Arm', true )
		self:HideBone( 'R_Cannon_Arm', true )
		Dummy:SetEnabled(true)
		self:CreateEnhancement('RightGatling')
		self:CreateEnhancement('LeftMissileLauncher')
		end
		end
		)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.build = true
		if self:GetAIBrain().BrainType == 'Human' then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo(-2, self, 'Bot')
		self.unit:SetDoNotTarget(true)
		self.unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
		self.unit:RemoveCommandCap('RULEUCC_Attack')
		self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.unit:RemoveCommandCap('RULEUCC_Stop')
		self.unit:SetCollisionShape('Box', 0, 0, 0, 0, 0 ,0)
		self.unit:HideBone(0, true)
		self.unit:SetUnSelectable(true)
		--self.unit:HideRifle()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		self:RemoveCommandCap('RULEUCC_Transport')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0303/CSKMDTL0303_Afold01.sca', false):SetRate(0)
		self.load = true
		self.fold = false
    end,
	
	CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'LeftGatling' then
		self.L_Cannon:SetEnabled(false)
		self.L_GatlingCannon:SetEnabled(true)
		self.L_MissileLauncher:SetEnabled(false)
		
        elseif enh == 'RightGatling' then
		self.R_Cannon:SetEnabled(false)
		self.R_GatlingCannon:SetEnabled(true)
		self.R_MissileLauncher:SetEnabled(false)
		
		elseif enh == 'RightAutoCannon' then
		self.R_Cannon:SetEnabled(true)
		self.R_GatlingCannon:SetEnabled(false)
		self.R_MissileLauncher:SetEnabled(false)
		
		elseif enh == 'LeftAutoCannon' then
		self.L_Cannon:SetEnabled(true)
		self.L_GatlingCannon:SetEnabled(false)
		self.L_MissileLauncher:SetEnabled(false)
		
		elseif enh == 'LeftMissileLauncher' then
		self.L_Cannon:SetEnabled(false)
		self.L_GatlingCannon:SetEnabled(false)
		self.L_MissileLauncher:SetEnabled(true)
		
		elseif enh == 'RightMissileLauncher' then
		self.R_Cannon:SetEnabled(false)
		self.R_GatlingCannon:SetEnabled(false)
		self.R_MissileLauncher:SetEnabled(true)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.fold == true then
		
		elseif self.fold == false then
		if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end
		end
		local army = self:GetArmy()
		CreateAttachedEmitter(self, 'L_Gatling_Arm', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'L_Gatling_Arm', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'L_Gatling_Arm', 1.0)
		explosion.CreateFlash( self, 'L_Gatling_Arm', 1.0, army )
		self:HideBone("L_Cannon_Arm", true)
		self:HideBone("L_Gatling_Arm", true)
		self:HideBone("L_MissileLauncher", true)
		CreateAttachedEmitter(self, 'R_Gatling_Arm', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'R_Gatling_Arm', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'R_Gatling_Arm', 1.0)
		explosion.CreateFlash( self, 'R_Gatling_Arm', 1.0, army )
		self:HideBone("R_Cannon_Arm", true)
		self:HideBone("R_Gatling_Arm", true)
		self:HideBone("R_MissileLauncher", true)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

    
        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	OnScriptBitSet = function(self, bit)
        TWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
		if bit == 1 then 
		self:RemoveCommandCap('RULEUCC_Move')
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_Patrol')
		self:RemoveCommandCap('RULEUCC_Stop')
		self:SetFireState(1)
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self:RemoveCommandCap('RULEUCC_Guard')
		self:SetImmobile(true)
		self.AnimationManipulator:SetRate(1)
		WaitFor(self.AnimationManipulator)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_IntelToggle')
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self.fold = true
		elseif bit == 7 then
		if self.build == true then
		self:SetScriptBit('RULEUTC_SpecialToggle', false)
		self.build = false
		else
		self.load = true
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
            for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 1 then
			unit:AttachBoneTo(-2, self, 'Exit')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			unit:SetUnSelectable(true)
			unit:HideBone(0, true)
			WaitSeconds(1)
			unit:DetachFrom(true)
			unit:AttachBoneTo(-2, self, 'Bot')
			--unit:HideRifle()
			unit:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
			IssueClearCommands({unit})
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
			--self:RemoveToggleCap('RULEUTC_SpecialToggle')
			self:AddToggleCap('RULEUTC_WeaponToggle')
			self:SetDoNotTarget(false)
			number = number + 1
			else
			end
			else
            end
			end	
		end	
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
        end	
		end)
    end,

    OnScriptBitClear = function(self, bit)
        TWalkingLandUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
		if bit == 1 then 
		self.Beacon:Destroy()
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator:SetRate(-1)
		WaitFor(self.AnimationManipulator)
		self:SetImmobile(false)
		self:AddCommandCap('RULEUCC_Move')
		self:AddCommandCap('RULEUCC_Attack')
		self:AddCommandCap('RULEUCC_Patrol')
		self:AddCommandCap('RULEUCC_Stop')
		self:SetFireState(0)
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:AddCommandCap('RULEUCC_Guard')
		self.fold = false
		elseif bit == 7 then
		self.load = false
		local units = self:GetCargo()
		local position = self:GetPosition()
		self:HideBone('Bot', true)
        for _, unit in units do
			unit:DetachFrom(true)
			unit:AttachBoneTo(-2, self, 'Exit')
			WaitSeconds(1)
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			--unit:ShowRifle()
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:AddCommandCap('RULEUCC_Attack')
			unit:AddCommandCap('RULEUCC_RetaliateToggle')
			unit:AddCommandCap('RULEUCC_Stop')
			unit:SetCollisionShape('Box', 0, 0,0, 0.6, 0.6, 0.6)
			unit:DetachFrom(true)
			unit:ShowBone(0, true)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:SetDoNotTarget(true)
        end
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		end
		end)
    end,
	
	OnTransportDetach = function(self, attachBone, unit)
    TWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        unit:AttachBoneTo(-2, self, 'Bot')
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Beacon then
	self.Beacon:Destroy()
	end	
	
	if self.load == false then
	
	else
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
	SetIgnoreArmyUnitCap(self:GetArmy(), true)
	local position = self:GetPosition()
	local orientation = self:GetOrientation()
	local angle = 2 * math.acos(orientation[2])
	self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, angle, 0)
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
	end
	end

    TWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,

	OnReclaimed = function(self, reclaimer)
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		local units = self:GetCargo()
		if units[1] == nil then
		
		else
			units[1]:ShowBone(0, true)
			units[1]:SetDoNotTarget(false)
			units[1]:SetUnSelectable(false)
			units[1]:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			units[1]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[1]:DetachFrom(true)
			units[1]:AddCommandCap('RULEUCC_Attack')
			units[1]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[1]:AddCommandCap('RULEUCC_Stop')
		end
    end,
	  
}
TypeClass = CSKMDTL0303