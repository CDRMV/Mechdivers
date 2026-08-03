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
local TMobileKamikazeBombWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').TMobileKamikazeBombWeapon
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
		Suicide = Class(TMobileKamikazeBombWeapon) {   
     
			OnFire = function(self)			
				self.unit:Kill()
				TMobileKamikazeBombWeapon.OnFire(self)
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
		if not self.Pump then
            self.Pump = CreateSlider(self, 'Drill_Pump')
            self.Trash:Add(self.Pump)
        end
		Spinner = CreateRotator(self, 'Drill_Head', 'z', nil, 0, 60, 360):SetTargetSpeed(0)
		self:HideBone('Center_Tank_Green', false)
		self:HideBone('L_Tank_Green', false)
		self:HideBone('R_Tank_Green', false)
		self.MaxEnergyStorage = 3000
		self.EnergyStorage = 0
		self.MaxMassStorage = 3000
		self.MassStorage = 0
		self.EnabledPump = false
		self.SuicideMode = false
    end,
	
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)	
		ForkThread( function()
		if bit == 1 then 
		if self.EnergyStorage >= self.MaxEnergyStorage and self.MassStorage >= self.MaxMassStorage then
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:SetImmobile(false)
		else
		self:SetImmobile(true)
		self.AnimationManipulator1:SetRate(0.15)
		WaitFor(self.AnimationManipulator1)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		end
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
		self.ExtractRessourcesThreadHandle = self:ForkThread(self.ExtractRessourcesThread)
		self.EnabledPump = true
		while true do
            if not self.Pump or self.EnabledPump == false then return end
            self.Pump:SetGoal(0, 0, -28)
            self.Pump:SetSpeed(10)
            WaitFor(self.Pump)
            self.Pump:SetGoal(0, 0, 0)
            WaitFor(self.Pump)
        end
		elseif bit == 3 then
		if self.SuicideMode == true then
		self.SuicideMode = false
		KillThread(self.AutomaticDetonationThreadHandle)
		elseif self.SuicideMode == false then
		self.SuicideMode = true
		self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
		end
		end
		end)
	end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread( function()
		if bit == 1 then 
		if self.EnergyStorage >= self.MaxEnergyStorage and self.MassStorage >= self.MaxMassStorage then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		end
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator1:SetRate(-0.15)
		WaitFor(self.AnimationManipulator1)
		self:SetImmobile(false)
		elseif bit == 7 then
		Spinner:SetSpinDown(true)
		Spinner:SetTargetSpeed(0)
		self.EnabledPump = false
		self.Pump:SetGoal(0, 0, 0)
        self.Pump:SetSpeed(10)
		KillThread(self.ExtractRessourcesThreadHandle)
		self:SetProductionPerSecondEnergy(0)
		self:SetProductionPerSecondMass(0)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self.AnimationManipulator2:SetRate(-0.3)
		WaitFor(self.AnimationManipulator2)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		if self.EnergyStorage >= self.MaxEnergyStorage and self.MassStorage >= self.MaxMassStorage then
		self:SetScriptBit('RULEUTC_WeaponToggle', false)	
		end
		elseif bit == 3 then
		end
		end)
    end,
	
	ExtractRessourcesThread = function(self)
			local wep = self:GetWeaponByLabel('Suicide')
			local wepDamage = 10000
			if self.EnergyStorage < self.MaxEnergyStorage and self.MassStorage < self.MaxMassStorage then
			
			elseif self.EnergyStorage >= self.MaxEnergyStorage and self.MassStorage >= self.MaxMassStorage then
			self.EnergyStorage = 0
			self.MassStorage = 0
			end
	        self:SetProductionPerSecondEnergy(10)
			self:SetProductionPerSecondMass(10)
			local number = 0
			while not self:IsDead() do
			if self.EnergyStorage == 1000 and self.MassStorage == 1000 then
			-- Suicide Weapon will causes Damage of 20000 Damage
			self:HideBone('L_Tank_Red', false)
			self:ShowBone('L_Tank_Green', false)
			self:AddToggleCap('RULEUTC_IntelToggle')
			end
			if self.EnergyStorage == 2000 and self.MassStorage == 2000 then
			-- Suicide Weapon will causes Damage of 40000 Damage
			self:HideBone('Center_Tank_Red', false)
			self:ShowBone('Center_Tank_Green', false)
			end
			if self.EnergyStorage == 3000 and self.MassStorage == 3000 then
			-- Suicide Weapon will causes Damage of 60000 Damage
			self:HideBone('R_Tank_Red', false)
			self:ShowBone('R_Tank_Green', false)
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
			end
			self.EnergyStorage = self.EnergyStorage + 10
			self.MassStorage = self.MassStorage + 10
			wepDamage = wepDamage + 20
			wep:ChangeDamage(wepDamage) -- Increase Damage of the Suicide Weapon with 20 per 1 Second Interval 
			WaitSeconds(1)
			end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		
		if self.EnergyStorage > 0 and self.MassStorage > 0 then
		local position = self:GetPosition()
		DamageArea(self, position, 20, 1, 'Force', true)
		DamageArea(self, position, 20, 1, 'Force', true)
		local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, position, 20, 'Enemy')
        for _,unit in units do
			Damage(self, position, unit, 25000, 'Fire')
        end
		local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(45.75,45.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
		nukeProjectile = self:CreateProjectile('/mods/Mechdivers/effects/Entities/Blu4000/Blu4000EffectController01/Blu4000EffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
		self:HideBone('L_Tank',true)
		self:HideBone('Center_Tank',true)
		self:HideBone('R_Tank',true)
        nukeProjectile:PassDamageData(self.DamageData)
        nukeProjectile:PassData(self.Data)
		end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	AutomaticDetonationThread = function(self)
		while not self:IsDead() do
			local unitPos = self:GetPosition()
            #Get Enemy units in the area
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 2, 'Enemy')
            for _,unit in units do
				self:GetWeaponByLabel'Suicide':FireWeapon()
				self:Kill()
            end
            
            #Wait 2 seconds
            WaitSeconds(2)
		end	
    end,

}

TypeClass = CSKMDTL0309