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
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TIFSmartCharge = import('/lua/terranweapons.lua').TIFSmartCharge
local EffectTemplate = import('/lua/EffectTemplates.lua')

CSKMDTL0204 = Class(TLandUnit) {

    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {},
		Torpedo01 = Class(TANTorpedoAngler) {},
        AntiTorpedo = Class(TIFSmartCharge) {},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0204/CSKMDTL0204_Door.sca', false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0204/CSKMDTL0204_Wheels.sca', false):SetRate(0)
		ChangeState(self, self.IdleState)
		local number = 0
		ForkThread(function()
			while true do
			if not self.Dead and self:GetCurrentLayer() == 'Land' then
			local units = self:GetCargo()
			if table.getn(units) >= 6 then
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
			else
			
			end
			WaitSeconds(0.1)
			end
		end)
    end,
	
		OnMotionHorzEventChange = function(self, new, old)
            TLandUnit.OnMotionHorzEventChange(self, new, old)
            if ( new == 'Stopped' ) then
			if self:GetCurrentLayer() == 'Water' then
			
			else
			self:AddToggleCap('RULEUTC_WeaponToggle')
			end
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
        if( old != 'None' ) then
            local myBlueprint = self:GetBlueprint()
            if( new == 'Land' ) then
                self.AnimationManipulator2:SetRate(-2)
            elseif( new == 'Water' ) then
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
                self.AnimationManipulator2:SetRate(1)
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
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
            for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 6 then
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
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)		
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
		local units = self:GetCargo()
		local position = self.Beacon:GetPosition()
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self.Beacon:GetOrientation())
			unit:ShowBone(0, true)
			unit:SetDoNotTarget(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:DetachFrom(true)
        end
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		end
    end,
	
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Beacon then
	self.Beacon:Destroy()
	end	
	
	
    TLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	OnReclaimed = function(self, reclaimer)
		if self.Beacon then
		self.Beacon:Destroy()
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
				if table.getn(units) >= 6 then
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

TypeClass = CSKMDTL0204