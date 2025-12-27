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
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

CSKMDTL0300 = Class(TLandUnit) {

    Weapons = {
        LMG = Class(TDFRiotWeapon) {
		FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		RMG = Class(TDFRiotWeapon) {
		FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
		ACGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'AC_Muzzle' then
		CreateAttachedEmitter(self.unit, 'AC_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0300/CSKMDTL0300_Door.sca', false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0300/CSKMDTL0300_LMG_Unpack.sca', false):SetRate(0)
		if not self.AnimationManipulator3 then
            self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
        end
		self.AnimationManipulator3:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0300/CSKMDTL0300_RMG_Unpack.sca', false):SetRate(0)
		ChangeState(self, self.IdleState)
		local number = 0
		if self:GetAIBrain().BrainType == 'Human' then
			self.AnimationManipulator2:SetRate(-1)
			self.AnimationManipulator3:SetRate(-1)
			BotMesh = '/mods/Mechdivers/Decorations/T1Bot_mesh'
			self.Bot = import('/lua/sim/Entity.lua').Entity()
			self.Bot:AttachBoneTo( -1, self, 'L_MG_Attachpoint' )
			self.Bot:SetMesh(BotMesh)
			self.Bot:SetDrawScale(0.0625)
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2 = import('/lua/sim/Entity.lua').Entity()
			self.Bot2:AttachBoneTo( -1, self, 'R_MG_Attachpoint' )
			self.Bot2:SetMesh(BotMesh)
			self.Bot2:SetDrawScale(0.0625)
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			ForkThread(function()
			while true do
			if not self.Dead and self:GetCurrentLayer() == 'Land' then
			local units = self:GetCargo()
			if table.getn(units) >= 10 then
			if number == 0 then
			self:AddBuildRestriction(categories.BUILDBYAMMC)
			number = 1
			end
			else
			if number == 1 then
			self:RemoveBuildRestriction(categories.BUILDBYAMMC)
			number = 0
			end
			end
			if units[1] and units[2] then
			self.AnimationManipulator2:SetRate(1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(1)
			WaitFor(self.AnimationManipulator3)
			self.Bot:SetVizToAllies('Intel')
			self.Bot:SetVizToNeutrals('Intel')
			self.Bot:SetVizToEnemies('Intel')
			self.Bot2:SetVizToAllies('Intel')
			self.Bot2:SetVizToNeutrals('Intel')
			self.Bot2:SetVizToEnemies('Intel')
			self:SetWeaponEnabledByLabel('LMG', true)
			self:SetWeaponEnabledByLabel('RMG', true)
			elseif units[1] == nil and units[2] == nil then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator3)
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			elseif units[1] and units[2] == nil then
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(1)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			WaitFor(self.AnimationManipulator3)
			self.Bot:SetVizToAllies('Intel')
			self.Bot:SetVizToNeutrals('Intel')
			self.Bot:SetVizToEnemies('Intel')
			self:SetWeaponEnabledByLabel('LMG', true)
			self:SetWeaponEnabledByLabel('RMG', false)
			elseif units[1] == nil and units[2] then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			self.AnimationManipulator3:SetRate(1)
			WaitFor(self.AnimationManipulator2)
			WaitFor(self.AnimationManipulator3)
			self.Bot2:SetVizToAllies('Intel')
			self.Bot2:SetVizToNeutrals('Intel')
			self.Bot2:SetVizToEnemies('Intel')
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', true)
			end
			else
			
			end
			WaitSeconds(0.1)
			end
			end)
		elseif self:GetAIBrain().BrainType == 'AI' then
			self.AnimationManipulator2:SetRate(1)
			self.AnimationManipulator3:SetRate(1)
			BotMesh = '/mods/Mechdivers/Decorations/T1Bot_mesh'
			self.Bot = import('/lua/sim/Entity.lua').Entity()
			self.Bot:AttachBoneTo( -1, self, 'L_MG_Attachpoint' )
			self.Bot:SetMesh(BotMesh)
			self.Bot:SetDrawScale(0.0625)
			self.Bot:SetVizToAllies('Intel')
			self.Bot:SetVizToNeutrals('Intel')
			self.Bot:SetVizToEnemies('Intel')
			self.Bot2 = import('/lua/sim/Entity.lua').Entity()
			self.Bot2:AttachBoneTo( -1, self, 'R_MG_Attachpoint' )
			self.Bot2:SetMesh(BotMesh)
			self.Bot2:SetDrawScale(0.0625)
			self.Bot2:SetVizToAllies('Intel')
			self.Bot2:SetVizToNeutrals('Intel')
			self.Bot2:SetVizToEnemies('Intel')
			self:SetWeaponEnabledByLabel('LMG', true)
			self:SetWeaponEnabledByLabel('RMG', true)
        end	
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Beacon then
	self.Beacon:Destroy()
	end	
	
	if self.load == false then
	
	else
	if self.Bot and self.Bot2 then
	self.Bot:Destroy()
	self.Bot2:Destroy()
	end
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
	SetIgnoreArmyUnitCap(self:GetArmy(), true)
	local position = self:GetPosition()
	local orientation = self:GetOrientation()
	local angle = 2 * math.acos(orientation[2])
	self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, angle, 0)
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
	self.unit = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, angle, 0)
	SetIgnoreArmyUnitCap(self:GetArmy(), false)
	end
	end
	
	
    TLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	
	OnReclaimed = function(self, reclaimer)
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		local units = self:GetCargo()
		if units[1] == nil and units[2] == nil then
		
		else
		if self.Bot and self.Bot2 then
		self.Bot:Destroy()
		self.Bot2:Destroy()
			units[1]:ShowBone(0, true)
			units[1]:SetDoNotTarget(false)
			units[1]:SetUnSelectable(false)
			units[1]:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			units[1]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[1]:DetachFrom(true)
			units[1]:AddCommandCap('RULEUCC_Attack')
			units[1]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[1]:AddCommandCap('RULEUCC_Stop')
			units[2]:ShowBone(0, true)
			units[2]:SetDoNotTarget(false)
			units[2]:SetUnSelectable(false)
			units[2]:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			units[2]:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			units[2]:DetachFrom(true)
			units[2]:AddCommandCap('RULEUCC_Attack')
			units[2]:AddCommandCap('RULEUCC_RetaliateToggle')
			units[2]:AddCommandCap('RULEUCC_Stop')
		else
		
		end
		
		end
    end,
		
	OnMotionHorzEventChange = function(self, new, old)
            TLandUnit.OnMotionHorzEventChange(self, new, old)
            if ( new == 'Stopped' ) then
			self:AddToggleCap('RULEUTC_WeaponToggle')
            elseif ( old == 'Stopped' ) then
			if self:GetScriptBit('RULEUTC_WeaponToggle') == true then
			self:SetScriptBit('RULEUTC_WeaponToggle', false)
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			else
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			end
            end
        end,
		
	OnLayerChange = function(self, new, old)
		TLandUnit.OnLayerChange(self, new, old)
			ForkThread(function()
			if new == 'Land' then

			elseif new == 'Seabed' then
			local units = self:GetCargo()
			if units[1] and units[2] then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator3)
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			elseif units[1] == nil and units[2] == nil then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator3)
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			elseif units[1] and units[2] == nil then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator3)
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			elseif units[1] == nil and units[2] then
			self.Bot:SetVizToAllies('Never')
			self.Bot:SetVizToNeutrals('Never')
			self.Bot:SetVizToEnemies('Never')
			self.Bot2:SetVizToAllies('Never')
			self.Bot2:SetVizToNeutrals('Never')
			self.Bot2:SetVizToEnemies('Never')
			self.AnimationManipulator2:SetRate(-1)
			WaitFor(self.AnimationManipulator2)
			self.AnimationManipulator3:SetRate(-1)
			WaitFor(self.AnimationManipulator3)
			self:SetWeaponEnabledByLabel('LMG', false)
			self:SetWeaponEnabledByLabel('RMG', false)
			end
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			end
			end)
	end,
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('BeaconPos')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddToggleCap('RULEUTC_ShieldToggle')
		self:SetScriptBit('RULEUTC_ShieldToggle', true)
		LOG(self:GetScriptBit(7))
		elseif bit == 7 then
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
            for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 10 then
			unit:AttachBoneTo(-2, self, 'MM_Attachpoint')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
			IssueClearCommands({unit})
			number = number + 1
			else
			end
			else
            end
			end
		elseif bit == 0 then
		self.Beacon:ShowBone(0, true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_ShieldToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.Beacon:Destroy()
		self.AnimationManipulator:SetRate(-1)
		elseif bit == 7 then
		local units = self:GetCargo()
		local position = self.Beacon:GetPosition()
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self.Beacon:GetOrientation())
			unit:ShowBone(0, true)
			unit:SetDoNotTarget(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:DetachFrom(true)
        end
		elseif bit == 0 then
		self.Beacon:HideBone(0, true)
        end
    end,
	
	
    BuildAttachBone = 'Build_Attachpoint',

    OnFailedToBuild = function(self)
        TLandUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            TLandUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
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
            TLandUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.FinishedBuildingState)
        end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
            unitBuilding:DetachFrom(true)
			self:SetScriptBit('RULEUTC_SpecialToggle', true)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() then
                self:AddUnitToStorage(unitBuilding)
				local units = self:GetCargo()
				if table.getn(units) >= 10 then
					self:AddBuildRestriction(categories.BUILDBYAMMC)
				end
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
	
}

TypeClass = CSKMDTL0300