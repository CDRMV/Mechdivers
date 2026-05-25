#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0302/UEA0302_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
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
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCA0400/CSKMDCA0400_AOpen.sca', false):SetRate(0)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
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
    end,
	
	OnScriptBitSet = function(self, bit)
        CAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(1)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		elseif bit == 7 then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.SpawnDroneThreadLVL0Handle = self:ForkThread(self.SpawnDroneThreadLVL0)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.AnimationManipulator:SetRate(-1)
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		elseif bit == 7 then
		KillThread(self.self.SpawnDroneThreadLVL0)
		ForkThread(function()	
		local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
		local Elevation = 10
		while not self.Dead do
			if self.Drone and not self.Drone:IsDead() then
			if Elevation == 230 and GetDistanceBetweenTwoEntities(self.Drone, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone, self) <= 8 or GetDistanceBetweenTwoEntities(self.Drone, self) < 0 then
			self.Drone:Destroy()
			self.Drone:DestroyScan()
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if Elevation == 230 and GetDistanceBetweenTwoEntities(self.Drone2, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone2, self) <= 8 or GetDistanceBetweenTwoEntities(self.Drone2, self) < 0 then
			self.Drone2:Destroy()
			self.Drone2:DestroyScan()
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if Elevation == 230 and GetDistanceBetweenTwoEntities(self.Drone3, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone3, self) <= 8 or GetDistanceBetweenTwoEntities(self.Drone3, self) < 0 then
			self.Drone3:Destroy()
			self.Drone3:DestroyScan()
			else

			end
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			if Elevation == 230 and GetDistanceBetweenTwoEntities(self.Drone4, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone4, self) <= 8 or GetDistanceBetweenTwoEntities(self.Drone4, self) < 0 then
			self.Drone4:Destroy()
			self.Drone4:DestroyScan()
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() then
			self.Drone:SetFireState(1)
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, self.attachposition)
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			self.Drone2:SetFireState(1)
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, self.attachposition)
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			self.Drone3:SetFireState(1)
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, self.attachposition)
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			self.Drone4:SetFireState(1)
			IssueClearCommands({self.Drone4})
			IssueMove({self.Drone4}, self.attachposition)
			end
		if Elevation == 230 then
		if self.Drone and not self.Drone:IsDead() then
		self.Drone:SetElevation(230)
		end
		if self.Drone2 and not self.Drone2:IsDead() then
		self.Drone2:SetElevation(230)
		end
		if self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:SetElevation(230)
		end
		if self.Drone4 and not self.Drone4:IsDead() then
		self.Drone4:SetElevation(230)
		end
		else
		Elevation = Elevation + 10
		if self.Drone and not self.Drone:IsDead() then
		self.Drone:SetElevation(Elevation)
		end
		if self.Drone2 and not self.Drone2:IsDead() then
		self.Drone2:SetElevation(Elevation)
		end
		if self.Drone3 and not self.Drone3:IsDead() then
		self.Drone3:SetElevation(Elevation)
		end
		if self.Drone4 and not self.Drone4:IsDead() then
		self.Drone4:SetElevation(Elevation)
		end
		end
		WaitSeconds(1)
		end
		end)
		self:AddToggleCap('RULEUTC_WeaponToggle')
        end
    end,
	
	SpawnDroneThreadLVL0 = function(self)
		local army = self:GetArmy()
		local aiBrain = self:GetAIBrain()
		local position = nil
		self.attachposition = nil
		local number = 0
		local movenumber = 0
		local stoporder = 0
		local idledrones = 0
		local reload = 0
		local build = 0
		local units1 = nil
		local units2 = nil
		local units3 = nil
		local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
 		while not self:IsDead() do
		self.attachposition = self:GetPosition('LaunchPoint01')
		position = self:GetPosition()
			if reload == 0 then
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone, self) <= 8 or self.Drone:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone, self) < 0 then
			self.Drone:Destroy()
			self.Drone:DestroyScan()
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone2, self) <= 8 or self.Drone2:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 0 then
			self.Drone2:Destroy()
			self.Drone2:DestroyScan()
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone3, self) <= 8 or self.Drone3:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 0 then
			self.Drone3:Destroy()
			self.Drone3:DestroyScan()
			else

			end
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			if self.Drone4:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone4, self) >= 0 and GetDistanceBetweenTwoEntities(self.Drone4, self) <= 8 or self.Drone4:GetFuelRatio() == 0.0 and GetDistanceBetweenTwoEntities(self.Drone4, self) < 0 then
			self.Drone4:Destroy()
			self.Drone4:DestroyScan()
			else

			end
			end
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 0.0 then
			self.Drone:SetSpeedMult(2)
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 0.0 then
			self.Drone2:SetSpeedMult(2)
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 0.0 then
			self.Drone3:SetSpeedMult(2)
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			else

			end
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			if self.Drone4:GetFuelRatio() == 0.0 then
			self.Drone4:SetSpeedMult(2)
			IssueClearCommands({self.Drone4})
			IssueMove({self.Drone4}, position)
			else

			end
			end
			
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone, self) >= 125 then
			IssueClearCommands({self.Drone})
			IssueMove({self.Drone}, position)
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) >= 125 then
			IssueClearCommands({self.Drone2})
			IssueMove({self.Drone2}, position)
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) >= 125 then
			IssueClearCommands({self.Drone3})
			IssueMove({self.Drone3}, position)
			else

			end
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			if self.Drone4:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone4, self) >= 125 then
			IssueClearCommands({self.Drone4})
			IssueMove({self.Drone4}, position)
			else

			end
			end
			
			if self.Drone and not self.Drone:IsDead() then
			if self.Drone:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone, self) < 110 then
			IssueClearCommands({self.Drone})
			IssueGuard({self.Drone}, self)
			else

			end
			end
			if self.Drone2 and not self.Drone2:IsDead() then
			if self.Drone2:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone2, self) < 110 then
			IssueClearCommands({self.Drone2})
			IssueGuard({self.Drone2}, self)
			else

			end
			end
			if self.Drone3 and not self.Drone3:IsDead() then
			if self.Drone3:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone3, self) < 110 then
			IssueClearCommands({self.Drone3})
			IssueGuard({self.Drone3}, self)
			else

			end
			end
			if self.Drone4 and not self.Drone4:IsDead() then
			if self.Drone4:GetFuelRatio() == 1.0 and GetDistanceBetweenTwoEntities(self.Drone4, self) < 110 then
			IssueClearCommands({self.Drone4})
			IssueGuard({self.Drone4}, self)
			else

			end
			end
			
			if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
			
			elseif self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
			number = 0
			end
			if number == 0 and self:GetScriptBit('RULEUTC_ProductionToggle') == false then
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE - categories.AIR, unitPos, 120, 'Enemy')
			if units[1] == nil and units[2] == nil then

			else
			if build == 0 then
			WaitSeconds(1)
			build = 1
			else
			WaitSeconds(5)
			end
			if aiBrain:GetEconomyStored("MASS") < 1000 and aiBrain:GetEconomyStored("ENERGY") < 18000 then
			elseif aiBrain:GetEconomyStored("MASS") < 1000 and aiBrain:GetEconomyStored("ENERGY") > 18000 then
			elseif aiBrain:GetEconomyStored("MASS") > 1000 and aiBrain:GetEconomyStored("ENERGY") < 18000 then
			elseif aiBrain:GetEconomyStored("MASS") >= 1000 and aiBrain:GetEconomyStored("ENERGY") >= 18000 then
			if self.Drone and self.Drone2 and self.Drone3 and self.Drone4 then
			table.empty(self.Drone) 
			table.empty(self.Drone2) 
			table.empty(self.Drone3) 
			table.empty(self.Drone4)
			end
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone = CreateUnitHPR('CSKMDCA0300b', self:GetArmy(), self.attachposition.x, self.attachposition.y, self.attachposition.z, 0, 0, 0)
			self.Drone:SetFireState(1)
			self.Drone:DetachFrom(true)
			self.Drone:Scan()
			IssueGuard({self.Drone}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 1
			end
			if number == 1 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone2 = CreateUnitHPR('CSKMDCA0300b', self:GetArmy(), self.attachposition.x, self.attachposition.y, self.attachposition.z, 0, 0, 0)
			self.Drone2:SetFireState(1)
			self.Drone2:DetachFrom(true)
			self.Drone2:Scan()
			IssueGuard({self.Drone2}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 2
			end
			if number == 2 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone3 = CreateUnitHPR('CSKMDCA0300b', self:GetArmy(), self.attachposition.x, self.attachposition.y, self.attachposition.z, 0, 0, 0)
			self.Drone3:SetFireState(1)
			self.Drone3:DetachFrom(true)
			self.Drone3:Scan()
			IssueGuard({self.Drone3}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 3	
			end	
			if number == 3 then
			WaitSeconds(1)
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			self.Drone4 = CreateUnitHPR('CSKMDCA0300b', self:GetArmy(), self.attachposition.x, self.attachposition.y, self.attachposition.z, 0, 0, 0)
			self.Drone4:SetFireState(1)
			self.Drone4:DetachFrom(true)
			self.Drone4:Scan()
			IssueGuard({self.Drone4}, self)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			number = 4	
			end				
			end
			end
            WaitSeconds(0.1)
			else
			reload = reload - 1
			if reload == 0 then
			number = 0
			movenumber = 0
			end
			end
			WaitSeconds(0.1)
		end	
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone2:Kill()
		self.Drone3:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
		self.Drone:Kill()
		self.Drone4:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
		self.Drone2:Kill()
		self.Drone4:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
		self.Drone3:Kill()
		self.Drone4:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone2:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and self.Drone4:IsDead() then
		self.Drone3:Kill()
	end
	
	if self.Drone and self.Drone:IsDead() and self.Drone2 and self.Drone2:IsDead() and self.Drone3 and self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
		self.Drone4:Kill()
	end
	
	if self.Drone and not self.Drone:IsDead() and self.Drone2 and not self.Drone2:IsDead() and self.Drone3 and not self.Drone3:IsDead() and self.Drone4 and not self.Drone4:IsDead() then
		self.Drone:Kill()
		self.Drone2:Kill()
		self.Drone3:Kill()
		self.Drone4:Kill()
	end
	
	    CAirUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	CreateEnhancement = function(self, enh)
        CAirUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		local wep = self:GetWeaponByLabel('MainGun')
        if enh == 'OrbitalHeavyFusionLaserBarrage' then
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