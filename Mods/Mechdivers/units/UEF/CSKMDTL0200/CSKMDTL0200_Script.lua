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

CSKMDTL0200 = Class(TWalkingLandUnit) {

    Weapons = {
		L_Flamethrower = Class(TDFMachineGunWeapon) {},
		R_Flamethrower = Class(TDFMachineGunWeapon) {},
		Dummy = Class(DummyTurretWeapon) {},
    },  

	OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
		ForkThread( function()
		self:HideBone( 'L_MissileLauncher', true )
		self:HideBone( 'R_MissileLauncher', true )
		self:HideBone( 'L_MineLauncher', true )
		self:HideBone( 'R_MineLauncher', true )
		self:HideBone( 'L_Gatling_Arm', true )
		self:HideBone( 'R_Gatling_Arm', true )
		self:HideBone( 'L_FlameThrower', true )
		self:HideBone( 'R_FlameThrower', true )
		self:HideBone( 'L_Canister', true )
		self:HideBone( 'R_Canister', true )
		self:HideBone( 'L_MG1', true )
		self:HideBone( 'R_MG1', true )
		Dummy = self:GetWeaponByLabel('Dummy')
		self.L_Flamethrower = self:GetWeaponByLabel('L_Flamethrower')
		self.R_Flamethrower = self:GetWeaponByLabel('R_Flamethrower')

		self:ShowBone( 'L_FlameThrower', true )
		self:ShowBone( 'R_FlameThrower', true )
		self:ShowBone( 'L_Canister', true )
		self:ShowBone( 'R_Canister', true )
		self.FireEffect1 = CreateAttachedEmitter(self,'L_FlameThrower_Effect',self:GetArmy(), '/effects/emitters/op_ambient_fire_01_emit.bp'):ScaleEmitter(0.05)
		self.FireEffect2 = CreateAttachedEmitter(self,'R_FlameThrower_Effect',self:GetArmy(), '/effects/emitters/op_ambient_fire_01_emit.bp'):ScaleEmitter(0.05)
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
		self.unit:SetWeaponEnabledByLabel('MainGun', false)
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
		self:SetWeaponEnabledByLabel('MainGun', false)
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
			unit:SetWeaponEnabledByLabel('MainGun', false)
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
			self:ShowBone('Bot', true)
			self:SetWeaponEnabledByLabel('MainGun', true)
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
		self:AddCommandCap('RULEUCC_RetaliateToggle')
		self:AddCommandCap('RULEUCC_Guard')
		self:SetWeaponEnabledByLabel('MainGun', true)
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
			unit:SetWeaponEnabledByLabel('MainGun', true)
			unit:SetCollisionShape('Box', 0, 0,0, 0.6, 0.6, 0.6)
			unit:DetachFrom(true)
			unit:ShowBone(0, true)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:SetWeaponEnabledByLabel('MainGun', false)
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
			units[1]:SetWeaponEnabledByLabel('MainGun', true)
			units[1]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[1]:DetachFrom(true)
			units[1]:AddCommandCap('RULEUCC_Attack')
			units[1]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[1]:AddCommandCap('RULEUCC_Stop')
		end
    end,
	  
}
TypeClass = CSKMDTL0200