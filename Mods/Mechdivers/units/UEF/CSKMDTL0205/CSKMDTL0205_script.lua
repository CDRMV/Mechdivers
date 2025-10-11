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

CSKMDTL0205 = Class(TLandUnit) {

    Weapons = {
        MainGun = Class(TDFRiotWeapon) {
		FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		BotMesh = '/mods/Mechdivers/Decorations/T1Bot_mesh'
		self.Bot = import('/lua/sim/Entity.lua').Entity()
        self.Bot:AttachBoneTo( -1, self, 'Attachpoint' )
        self.Bot:SetMesh(BotMesh)
        self.Bot:SetDrawScale(0.0625)
        self.Bot:SetVizToAllies('Never')
        self.Bot:SetVizToNeutrals('Never')
        self.Bot:SetVizToEnemies('Never')
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:RemoveCommandCap('RULEUCC_Transport')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0205/CSKMDTL0205_Door.sca', false):SetRate(0)
		
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
	
	DeathThread = function( self, overkillRatio , instigator)  
		self.Bot:Destroy()
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 2 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		local Nanites = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
        self:PlayUnitSound('Destroyed')
        self:Destroy()
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
		self:AddToggleCap('RULEUTC_IntelToggle')
		elseif bit == 7 then 
		LOG('Test')
		self.load = true
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
        for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 1 then
			unit:AttachBoneTo(-2, self, 'Attachpoint')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
			unit:SetUnSelectable(true)
			unit:HideBone(0, true)
			unit:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			IssueClearCommands({unit})
			self.Bot:SetVizToAllies('Intel')
			self.Bot:SetVizToNeutrals('Intel')
			self.Bot:SetVizToEnemies('Intel')
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:SetWeaponEnabledByLabel('MainGun', true)
			number = number + 1
			else
			end
			else
            end
		end	
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)		
		elseif bit == 4 then
		self:SetSpeedMult(2)
		end
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		if bit == 1 then 
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.Beacon:Destroy()
		self.AnimationManipulator:SetRate(-1)
		elseif bit == 7 then
		self.load = false
		local units = self:GetCargo()
		local position = self:GetPosition()
		self.Bot:SetVizToAllies('Never')
		self.Bot:SetVizToNeutrals('Never')
		self.Bot:SetVizToEnemies('Never')
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			unit:ShowBone(0, true)
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			unit:DetachFrom(true)
			unit:AddCommandCap('RULEUCC_Attack')
			unit:AddCommandCap('RULEUCC_RetaliateToggle')
			unit:AddCommandCap('RULEUCC_Stop')
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:SetWeaponEnabledByLabel('MainGun', false)
        end	
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		elseif bit == 4 then
		self:SetSpeedMult(1)
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		local units = self:GetCargo()
		if units[2] == nil then
		
		else
		if self.Bot then
		self.Bot:Destroy()
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 2 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		local Bot = CreateUnitHPR('UEL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		else
		
		end
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

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	OnReclaimed = function(self, reclaimer)
		if self.Beacon then
		self.Beacon:Destroy()
		end
		
		local units = self:GetCargo()
		if units[2] == nil then
		
		else
		if self.Bot then
			self.Bot:Destroy()
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
	
}

TypeClass = CSKMDTL0205