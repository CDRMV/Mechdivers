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

CSKMDTL0312 = Class(TLandUnit) {

    Weapons = {
		LACGun = Class(TDFGaussCannonWeapon) {
		--[[
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'L_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		]]--
		},
		RACGun = Class(TDFGaussCannonWeapon) {
		--[[
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'R_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'R_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		]]--
		},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		if not self.AnimationManipulator1 then
            self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_ADeploy.sca', false):SetRate(0)
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
		self.Mech = nil
		self.BuildProgress = false
		self.Unit = nil
		self.CenterUpgrade = nil
		self.RightUpgrade = nil
		self.LeftUpgrade = nil
		self:CreateEnhancement('MMFacLeftEmpty')
		self:CreateEnhancement('MMFacEmpty')
		self:CreateEnhancement('MMFacLTurretEmpty')
		self:CreateEnhancement('MMFacRTurretEmpty')
		self:CreateEnhancement('MMFacRightEmpty')
		self:CreateEnhancement('MMDefaultSkin')
    end,
	
	
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)	
		ForkThread( function()
		if bit == 1 then 
		self:SetImmobile(true)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		if self.Mech then
		
		else
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('Mech_Crane_Attach')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:AddToggleCap('RULEUTC_IntelToggle')
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
		elseif bit == 4 then 
		self.RemoveandInstallModulesThreadHandle = self:ForkThread(self.RemoveandInstallModulesThread)
		self:SetScriptBit('RULEUTC_ProductionToggle', false)
		elseif bit == 7 then 
		local position = self.Beacon:GetPosition()
		local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.MODULARMECH + categories.TECH3, position, 10, 'Ally')
		local number = 0
		local Mech = nil
        for _,unit in units do
			if unit:IsUnitState('WaitForFerry') then
			if number < 1 then
			unit:AttachBoneTo('AttachPoint', self, 'Mech_Crane_Attach')
			unit:SetDoNotTarget(true)
			unit:SetUnSelectable(true)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			IssueClearCommands({unit})
			self.Mech = unit
			number = number + 1
			else
			end
			else
            end
		end
		if self.Beacon then
		self.Beacon:Destroy()
		end
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		local RandomNumber = math.random(1, 2)
		if RandomNumber == 1 then
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_LCrane.sca', false)
		else
		self.AnimationManipulator2:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0312/CSKMDTL0312_RCrane.sca', false)
		end
		self.AnimationManipulator2:SetRate(0.2)
		WaitFor(self.AnimationManipulator2)
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:AttachBoneTo(-2, self, 'Mech_Attachpoint')
		self:AddToggleCap('RULEUTC_ProductionToggle')
		end
		end
		end)
	end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread( function()
		if bit == 1 then 
		if self.Beacon then
		self.Beacon:Destroy()
		end
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.AnimationManipulator1:SetRate(-1)
		WaitFor(self.AnimationManipulator1)
		self:SetImmobile(false)
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		elseif bit == 4 then 
		
		elseif bit == 7 then 
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:AttachBoneTo('AttachPoint', self, 'Mech_Crane_Attach')
		end
		self.AnimationManipulator2:SetRate(-0.2)
		WaitFor(self.AnimationManipulator2)
		if self.Mech then
		self.Mech:DetachFrom(true)
		self.Mech:SetDoNotTarget(false)
		self.Mech:SetUnSelectable(false)
		self.Mech:AddCommandCap('RULEUCC_Attack')
		self.Mech:AddCommandCap('RULEUCC_RetaliateToggle')
		self.Mech:AddCommandCap('RULEUCC_Stop')
		local Position = self.Mech:GetPosition()
		IssueMove({self.Mech}, {Position[1], Position[2], Position[3] - 2})
		self.Mech = nil
		self.Unit = nil
		end
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition('Mech_Crane_Attach')
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		end
		end)
    end,
	
	RemoveandInstallModulesThread = function(self)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.BuildProgress = true
		self.Unit = self.Mech
		if self.Unit == nil then
		
		else
		self.Unit:RemoveCommandCap('RULEUCC_Move')
		self.Unit:RemoveCommandCap('RULEUCC_Attack')
		self.Unit:RemoveCommandCap('RULEUCC_Patrol')
		self.Unit:RemoveCommandCap('RULEUCC_Guard')
		self.Unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.Unit:RemoveCommandCap('RULEUCC_Stop')
		self.Unit:CreateEnhancement('ModularLeftEmpty')
		self.Unit:CreateEnhancement('ModularLTurretEmpty')
		self.Unit:CreateEnhancement('ModularEmpty')
		self.Unit:CreateEnhancement('ModularRTurretEmpty')
		self.Unit:CreateEnhancement('ModularRightEmpty')
		self.RTurretUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.RTurretUpgradeEntity:SetDrawScale(0.42)
		self.RTurretUpgradeEntity:SetVizToAllies('Intel')
		self.RTurretUpgradeEntity:SetVizToNeutrals('Intel')
		self.RTurretUpgradeEntity:SetVizToEnemies('Intel')
		self.LTurretUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.LTurretUpgradeEntity:SetDrawScale(0.42)
		self.LTurretUpgradeEntity:SetVizToAllies('Intel')
		self.LTurretUpgradeEntity:SetVizToNeutrals('Intel')
		self.LTurretUpgradeEntity:SetVizToEnemies('Intel')
		self.RightUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.RightUpgradeEntity:SetDrawScale(0.42)
		self.RightUpgradeEntity:SetVizToAllies('Intel')
		self.RightUpgradeEntity:SetVizToNeutrals('Intel')
		self.RightUpgradeEntity:SetVizToEnemies('Intel')
		self.LeftUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.LeftUpgradeEntity:SetDrawScale(0.42)
		self.LeftUpgradeEntity:SetVizToAllies('Intel')
		self.LeftUpgradeEntity:SetVizToNeutrals('Intel')
		self.LeftUpgradeEntity:SetVizToEnemies('Intel')
		
		local BeamBuildEmtBp = '/effects/emitters/build_beam_01_emit.bp'
		
		self.LBeam = nil
		self.RBeam = nil
		self.CBeam = nil
		self.CBeam2 = nil
		self.LEffect = nil
		self.REffect = nil
		self.CEffect = nil
		self.CEffect2 = nil
		
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
		
		if self:HasEnhancement( 'MMDefaultSkin' ) then
			self.Unit:CreateEnhancement('ModularDefaultSkin')
		end	
		
		if self:HasEnhancement( 'MMSkin1' ) then
			self.Unit:CreateEnhancement('ModularSkin1')
		end	
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		self.ChassisUpgrade = 'ModularDefaultChassis'
		self.Unit:CreateEnhancement(self.ChassisUpgrade)	
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		self.ChassisUpgrade = 'ModularLTurretChassis'
		self.Unit:CreateEnhancement(self.ChassisUpgrade)
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.ChassisUpgrade = 'ModularRTurretChassis'
		self.Unit:CreateEnhancement(self.ChassisUpgrade)
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.ChassisUpgrade = 'ModularBothTurretsChassis'
		self.Unit:CreateEnhancement(self.ChassisUpgrade)
		end
		
		local number = nil
		local Modpath = '/mods/Mechdivers/Decorations/Modules/Turrets/'
		local LModpath = '/mods/Mechdivers/Decorations/Modules/Left Arm/'
		local RModpath = '/mods/Mechdivers/Decorations/Modules/Right Arm/'
		
		if self:HasEnhancement( 'MMFacEmpty' ) then
		self.SubSystemsUpgrade = 'ModularEmpty'
		end
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) then
		self.LTurretUpgrade = 'ModularLTurretEmpty'
		end
		
		if self:HasEnhancement( 'MMFacRTurretEmpty' ) then
		self.RTurretUpgrade = 'ModularRTurretEmpty'
		end
		
		if self:HasEnhancement( 'MMFacAutocannonTurret' ) then
		self.RTurretUpgrade = 'ModularAutocannonTurret'
		self.RTurretUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.RTurretUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret' ) then
		self.RTurretUpgrade = 'ModularGatlingTurret'
		self.RTurretUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.RTurretUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacAutocannonTurret2' ) then
		self.LTurretUpgrade = 'ModularAutocannonTurret2'
		self.LTurretUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.LTurretUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial04' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret2' ) then
		self.LTurretUpgrade = 'ModularGatlingTurret2'
		self.LTurretUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.LTurretUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial04' )
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) then
		self.RightUpgrade = 'ModularRightEmpty'
		end
		if self:HasEnhancement( 'MMFacRightBalisticShield' ) then
		self.RightUpgrade = 'ModularRightBalisticShield'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_BalisticShield_mesh')
		self.RightUpgradeEntity:AttachBoneTo('BalisticShield_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAntiTankCannon' ) then
		self.RightUpgrade = 'ModularRightAntiTankCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_AntiTankCannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightFlameThrower' ) then
		self.RightUpgrade = 'ModularRightFlameThrower'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Flamethrower_mesh')
		self.RightUpgradeEntity:AttachBoneTo('FlameThrower_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAutoCannon' ) then
		self.RightUpgrade = 'ModularRightAutoCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Autocannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Cannon_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightGatling' ) then
		self.RightUpgrade = 'ModularRightGatling'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Gatling_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Gatling_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightMissileLauncher' ) then
		self.RightUpgrade = 'ModularRightMissileLauncher'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_MissileLauncher_mesh')
		self.RightUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightScatterGun' ) then
		self.RightUpgrade = 'ModularRightScatterGun'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Shotgun_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Launcher_Attach', self.Unit, 'AttachSpecial03')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) then
		self.LeftUpgrade = 'ModularLeftEmpty'
		end
		if self:HasEnhancement( 'MMFacLeftBalisticShield' ) then
		self.LeftUpgrade = 'ModularLeftBalisticShield'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_BalisticShield_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('BalisticShield_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAntiTankCannon' ) then
		self.LeftUpgrade = 'ModularLeftAntiTankCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_AntiTankCannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftFlameThrower' ) then
		self.LeftUpgrade = 'ModularLeftFlameThrower'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Flamethrower_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('FlameThrower_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAutoCannon' ) then
		self.LeftUpgrade = 'ModularLeftAutoCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Autocannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Cannon_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftGatling' ) then
		self.LeftUpgrade = 'ModularLeftGatling'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Gatling_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Gatling_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftMissileLauncher' ) then
		self.LeftUpgrade = 'ModularLeftMissileLauncher'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_MissileLauncher_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftScatterGun' ) then
		self.LeftUpgrade = 'ModularLeftScatterGun'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Shotgun_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Launcher_Attach', self.Unit, 'AttachSpecial02')
		end
		
		 local LeftArmPos = self.Unit:GetPosition('AttachSpecial02')
		 local RightArmPos = self.Unit:GetPosition('AttachSpecial03')
		 local LeftCraneMuzzlePos = self:GetPosition('L_Crane_Muzzle')
		 local RightCraneMuzzlePos = self:GetPosition('R_Crane_Muzzle')
		 
		local XZDist = import("/lua/utilities.lua").XZDistanceTwoVectors
		
		local RightDistance = XZDist(RightCraneMuzzlePos, LeftArmPos)
		local LeftDistance = XZDist(LeftCraneMuzzlePos, RightArmPos)
		
		if LeftDistance > RightDistance then
		     
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		--self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', self.Unit, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial03', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		--self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', self.Unit, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial02', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		
		elseif RightDistance > LeftDistance then
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		--self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', self.Unit, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial02', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		--self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', self.Unit, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial03', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		end
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		--self.CCraneAnim:SetRate(0.5)
		--self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial01', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		--self.CCrane2Anim:SetRate(0.5)
		--self.CCraneSlide2Anim:SetRate(0.3)
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial04', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( self.Unit, 'AttachSpecial04', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		--self.CCraneAnim:SetRate(0.5)
		--self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial04', self:GetArmy(), BeamBuildEmtBp)
		--self.CCrane2Anim:SetRate(0.5)
		--self.CCraneSlide2Anim:SetRate(0.3)
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial04', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( self.Unit, 'AttachSpecial04', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		--self.CCraneAnim:SetRate(0.5)
		--self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		--self.CCrane2Anim:SetRate(0.5)
		--self.CCraneSlide2Anim:SetRate(0.3)
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( self.Unit, 'AttachSpecial01', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		
		if self:HasEnhancement( 'MMFacEmpty' ) == false then
		--self.CCraneAnim:SetRate(0.5)
		--self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		--self.CCrane2Anim:SetRate(0.5)
		--self.CCraneSlide2Anim:SetRate(0.3)
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( self.Unit, 'AttachSpecial01', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		
		local BothTurretsUpgradeEntityPos = self.Unit:GetPosition()
		local LTurretUpgradeEntityPos = self.Unit:GetPosition('AttachSpecial01')
		local RTurretUpgradeEntityPos = self.Unit:GetPosition('AttachSpecial04')
		 
		 
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 90
		end
		
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 0
		end
		
        while self and not self.Dead do
			if number == 90 then
			number = 0
			self.BuildProgress = false
			if self.LBeam then 
			self.LBeam:Destroy()
			end
			if self.RBeam then 
			self.RBeam:Destroy()
			end
			if self.CBeam and self.CBeam2 then 
			self.CBeam:Destroy()
			self.CBeam2:Destroy()
			elseif self.CBeam then
			self.CBeam:Destroy()
			elseif self.CBeam2 then
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect and self.CEffect2 then
			self.CEffect:Destroy()
			self.CEffect2:Destroy()
			elseif self.CEffect then
			self.CEffect:Destroy()
			elseif self.CEffect2 then
			self.CEffect2:Destroy()
			end
			--self.CCraneAnim:SetRate(0)
			--self.CCraneSlideAnim:SetRate(0)
			--self.CCrane2Anim:SetRate(0)
			--self.CCraneSlide2Anim:SetRate(0)
			--self.LCraneAnim:SetRate(0)
			--self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.RTurretUpgradeEntity then
			self.RTurretUpgradeEntity:Destroy()
			end
			if self.LTurretUpgradeEntity then
			self.LTurretUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
			self.Unit:CreateEnhancement(self.LeftUpgrade)
			self.Unit:CreateEnhancement(self.SubSystemsUpgrade)
			self.Unit:CreateEnhancement(self.LTurretUpgrade)
			self.Unit:CreateEnhancement(self.RTurretUpgrade)
			self.Unit:CreateEnhancement(self.RightUpgrade)
			self.Unit:AddCommandCap('RULEUCC_Move')
			self.Unit:AddCommandCap('RULEUCC_Attack')
			self.Unit:AddCommandCap('RULEUCC_Patrol')
			self.Unit:AddCommandCap('RULEUCC_Guard')
			self.Unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.Unit:AddCommandCap('RULEUCC_Stop')
			break
			else
			WaitSeconds(0.1)
			number = number + 1
			end
        end
		WaitSeconds(5)
		
		self:SetBusy(false)
        self:SetBlockCommandQueue(false)
		end
		self:AddToggleCap('RULEUTC_WeaponToggle')
    end,
	

}

TypeClass = CSKMDTL0312