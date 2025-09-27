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
			if self:GetCurrentLayer() == 'Land' then
			local units = self:GetCargo()
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
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Beacon then
		self.Beacon:Destroy()
		end
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		if self.Bot and self.Bot2 then
		self.Bot:Destroy()
		self.Bot2:Destroy()
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 2 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		local Bot = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		local Bot2 = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		else
		
		end
        self:PlayUnitSound('Destroyed')
        self:Destroy()
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
			unit:SetDoNotTarget(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:DetachFrom(true)
        end
		elseif bit == 0 then
		self.Beacon:HideBone(0, true)
        end
    end,
	
}

TypeClass = CSKMDTL0300