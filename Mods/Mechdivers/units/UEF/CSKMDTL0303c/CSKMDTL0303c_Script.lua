#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKMDTL0303b = Class(TWalkingLandUnit) {

    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
                    DummyTurretWeapon.IdleState.Main(self)
                end,
                
        OnGotTarget = function(self)
			if self.unit:GetFireState() == 2 then
			local target = self:GetCurrentTarget()
			if target then
			
			else
			
			local targetposition = self:GetCurrentTargetPos()
			if targetposition then
			if self.unit.LArm and not self.unit.LArm.Dead then
			IssueClearCommands({self.unit.LArm})
			self.unit.LArm:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.LArm}, targetposition)
			end
			if self.unit.RArm and not self.unit.RArm.Dead then
			IssueClearCommands({self.unit.RArm})
			self.unit.RArm:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.RArm}, targetposition)
			end
			if self.unit.Turret and not self.unit.Turret.Dead then
			IssueClearCommands({self.unit.Turret})
			self.unit.Turret:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.Turret}, targetposition)
			end
			end
			end
			elseif self.unit:GetFireState() == 0 then
			if self.unit.LArm and not self.unit.LArm.Dead then
			IssueClearCommands({self.unit.LArm})
			end
			if self.unit.RArm and not self.unit.RArm.Dead then
			IssueClearCommands({self.unit.RArm})
			end
			if self.unit.Turret and not self.unit.Turret.Dead then
			IssueClearCommands({self.unit.Turret})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
			if self.unit:GetFireState() == 2 then
			local target = self:GetCurrentTarget()
			if target then
			
			else
			local targetposition = self:GetCurrentTargetPos()
			if targetposition then
			if self.unit.LArm and not self.unit.LArm.Dead then
			IssueClearCommands({self.unit.LArm})
			self.unit.LArm:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.LArm}, targetposition)
			end
			if self.unit.RArm and not self.unit.RArm.Dead then
			IssueClearCommands({self.unit.RArm})
			self.unit.RArm:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.RArm}, targetposition)
			end
			if self.unit.Turret and not self.unit.Turret.Dead then
			IssueClearCommands({self.unit.Turret})
			self.unit.Turret:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.Turret}, targetposition)
			end
			end
			end
			elseif self.unit:GetFireState() == 0 then
			if self.unit.LArm and not self.unit.LArm.Dead then
			IssueClearCommands({self.unit.LArm})
			end
			if self.unit.RArm and not self.unit.RArm.Dead then
			IssueClearCommands({self.unit.RArm})
			end
			if self.unit.Turret and not self.unit.Turret.Dead then
			IssueClearCommands({self.unit.Turret})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
			if self.unit.LArm and not self.unit.LArm.Dead then
			IssueClearCommands({self.unit.LArm})
			end
			if self.unit.RArm and not self.unit.RArm.Dead then
			IssueClearCommands({self.unit.RArm})
			end
			if self.unit.Turret and not self.unit.Turret.Dead then
			IssueClearCommands({self.unit.Turret})
			end
            DummyTurretWeapon.OnLostTarget(self)
        end,  	
		
		},	
    },  

	
	OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.build = true
		        self.HasLeftPod = false
        self.HasRightPod = false
		self.HasCenterPod = false
		if self:GetAIBrain().BrainType == 'Human' then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo(-2, self, 'Bot')
		self.unit:SetDoNotTarget(true)
		self.unit.CanTakeDamage = false
		self.unit.CanBeKilled = false
		self.unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
		self.unit:RemoveCommandCap('RULEUCC_Attack')
		self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.unit:RemoveCommandCap('RULEUCC_Stop')
		self.unit:SetCollisionShape('Box', 0, 0, 0, 0, 0 ,0)
		self.unit:HideBone(0, true)
		self.unit:SetUnSelectable(true)
		--self.unit:HideRifle()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:RemoveCommandCap('RULEUCC_Transport')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0303/CSKMDTL0303_Afold01.sca', false):SetRate(0)
		self.load = true
		self.fold = false
		self.LArm = nil
		self.RArm = nil
		self.Turret = nil
		
		local RandomNumber = math.random(1,2)
		
		if RandomNumber == 1 then

		self:CreateEnhancement('RightAutoCannon')
		self:CreateEnhancement('LeftAutoCannon')
		self:CreateEnhancement('GatlingTurret')
		elseif RandomNumber == 2 then

		self:CreateEnhancement('RightGatling')
		self:CreateEnhancement('LeftMissileLauncher')
		self:CreateEnhancement('AutocannonTurret')
		end
		
		else
		self:RemoveCommandCap('RULEUCC_Transport')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0303/CSKMDTL0303_Afold01.sca', false):SetRate(0)
		self.load = true
		self.fold = false
		self.LArm = nil
		self.RArm = nil
		self.Turret = nil
		
		local RandomNumber = math.random(1,2)
		
		if RandomNumber == 1 then

		self:CreateEnhancement('RightAutoCannon')
		self:CreateEnhancement('LeftAutoCannon')
		self:CreateEnhancement('GatlingTurret')
		elseif RandomNumber == 2 then

		self:CreateEnhancement('RightGatling')
		self:CreateEnhancement('LeftMissileLauncher')
		self:CreateEnhancement('AutocannonTurret')
		end
		end
    end,
	
	NotifyOfPodDeath = function(self, pod)
        if pod == 'LeftGatling' then
            self:CreateEnhancement('LeftGatlingRemove')
            self:CreateEnhancement('LeftEmpty')
            self:RequestRefreshUI()
        elseif pod == 'RightGatling' then
            self:CreateEnhancement('RightGatlingRemove')
            self:CreateEnhancement('RightEmpty')
            self:RequestRefreshUI()
        elseif pod == 'RightAutoCannon' then
            self:CreateEnhancement('RightAutoCannonRemove')
            self:CreateEnhancement('RightEmpty')
            self:RequestRefreshUI()
		elseif pod == 'LeftAutoCannon' then
            self:CreateEnhancement('LeftAutoCannonRemove')
            self:CreateEnhancement('LeftEmpty')
            self:RequestRefreshUI()
		elseif pod == 'LeftMissileLauncher' then
            self:CreateEnhancement('LeftMissileLauncherRemove')
            self:CreateEnhancement('LeftEmpty')
            self:RequestRefreshUI()
		elseif pod == 'RightMissileLauncher' then
            self:CreateEnhancement('RightMissileLauncherRemove')
            self:CreateEnhancement('RightEmpty')
            self:RequestRefreshUI()
		elseif pod == 'AutocannonTurret' then
            self:CreateEnhancement('AutocannonTurretRemove')
            self:CreateEnhancement('Empty')
            self:RequestRefreshUI()	
		elseif pod == 'GatlingTurret' then
            self:CreateEnhancement('GatlingTurretRemove')
            self:CreateEnhancement('Empty')
            self:RequestRefreshUI()	
        end
    end,
	
	CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'LeftGatling' then
		if self.LArm then
		self.LArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial02')
		self.LArm = CreateUnitHPR('L_Gatling', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.LArm:SetParent(self, 'LeftGatling')
        self.LArm:SetCreator(self)
		self.LArm:AttachBoneTo('Gatling_Attach', self, 'AttachSpecial02')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
        elseif enh == 'RightGatling' then
		if self.RArm then
		self.RArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial03')
		self.RArm = CreateUnitHPR('R_Gatling', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.RArm:SetParent(self, 'RightGatling')
        self.RArm:SetCreator(self)
		self.RArm:AttachBoneTo('Gatling_Attach', self, 'AttachSpecial03')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'RightAutoCannon' then
		if self.RArm then
		self.RArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial03')
		self.RArm = CreateUnitHPR('R_Autocannon', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.RArm:SetParent(self, 'RightAutoCannon')
        self.RArm:SetCreator(self)
		self.RArm:AttachBoneTo('Cannon_Attach', self, 'AttachSpecial03')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'LeftAutoCannon' then
		if self.LArm then
		self.LArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial02')
		self.LArm = CreateUnitHPR('L_Autocannon', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.LArm:SetParent(self, 'LeftAutoCannon')
        self.LArm:SetCreator(self)
		self.LArm:AttachBoneTo('Cannon_Attach', self, 'AttachSpecial02')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'LeftMissileLauncher' then
		if self.LArm then
		self.LArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial02')
		self.LArm = CreateUnitHPR('L_MissileLauncher', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.LArm:SetParent(self, 'LeftMissileLauncher')
        self.LArm:SetCreator(self)
		self.LArm:AttachBoneTo('MissileLauncher_Attach', self, 'AttachSpecial02')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'RightMissileLauncher' then
		if self.RArm then
		self.RArm:Destroy()
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('AttachSpecial03')
		self.RArm = CreateUnitHPR('R_MissileLauncher', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.RArm:SetParent(self, 'RightMissileLauncher')
        self.RArm:SetCreator(self)
		self.RArm:AttachBoneTo('MissileLauncher_Attach', self, 'AttachSpecial03')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'Empty' then
		if self.Turret then
		self.Turret:Destroy()
		end
		
		elseif enh == 'LeftEmpty' then
		if self.LArm then
		self.LArm:Destroy()
		end
		
		elseif enh == 'RightEmpty' then
		if self.RArm then
		self.RArm:Destroy()
		end
		
		elseif enh == 'AutocannonTurret' then
		if self.Turret then
		self.Turret:Destroy()
		end
		
		local position = self:GetPosition('AttachSpecial01')
		self.Turret = CreateUnitHPR('Autocannon', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.Turret:SetParent(self, 'AutocannonTurret')
        self.Turret:SetCreator(self)
		self.Turret:AttachBoneTo(0, self, 'AttachSpecial01')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		
		elseif enh == 'GatlingTurret' then
		if self.Turret then
		self.Turret:Destroy()
		end
		
		local position = self:GetPosition('AttachSpecial01')
		self.Turret = CreateUnitHPR('Gatling', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.Turret:SetParent(self, 'GatlingTurret')
        self.Turret:SetCreator(self)
		self.Turret:AttachBoneTo(0, self, 'AttachSpecial01')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.fold == true then
		
		elseif self.fold == false then
		if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end
		end

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
			unit.CanTakeDamage = false
			unit.CanBeKilled = false
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
			if unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			unit:DetachFrom(true)
			unit:AttachBoneTo(-2, self, 'Exit')
			WaitSeconds(1)
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			--unit:ShowRifle()
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit.CanTakeDamage = true
			unit.CanBeKilled = true
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

	
	local units = self:GetCargo()
	if units[1] == nil then
		
	else
	units[1]:Destroy()
	end
	
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
	SetIgnoreArmyUnitCap(self:GetArmy(), true)
	local position = self:GetPosition()
	local orientation = self:GetOrientation()
	local angle = 2 * math.acos(orientation[2])
	self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, angle, 0)
	self.unit.CanTakeDamage = false
	self.unit.CanBeKilled = false
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
	ForkThread(function()
	WaitSeconds(1)
		end)
	self.unit.CanTakeDamage = true
	self.unit.CanBeKilled = true
	end
	end	

				if self.Turret and not self.Turret.Dead then
		self.Turret:Destroy()
		end
				if self.LArm and not self.LArm.Dead then
		self.LArm:Destroy()
		end
				if self.RArm and not self.RArm.Dead then
		self.RArm:Destroy()
		end


    TWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,

	OnReclaimed = function(self, reclaimer)
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		if self.load == false then
		
		else
		local units = self:GetCargo()
		if units[1] == nil then
		
		else
			units[1]:ShowBone(0, true)
			units[1]:SetDoNotTarget(false)
			units[1]:SetUnSelectable(false)
			units[1].CanTakeDamage = true
			units[1].CanBeKilled = true
			units[1]:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			units[1]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[1]:DetachFrom(true)
			units[1]:AddCommandCap('RULEUCC_Attack')
			units[1]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[1]:AddCommandCap('RULEUCC_Stop')
		end
		end
		
		if self.Turret and not self.Turret.Dead then
		self.Turret:Destroy()
		end
		if self.LArm and not self.LArm.Dead then
		self.LArm:Destroy()
		end
		if self.RArm and not self.RArm.Dead then
		self.RArm:Destroy()
		end
    end,
	  
}
TypeClass = CSKMDTL0303b